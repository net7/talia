require 'java'
require "#{RAILS_ROOT}/lib/htmlcleaner2_1.jar"

include_class 'org.htmlcleaner.CleanerProperties'
include_class 'org.htmlcleaner.HtmlCleaner'
include_class 'org.htmlcleaner.TagNode'
include_class 'org.htmlcleaner.SimpleXmlSerializer'


class HtmlCleanerWrapper

  def initialize
    # set HTMLCleaner property
    @cleaner_properties = CleanerProperties.new
    @cleaner_properties.setIgnoreQuestAndExclam(true)
    @cleaner_properties.setNamespacesAware(false)
    @cleaner_properties.setUseEmptyElementTags(false)

    # set cleaner
    @cleaner = HtmlCleaner.new(@cleaner_properties);

    # set serializer
    @xml_serializer = SimpleXmlSerializer.new(@cleaner_properties)
  end

  def clean(html)
    # clean the content
    tag_note = @cleaner.clean(html);

    # serialize the content
    content = @xml_serializer.getXmlAsString(tag_note);

    return content

  end

  def self.clean(html)

    return self.new.clean(html)

  end

end
