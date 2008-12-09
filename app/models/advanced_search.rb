class AdvancedSearch

  # advanced search for av media.
  # Return an array of hash {title, uri, description, author, date, length, keyword}
  def av_search(title_words, abstract_words, keyword)
    # collect data to post
    data = {'search_type[]' => 'media'}

    # check if words field is empty
    if title_words
      data['title_words[]'] = title_words
    end

    # check if words field is empty
    if abstract_words
      data['abstract_words[]'] = abstract_words
    end

    # check if words field is empty
    if keyword
      data['keyword[]'] = keyword
    end

    # load exist options.
    exist_options = TaliaCore::CONFIG['exist_options']
    raise "eXist configuration not found." if exist_options.nil?

    # execute post to servlet
    resp = Net::HTTP.post_form URI.parse(URI.join(exist_options['server_url'],"/#{exist_options['community']}/Search").to_s), data

    # error check
    raise "#{resp.code}: #{resp.message}" unless resp.kind_of?(Net::HTTPSuccess)

    # return xml document
    doc = REXML::Document.new resp.body

    # total item
    @result_count = doc.root.attribute('total').value

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

end