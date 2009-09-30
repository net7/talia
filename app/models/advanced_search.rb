class AdvancedSearch

  attr_accessor :size, :match_count, :xml_doc
  

  # advanced search for simple edition.
  # Return an array of hash {title, uri, description}
  def search(edition_prefix, edition_uri, edition_id, words, operator, mc = nil, mc_from = nil, mc_to = nil, mc_single = nil, content_required = true, page=nil, limit=nil)

    # load params for query
    data = query_params(edition_uri, words, operator, mc, mc_from, mc_to, mc_single, content_required, page, limit)
    
    # execute query
    doc = execute_query(data)

    # total item and unit
    self.size = doc.root.attribute('total').value
    self.match_count = doc.root.attribute('totalMatch').value

    # get level 2 group
    groups = doc.get_elements('/talia:result//talia:group/talia:entry')
    # collect result. It create an array of hash {title, url, description}
    @result = []
    groups.each do |item|
      # check if full content is present in search result
      if item.elements['talia:full_content'].nil?
        full_content = item.elements['talia:excerpt'].children.to_s
      else
        full_content = item.elements['talia:full_content'].children.to_s
      end

      @result <<  {:title => item.elements['talia:metadata/talia:standard_title'].text,
        :url => "#{N::LOCAL}#{edition_prefix}/#{edition_id}/#{item.elements['talia:metadata/talia:standard_title'].text}",
        :description => item.elements['talia:excerpt'].children.to_s,
        :full_description => full_content,
        :more_occurrence => (item.elements['talia:excerpt'].attributes['more_occurrence'].to_i unless item.elements['talia:excerpt'].attributes['more_occurrence'].nil?) || 0
      }
    end

    #store xml doc into local variable
    self.xml_doc = doc

    #return result
    return @result
  end

  # advanced search for av media.
  # Return an array of hash {title, uri, description, author, date, length, keyword}
  def av_search(title_words, abstract_words = nil, keyword = nil)

    # load params for query
    data = av_query_params(title_words, abstract_words, keyword)

    # execute query
    doc = execute_query(data)

    # total item
    self.size = doc.root.attribute('total').value

    # get level 2 group
    groups = doc.get_elements('/talia:result/talia:entry')
    # collect result. It create an array of hash {title, uri, description, author, date, length, keyword}
    result = groups.collect do |item|
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

    # return value
    return result

  end

  def menu_for_search(edition_uri, words, operator, mc = nil, mc_from = nil, mc_to = nil)
    #    search(edition_prefix, edition_id, words, operator, mc, mc_from, mc_to, nil, false)

    # load params for query
    data = query_params(edition_uri, words, operator, mc, mc_from, mc_to, nil, false)

    # execute query
    doc = execute_query(data)


    return doc.get_elements('/talia:result/talia:group')
  end

  private

  def query_params(edition_uri, words, operator, mc = nil, mc_from = nil, mc_to = nil, mc_single = nil, content_required = true, page=nil, limit=nil)

    # collect data to post
    data = {
      'search_type' => 'mc',
      'operator' => operator
    }

    # check if words field is empty
    if words
      data['words'] = words
    end

    # add mc - mc_from - mc_to if specified
    if mc_from
      # tranlate mc_from and mc_to
      mc_from_search_key = mc_from.collect do |uri|
        uri = self.class.search_key(uri)
      end

      mc_to_search_key = mc_to.collect do |uri|
        uri = self.class.search_key(uri)
      end

      data['mc'] = ''
      if (mc_single.nil? || mc_single == "")
        # if mc_single is not present, add all mc_from and mc_to
        data['mc_from'] = mc_from_search_key
        data['mc_to'] = mc_to_search_key
      else
        # else add only restrinctions compatible with mc_single
        data['mc_from'] = []
        data['mc_to'] = []
        
        # get mc_single object
        mc_single_object = TaliaCore::Source.find(mc_single)
        # if mc_single object is a book, add only restrinctions compatible with it
        if (mc_single_object.type == "Book")
          # for each mc, if mc is equal to mc_single, add it to search criteria
          mc.each_with_index do |item, index|
            if(item == mc_single)
              data['mc_from'].push(mc_from_search_key[index])
              data['mc_to'].push(mc_to_search_key[index])
            end
          end
        else
          data['mc_single'] = mc_single
        end
      end
    else
      data['mc'] = edition_uri
    end

    # add mc_single if specified
    if mc_single
      unless mc_from
        data['mc_single'] = mc_single
      end
    end

    # require content
    if content_required
      data['content_required'] = true
    end

    # for result pagination, this indicates the page to show
    if page
      data['page'] = page
    end

    # for result pagination, this is the number of result per page
    if limit
      data['limit'] = limit
    end

    return data
  end

  def av_query_params(title_words, abstract_words = nil, keyword = nil)
    # collect data to post
    data = {'search_type[]' => 'media'}

    # check if words field is empty
    if title_words
      data['title_words'] = title_words
    end

    # check if words field is empty
    if abstract_words
      data['abstract_words'] = abstract_words
    end

    # check if words field is empty
    if keyword
      data['keyword'] = keyword
    end

    # require content
    data['content_required'] = true

    return data
  end

  def execute_query(data)
    # load exist options.
    exist_options = TaliaCore::CONFIG['exist_options']
    raise "eXist configuration not found." if exist_options.nil?

    # execute post to servlet
    uri = URI.parse(URI.join(exist_options['server_url'],"/#{exist_options['community']}/Search").to_s)
    if !exist_options['server_login'].nil? && !exist_options['server_password'].nil?
      uri.user = exist_options['exist_login']
      uri.password = exist_options['exist_password']
    end
    resp = Net::HTTP.post_form_hack uri, data

    # error check
    raise "#{resp.code}: #{resp.message}" unless resp.kind_of?(Net::HTTPSuccess)

    # get response xml document
    doc = REXML::Document.new resp.body

    # return response
    return doc
  end

  def self.search_key(uri)
    
    material = TaliaCore::Source.find(uri)

    result = []

    # add macrocontribution siglum to search_key
    result << material.hyper.in_catalog[0].uri.local_name

    # add book string and position
    if !material.book.nil?
      result << "book"
      result << material.book.position_for_search_key
      result << material.book.uri.local_name
    end
    
    # add chapter string and position
    if !material.chapter.nil?
      result << "chap"
      result << material.chapter.position_for_search_key
      result << material.chapter.uri.local_name
    else
      result << "chap"
      result << "000000"
      result << ""
    end

    # add page or paragraph and position
    case material
    when TaliaCore::Page
      result << "page"
      result << material.position_for_search_key
      result << material.uri.local_name
    when TaliaCore::Paragraph
      result << "para"
      result << material.position_for_search_key
      result << material.uri.local_name
    else
      result << '000000'
    end

    return result.join(".")
  end

end

module Net
  
  class HTTP < Protocol

    def HTTP.post_form_hack(url, params)
      req = Post.new(url.path)
      req.set_form_data_hack params
      req.basic_auth url.user, url.password if url.user
      new(url.host, url.port).start {|http|
        http.request(req)
      }
    end
    
  end

  module HTTPHeader

    # Hack for correct a bug into set_form_data method.
    # Now params can contain also Arrays
    def set_form_data_hack(params, sep = '&')
      self.body = params.map do |k,v|
        if v.class == Array
          v.collect do |sub_v|
            "#{urlencode(k.to_s + '[]')}=#{urlencode(sub_v.to_s)}"
          end.join(sep)
        else
          "#{urlencode(k.to_s)}=#{urlencode(v.to_s)}"
        end
      end.join(sep)
      self.content_type = 'application/x-www-form-urlencoded'
    end
  
  end
end