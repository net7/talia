module SourcesHelper
  
  # Renders the data
  def render_source_data
    result = ""
    if(@source.data_records.size > 0)
      @source.data_records.each do |data_record|
        case(data_record.mime_type)
        when 'text/html'
          result += "<h3>HTML Data: #{data_record.location}</h3>"
          result += "<div>"
          result += widget(:html_data, :data => data_record)
          result += "</div>"
        when 'text/xml'
          result += "<pre><code>"
          result += data_record.get_escaped_content_string
          result += "</code></pre>"
        when 'text/plain'
          result += "<h3>Plain Text Data: #{data_record.location}</h3>"
          result += "<pre> #{data_record.all_text} </pre>"
        else
          result += "<h3>Found data object of type #{data_record.class} (#{data_record.mime_type}): #{data_record.location}</h3>"
        end
      end
    else
      result ="<h3>Sorry mate, no data objects here</h3>"
    end
    
    result
  end
end
