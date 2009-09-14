module Admin::BackgroundHelper
  
  def render_job
    case(@job.state)
    when 'finished'
      render :partial => 'finished'
    when 'running'
      render :partial => 'running'
    when 'pending'
      render :partial => 'pending'
    else
      "Unknown state #{@job.state}"
    end
  end
  
  def progress_eta
    return 'Finishing...' unless(@progress_job.percentage < 100)
    ('ETA: ' + duration_s(@progress_job.eta)).gsub(' ', '&nbsp;')
  end
  
  def job_tag
    "- #{@job.tag}" if(@job.tag)
  end
  
  def job_duration
    finished = @job.finished_at || Time.now
    duration_s(finished - @job.started_at)
  end
  
  def job_link
    link_to('Back to job', :action => 'show', :id => @job.id)
  end
  
  def stdout_link
    link_to('View STDOUT', :action => 'stdout', :id => @job.id) unless(@job.stdout.blank?)
  end
  
  def stderr_link
    link_to('View STDERR', :action => 'stderr', :id => @job.id) unless(@job.stderr.blank?)
  end
  
  def stdin_link
    link_to('View STDIN', :action => 'stdin', :id => @job.id) unless(@job.stdin.blank?)
  end
  
  def environment_link
    link_to('Runtime Environment', :action => 'environment', :id => @job.id) unless(@job.env.blank?)
  end
  
  def duration_s(seconds)
    minutes, seconds = seconds.divmod(60)
    hours, minutes = (minutes == 0) ? [0, 0] : minutes.divmod(60)
    duration_s = ''
    (duration_s << "#{hours.to_i} hours ") if(hours != 0)
    (duration_s << "#{minutes.to_i} minutes ") if(minutes != 0)
    duration_s << "#{seconds.to_i} seconds"
    duration_s
  end
  
end
