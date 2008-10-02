class HtmlDataWidget < Widgeon::Widget
  
  # The widget may be passed a data object directly, or it can look the data
  # up by location. 
  def on_init
    assit(@data || @location) # we must have either the data object itself, or a location
    
    @data ||= DataRecord.find(:first, :conditions => ["type = 'XmlData' AND location = ?", @location ])
    assit_kind_of(TaliaCore::DataTypes::XmlData, @data)
    
    if(@data.mime_type == 'text/html')
      @content = data.get_content_string
    else
      @content = "<b>Error: Data object at location #{@location} is '#{data.mime_type}'</b>"
    end
  end
end