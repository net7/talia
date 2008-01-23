require 'talia_core/local_store/data_record'
require 'rexml/document'

begin
  # if tidy is not present, disable it
  require 'tidy'
  
  # if tidylib path is not set, disable tidy
  if ENV['TIDYLIB'].nil?
    Tidy_enable = false
  else
    Tidy.path = ENV['TIDYLIB']
  end
  
  # enable tidy
  Tidy_enable = true
rescue
  # disable tidy
  Tidy_enable = false
end

if ENV['TIDYLIB'].nil?
  Tidy_enable = false
else
  Tidy.path = ENV['TIDYLIB']
end
      

module TaliaCore
  
  # Class to manage XML and HTML data type
  class XmlData < DataRecord
    
    # include the module to work with files
    # TODO: paramterize this. If we'll have to work with file inculde the following
    #       otherwise, include the database mixin
    include FileStore

    # return the mime_type for this specified class
    def mime_type
      case File.extname(get_file_path)
      when '.htm', '.html','.xhtml'
        'text/html'
      when '.hnml'
        'text/hnml'
      when '.xml'
        'text/xml'
      end
    end
    
    # return the mime subtype for this specified class
    def mime_subtype
      mime_type.split(/\//)[1]
    end    
    
    # returns all bytes in the object as an array
    def all_bytes
      read_all_bytes
    end
    
    # returns the complete text
    def all_text
      if(!is_file_open?)
        open_file
      end
      @file_handle.read(self.size)
    end

    # returns the next byte from the object, or nil at EOS
    def get_byte(close_after_single_read=false)
      get_next_byte(close_after_single_read)
    end

    # returns the current position of the read cursor (binary access)
    def position
      return (@position != nil) ? @position : 0
    end
   
    # reset the cursor to the initial state
    def reset
      set_position(0)
    end
    
    # set the new position of the reding cursors
    def seek(new_position)
      set_position(new_position)
    end
    
    # returns the size of the object in bytes
    def size
      get_data_size
    end
    
    # Additional methods for this specific class ====================================

    # return contect of the object as REXML::Elements
    def get_content(options = nil)
      document = REXML::Document.new all_text
      
      # get content
      if mime_subtype == "html"
        content = document.elements['//body'].elements
      elsif ((mime_subtype == "xml") or (mime_subtype == "hnml"))
        content = document.root.elements
      end
      
      # adjust/replace items path
      content.each { |i| wrapImg i }
      
      # return content
      return content
    end
    
    # Returns an xml string of the elements returned by get_content
    def get_content_string(options = nil)
      xml_str = ''
      get_content(options).each do |element|
        xml_str += element.to_s
      end
      xml_str
    end
    
    # Add data as string into file
    def create_from_data(location, data, options = {:tidy => true})
      # check tidy option
      if (((options[:tidy] == true) and (Tidy_enable == true)) and 
          ((File.extname(location) == '.htm') or (File.extname(location) == '.html') or (File.extname(location) == '.xhtml')))        
        
        # apply tidy on data
        data_to_write = Tidy.open(:show_warnings => false) do |tidy|
                  tidy.options.output_xhtml = true
                  tidy.options.tidy_mark = false
                  xhtml = tidy.clean(data)
                  xhtml
        end
      else
        data_to_write = data
      end
      
      # write data
      super(location, data_to_write, options)
    end
    
    private
    # adjusted/replaced items path
    def wrapImg item
      if item.class == REXML::Element
        # recursive execution
        item.each_child { |subItem| wrapImg subItem}
    
        case item.name
        when "img"
          if item.attributes.include? "src"
            # get path
            path = Pathname.new(item.attributes['src']).split
            # adjust src attribute
            item.attributes['src'] = File.join("image_data",path[1].to_s) if path[0].relative?
          end
        when "a"
          if item.attributes.include? "href"
            # get path
            path = Pathname.new(item.attributes['href']).split
            # adjust href attribute
            case File.extname(path[1].to_s)
            when ".txt"
              item.attributes['href'] = File.join("simple_text", path[1].to_s) if path[0].relative?
            when '.htm', '.html','.xhtml','.hnml','.xml'
              item.attributes['href'] = File.join("xml_data", path[1].to_s) if path[0].relative?
            end
          end
        end
       
      end
    end
    
  end
end
