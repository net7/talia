require "sprockets"
# require "sprockets_helper" HACK for Rails 2.0.5 compatibility
require "sprockets_application"

# HACK for Rails 2.0.5 compatibility
module Rails
  @public_path = File.join(RAILS_ROOT, 'public')
  mattr_reader :public_path
end
