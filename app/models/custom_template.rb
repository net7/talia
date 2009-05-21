class CustomTemplate < ActiveRecord::Base
  validates_presence_of :name, :content
  validates_format_of :template_type, :with => /css|xslt/
end
