# TaliaCore loader

# adding talia_core subdirectory to the ruby loadpath  
file = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
this_dir = File.dirname(File.expand_path(file))
$: << this_dir
$: << this_dir + '/talia_core/'
