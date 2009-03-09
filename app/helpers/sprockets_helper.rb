# TODO remove this file when update to Rails 2.3.x
module SprocketsHelper
  def sprockets_include_tag
    javascript_include_tag("/sprockets.js")
  end
end
