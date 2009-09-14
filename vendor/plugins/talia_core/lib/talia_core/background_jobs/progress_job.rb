module TaliaCore
  module BackgroundJobs
    
    # Helper table to track the current status of a long-running task
    class ProgressJob < ActiveRecord::Base
      
      # Minimum interval for database updates. 
      DB_UPDATE_INTERVAL = 2
      
      validates_numericality_of :job_id, :only_integer => true
      validates_numericality_of :processed_count, :only_integer => true, :greater_than_or_equal => 0
      validates_numericality_of :item_count, :only_integer => true, :greater_than => 0
      
      # Create a new progress job
      def self.create_progress!(job_id, message = '', item_count = 1)
        job_prog = new(:job_id => job_id, :progress_message => message, :item_count => item_count, :processed_count => 0)
        job_prog.save!
        job_prog
      end
      
      # Clears the progress for processes no longer active
      def self.clear
        find(:all).each do |job_prog|
          delete(job_prog.id) if(!Bg.table.job.exists?(job_id) || Bg.tablejob.find(job_id).finished?)
        end
      end
      
      # Increments the number of processed items. To avoid flooding the db, the same object will
      # only save this value at most all DB_UPDATE_INTERVAL seconds. Will return true if the
      # element was saved, false otherwise. 
      def inc(inc_value = 1)
        pc_old = self.processed_count
        self.processed_count = pc_old + inc_value
        if(!@last_update || ((Time.now - @last_update) > DB_UPDATE_INTERVAL))
          save!
          @last_update = Time.now
          true
        else
          false
        end
      end
      
      def finish
        self.processed_count = self.item_count
        save!
      end
      
      # The percentage completed
      def percentage
        [((self.processed_count * 100) / self.item_count), 100].min
      end
      
      # Elapsed time in seconds
      def elapsed
        return unless(self.started_at)
        Time.now - started_at
      end
      
      # Returns the estimated time remaining on the current job
      def eta
        ((elapsed * 100) / percentage) - elapsed
      end
      
      
    end
    
  end
end