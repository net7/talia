# Helper module for downloading Hyper export files
require 'rexml/document'
require 'open-uri'
require 'fileutils'

module HyperDownload
  
  class Downloader
    
    # Creates a new downloader. Data will be read from the given URL and
    # save it to the given path.
    def initialize(output_path,
                   url = 'http://www.nietzschesource.org/exportToTalia.php?get=',
                   login = 'nietzsche',
                   password = 'source'
        )
      @output_path = output_path
      @fetch_url = url # URL to fetch from
      @auth = [login, password] # HTTP authentication for url
      @data_path = File.join(@output_path, 'data')
      FileUtils.mkpath(@data_path)
    end
    
    # Mode used for linked files. :skip will just skip them, :touch will create
    # an empty file (instead of actually downloading the file) and :load will
    # actually download the whole file. Default is :load.
    def file_mode
      @file_mode || :load
    end
    
    # Sets the mode to load files
    def file_mode=(mode)
      mode = mode.to_sym
      raise(ArgumentError, "Illegal mode #{mode}") unless([:skip, :touch, :load].include?(mode))
      @file_mode = mode
    end
    
    # Grabs the siglum from the export URL
    def grab_siglum(siglum)
      siglum_enc = URI.escape(siglum)
      open(@fetch_url + siglum_enc, :http_basic_authentication => @auth) do |io|
  
        xml_el_doc = REXML::Document.new(io)
        load_file(xml_el_doc) unless(file_mode == :skip)
        File.open(File.join(@output_path, "#{siglum_enc}.xml"), 'w') do |file|
          xml_el_doc.write(file)
        end
      end
    end

    private
    
    # Checks for and loads a connected data file
    def load_file(xml_doc)
      file_url_el = xml_doc.root.elements['file_url']
      file_name_el = xml_doc.root.elements['file_name']
      return unless(file_url_el && file_name_el)
      
      file_url = file_url_el.text
      file_name = file_name_el.text
      
      # Update the XML
      file_url_el.text = File.join('data', file_name)
      
      # check if we need to download the file or only touch it
      if(file_mode == :touch)
        FileUtils.touch(File.join(@data_path, file_name))
        return
      end
  
      puts("fetching file from #{file_url} to #{file_name}")
  
      # download the new file
      file_url.gsub!(/\[/, '%5B') # URI class doesn't like unescaped brackets
      file_url.gsub!(/\]/, '%5D')
      open(file_url, :http_basic_authentication => ["nietzsche", "source"]) do |io|
        open(File.join(@data_path, file_name), 'w') do |file|
          file << io.read
        end
      end
      
    end
  end
end