class AdvancedSearch

  attr_accessor :size, :xml_doc
  

  # advanced search for simple edition.
  # Return an array of hash {title, uri, description}
  def search(edition_prefix, edition_id, words, operator, mc = nil, mc_from = nil, mc_to = nil, mc_single = nil, content_required = true)

    # load params for query
    data = query_params(words, operator, mc, mc_from, mc_to, mc_single, content_required)

    # execute query
    doc = execute_query(data)

    # total item
    self.size = doc.root.attribute('total').value

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
    data = query_params(title_words, abstract_words, keyword)

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

  def menu_for_search(words, operator, mc = nil, mc_from = nil, mc_to = nil)
    #    search(edition_prefix, edition_id, words, operator, mc, mc_from, mc_to, nil, false)

    # load params for query
    data = query_params(words, operator, mc, mc_from, mc_to, nil, false)

    # execute query
    doc = execute_query(data)


    return doc.get_elements('/talia:result/talia:group')
  end

  private

  def query_params(words, operator, mc = nil, mc_from = nil, mc_to = nil, mc_single = nil, content_required = true)
    # collect data to post
    data = {
      'search_type' => 'mc',
      'operator' => operator
    }

    # check if words field is empty
    if words
      # late minute hack, eliminates ' and "
      #TODO: revert to a proper solution
      data['words'] = words.gsub(/["']/, ' ')
    end

    # add mc - mc_from - mc_to if specified
    if mc_from
      data['mc'] = ''
      data['mc_from'] = mc_from
      data['mc_to'] = mc_to
    else
      data['mc'] = mc
    end

    # add mc_single if specified
    if mc_single
      data['mc_single'] = mc_single
    end

    # require content
    if content_required
      data['content_required'] = true
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