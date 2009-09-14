class Admin::BackgroundController < ApplicationController
  layout 'admin', :except => [:update_progress]
  require_role 'admin'
  
  active_scaffold 'Bj::Table::Job' do |config|
    # runner = Bj::Runner.ping
    runner_label = "no runner active"
    config.label = "Job Management (#{runner_label})"
    
    if(!Bj.config[Bj::Runner.no_tickle_key])
      config.action_links.add('tickle', :label => 'Tickle Runner', :action => 'tickle', :parameters => {:id => '0'})
    end
    
    config.actions.exclude :create, :update, :delete
    config.show.link.inline = false
    config.columns = [ :state, :tag, :pid, :submitter, :runner, :submitted_at ]
  end
  
  def tickle
    Bj::Runner.tickle
    redirect_to :action => 'index'
  end
  
  def show
    @job = Bj::Table::Job.find(params['id'])
  end
  
  def stdin
    @job = Bj::Table::Job.find(params['id'])
  end
  
  def stdout
    @job = Bj::Table::Job.find(params['id'])
  end
  
  def stderr
    @job = Bj::Table::Job.find(params['id'])
  end
  
  def environment
    @job = Bj::Table::Job.find(params['id'])
    @environment = @job.env ? YAML.load(@job.env) : nil
  end
  
  def update_progress
    @job = Bj::Table::Job.find(params['id'])
    @progress_job = TaliaCore::BackgroundJobs::ProgressJob.find(:first, :conditions => { :job_id => @job.id })
    render :partial => 'progress'
  end
end
