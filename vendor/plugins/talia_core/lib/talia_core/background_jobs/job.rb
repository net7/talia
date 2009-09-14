module TaliaCore
  module BackgroundJobs

    # Exception class for blocked jobs
    class JobBlockedError < RuntimeError
    end

    # A Background job run from Talia. The Job class is designed to be able to run long-running
    # tasks both from the command line and Talia's background job runner.
    class Job
      
      # Creates a background job with progress metering. If a tag is given, it will attempt to block
      # the creation of further jobs with the same tag. This will also use the runner script, called
      # with the current ruby binary
      def self.submit_with_progress(jobs, options = {})
        # add the runner script and ruby call to the jobs
        jobs = make_jobs(jobs)
        Bj.submit(jobs, options) do |job|
          if(tag = job.tag)
            tagged = Bj.table.job.find(:all, :conditions => ["(state != 'finished' and state != 'dead' and tag = ?)", tag])
            # The error will break the transation and leave the db in a clean state
            raise(JobBlockedError, "Tried to create another job with tag #{tag}.") unless(tagged.size == 1)
          end
          # Update the environment so the runner can find the job id
          job.env['JOB_ID'] = job.id.to_s
          job.save! 
          job
        end
      end
      
      # Runs the block with an active progress meter, creating the progress object before starting, and
      # deleting it from the db after completion. This way the progress_jobs table should remain mostly
      # clean. The with_progress job can only be used inside this.
      def self.run_progress_job
        job_id = ENV['JOB_ID']
        raise(RuntimeError, 'Cannot run job: Job id not given or non-existent') unless(job_id && Bj.table.job.exists?(job_id))
        ProgressJob.create_progress!(job_id) unless(ProgressJob.exists?(:job_id => job_id))
        yield
      ensure
        job_id = ENV['JOB_ID']
        ProgressJob.delete(:job_id => job_id)
      end

      # Runs the block with the progress meter for the current job. This may be used multiple times.
      def self.with_progress(message, item_count)
        job_id = ENV['JOB_ID']
        # Create the progress meter
        progress = ProgressJob.find(:first, :conditions => {:job_id => job_id})
        raise(RuntimeError, 'Progress meter not found for job.') unless progress
        progress.update_attributes(:item_count => item_count, :progress_message => message, :processed_count => 0, :started_at => Time.now)

        yield(progress)

        progress.finish
      end

      private
      
      def self.ruby
        return @ruby if(@ruby)
        c = ::Config::CONFIG
        ruby = File.join(c['bindir'], c['ruby_install_name']) << c['EXEEXT']
        @ruby = if system('%s -e 42' % ruby)
          ruby
        else
          system('%s -e 42' % 'ruby') ? 'ruby' : warn('no ruby in PATH/CONFIG')
        end
      end
      
      # Make the caller line for each job
      def self.make_jobs(jobs)
        jobs = [ jobs ] unless(jobs.kind_of?(Array))
        jobs.collect { |current_job| "#{ruby} #{File.join('.', 'script', 'runner')} #{File.join('jobs', current_job)}" }
      end

    end

  end
end