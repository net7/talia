class AvMediaSweeper < ActionController::Caching::Sweeper
  observe TaliaCore::AvMedia
  
  def after_save(record)
    I18n.available_locales.each do |locale|
      expire_action(:controller => "/av_media_sources", :action => 'show', :id => record.local_name, :locale => locale)
    end
  end
end
