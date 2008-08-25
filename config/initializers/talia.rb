TaliaCore::Initializer.environment = ENV['RAILS_ENV']
TaliaCore::Initializer.run("talia_core") do |config|
  # URI for the IIP server instance
  config['iip_server_uri'] = 'http://localhost/fcgi-bin/iipsrv.fcgi'
  # The external vips command that needs to be called to create the pyramid images
  config['iip_command'] = '/opt/local/bin/vips'
  # Thumbnail size for IIP thumbnails 
  config['thumb_options'] = { :width => '128', :height => '128' }
  # The root directory for the IIP-served images
  # config['iip_root_directory_location'] = 'TALIA_ROOT/iip_root'
  # The directory for "normal" data files
  # config['data_directory_location'] = 'TALIA_ROOT/data'
end

TaliaCore::SITE_NAME = 'DiscoverySource'
