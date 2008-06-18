# Rake tasks to bootstrap a talia-rails installation
$: << File.join('vendor', 'plugins', 'talia_core', 'lib')

namespace :talia do

    # Help info
  desc "Bootstrap a Talia Rails application"
  task :init_app => ["db:create", "db:migrate", "globalize:create_tables"]

end