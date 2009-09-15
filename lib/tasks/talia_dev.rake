require 'rake'
require 'fileutils'
require File.dirname(__FILE__) + '/devtasks_helpers'

# Tasks for bootstrapping the devlopment environment
namespace :talia_dev do
  
  desc "Setup the devlopment environment. [git_writeable=yes] [fetch_jruby=yes] [git_path=<path>]"
  task :setup_environment do
    if(DTH.flag?('git_writeable'))
      FileUtils.mv('.gitmodules', '.gitmodules.standard')
      FileUtils.mv('.gitmodules.developer', '.gitmodules')
    end
    begin
      DTH.run_git_command('submodule init')
      DTH.run_git_command('submodule update')
    ensure
      if(DTH.flag?('git_writeable'))
        FileUtils.mv('.gitmodules', '.gitmodules.developer')
        FileUtils.mv('.gitmodules.standard', '.gitmodules')
      end
    end
    system('sh ./fetch-jruby.sh') if(DTH.flag?('fetch_jruby'))
  end
end