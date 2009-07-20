module ActionView
  module Helpers
    module CaptureHelper

      # content_for? simply checks whether any content has been captured yet using content_for
      # Useful to render parts of your layout differently based on what is in your views.
      # ==== Examples
      #
      # Perhaps you will use different css in you layout if no content_for :right_column
      #
      #   <%# This is the layout %>
      #   <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      #   <head>
      #	    <title>My Website</title>
      #	    <%= yield :script %>
      
      #   </head>
      #   <body class="<%= content_for?(:right_col) ? 'one-column' : 'two-column' %>">
      #     <%= yield %>
      #     <%= yield :right_col %>
      #   </body>
      #   </html>
      def content_for?(name)
        !(instance_variable_get("@content_for_#{name}").blank?)
      end
      
    end
  end
end
