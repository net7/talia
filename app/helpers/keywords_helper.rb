module KeywordsHelper
  # Courtesy of acts_as_taggable_on_steroids team
  # http://svn.viney.net.nz/things/rails/plugins/acts_as_taggable_on_steroids
  def tag_cloud(keywords, classes)
    return if keywords.empty?

    max_count = keywords.sort_by(&:count).last.count.to_f

    keywords.each do |keyword|
      index = ((keyword.count.to_i / max_count) * (classes.size - 1)).round
      yield keyword, classes[index]
    end
  end

  def translate_keyword(keyword)
    t(:"talia.keywords.#{keyword.keyword_value}")
  end
  
end
