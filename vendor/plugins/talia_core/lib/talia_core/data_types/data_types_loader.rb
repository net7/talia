# A simple script used to 'load' all data types supported by Talia

# excluded file
to_exclude = ['file_store.rb']

# get all supported data types and include them
Dir[File.join(File.dirname(__FILE__),'*.{rb}')].each{|file|
  if !to_exclude.include?(file)
    require file
  end
}


