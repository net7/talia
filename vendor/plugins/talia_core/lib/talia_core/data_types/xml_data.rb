require 'talia_core/local_store/data_record'
require 'talia_core/data_types/file_store'
require 'rexml/document'
# require 'xml/xslt'

begin
  # if tidy is not present, disable it
  require 'tidy'
  
  # Tidy_enable constant is not defined?
  if ((defined? Tidy_enable) == nil)
    if ENV['TIDYLIB'].nil?
      # disable tidy
      Tidy_enable = false
    else
      # set path and enable tidy
      Tidy.path = ENV['TIDYLIB']
      Tidy_enable = true
    end
  end

rescue LoadError
  # disable tidy
  Tidy_enable = false if ((defined? Tidy_enable) == nil)
end
      

module TaliaCore
  
  # Class to manage XML and HTML data type
  class XmlData < DataRecord
    
    # include the module to work with files
    # TODO: paramterize this. If we'll have to work with file inculde the following
    #       otherwise, include the database mixin
    #include FileStore

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
    # * options: Options for getting context. Default nil.
    # * options[:xsl_file]: xsl file path for transformation.
    def get_content(options = nil)
      text_to_parse = all_text
      
      if (!options.nil?)
        # if xsl_file option is specified, execute transformation
        if (!options[:xsl_file].nil?)
          text_to_parse = xslt_transform(get_file_path, options[:xsl_file])
        end
      end
      
      # create document object
      document = REXML::Document.new text_to_parse
      
      # get content
      if ((mime_subtype == "html") or 
          ((mime_subtype == "xml") and (!options.nil?) and (!options[:xsl_file].nil?)))
        content = document.elements['//body'].elements
      elsif ((mime_subtype == "xml") or (mime_subtype == "hnml"))
        content = document.root.elements
      end
      
      # adjust/replace items path
      content.each { |i| wrapItem i }
      
      # return content
      return content
    end
    
    # Returns an xml string of the elements returned by get_content
    def get_content_string(options = nil)
      xml_str = ''
      get_content(options).each do |element|
        xml_str << element.to_s
      end
      xml_str
    end
    
    # Returns an xml string that is escaped for HTML inclusing
    def get_escaped_content_string(options = nil)
      get_content_string(options).gsub(/</, "&lt;").gsub(/>/, "&gt;")
    end
    
    # Add data as string into file
    # * location: destination file to write
    # * data: data to write
    # * options: options
    # * options[:tidy]: enable or disable tidy (convert html into xhtml). Default value is true
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
    # * item: REXML::Element to parse
    def wrapItem item
      if item.class == REXML::Element
        # recursive execution
        item.each_child { |subItem| wrapItem subItem}
    
        case item.name
        when "img"
          if item.attributes.include? "src"
            # get path
            path = Pathname.new(item.attributes['src']).split
            # adjust src attribute
            item.attributes['src'] = "/source_data/image_data/#{path[1].to_s}" if path[0].relative?
          end
        when "a"
          if item.attributes.include? "href"
            # get path
            path = Pathname.new(item.attributes['href']).split
            # adjust href attribute
            case File.extname(path[1].to_s)
            when ".txt"
              item.attributes['href'] = "/source_data/simple_text/#{path[1].to_s}" if path[0].relative?
            when '.htm', '.html','.xhtml','.hnml','.xml'
              item.attributes['href'] = "/source_data/xml_data/#{path[1].to_s}" if path[0].relative?
            end
          end
        end
       
      end
    end
    
    # execute xslt transformation
    # * document: xml document. Can be file path as string or REXML::Document
    # * xsl_file: xsl file for transformation. Can be file path as string or REXML::Document
    def xslt_transform(document, xsl_file)
      xslt = XML::XSLT.new()
      # get xml document
      xslt.xml = document
      # get xslt document
      xslt.xsl = xsl_file

      # return transformation output
      return xslt.serve()      
    end
    
  end
end
