class SeriesController < ApplicationController

  layout 'simple_page'
  
  def show
    element_uri = N::LOCAL + 'series/' + params[:id]
    raise(ArgumentError, "Unknow Series #{element_uri}") unless(TaliaCore::Series.exists?(element_uri))
    
    @element = TaliaCore::Series.find(element_uri)
    @path = [ { :text => 'Series', :link => 'series/' }, { :text => @element.hyper::name.first } ]
    @title = t(:'talia.global.series') + " | #{@element.hyper::name.first }"
    @subtitle = t(:'talia.global.series')
  end

  def index
    @path = [ { :text => 'Series' }]
    @series = TaliaCore::Series.find(:all)
    @title = t(:'talia.global.series')
    @subtitle = t(:'talia.global.series')
  end
  
  def advanced_search
    @path = []
    
    # if user has clicked on seach button, execute search method
    unless params[:advanced_search_submission].nil?
      # check if there are the params
      if (params[:title_words].nil? or params[:title_words].join.strip == "") && 
         (params[:abstract_words].nil? or params[:abstract_words].join.strip == "") && 
         (params[:keyword].nil? or params[:keyword].join.strip == "")
        redirect_to(:back) and return
      end
      
      # collect data to post
      data = {'search_type[]' => params[:search_type]}
      
      # check if words field is empty 
      if params[:title_words]
        data['title_words[]'] = params[:title_words]
      end
      
      # check if words field is empty 
      if params[:abstract_words]
        data['abstract_words[]'] = params[:abstract_words]
      end
      
      # check if words field is empty 
      if params[:keyword]
        data['keyword[]'] = params[:keyword]
      end
      
      # load exist options.
      exist_options = TaliaCore::CONFIG['exist_options']
      raise "eXist configuration not found." if exist_options.nil?
      
      # execute post to servlet
      resp = Net::HTTP.post_form URI.parse(URI.join(exist_options['server_url'],"/#{exist_options['community']}/Search").to_s), data
      
      # error check
      raise "#{resp.code}: #{resp.message}" unless resp.kind_of?(Net::HTTPSuccess)
     
      # get response xml document
      doc = REXML::Document.new resp.body
      
      # total item
      @result_count = doc.root.attribute('total').value
      
      # get level 2 group
      groups = doc.get_elements('/talia:result/talia:entry')
      # collect result. It create an array of hash {title, description}
      @result = groups.collect do |item|
        # collect keywords
        keywords = item.elements['talia:metadata/talia:keywords'].collect do |keyword|
          {:uri => TaliaCore::Keyword.uri_for(keyword.text), :value => keyword.text}
        end
        # collect authors
        authors = item.elements['talia:metadata/talia:authors'].collect do |author|
          author.children.to_s
        end
        {:title => item.elements['talia:metadata/talia:title'].children.to_s, 
          :uri => item.elements['talia:metadata/talia:uri'].text,
          :description => item.elements['talia:version/talia:content/talia:abstract'].children.to_s,
          :author => authors.join(", "),
          :date => item.elements['talia:metadata/talia:date'].text,
          :length => item.elements['talia:metadata/talia:length'].text,
          :keyword => keywords
        }
      end
      
    end
  end
  
end
