class SourceSweeper < ActionController::Caching::Sweeper
  observe TaliaCore::Source
  
  def after_save(record)
    expire_action(:controller => "/sources", :action => "show", :id => record.uri.local_name)
  end
end
