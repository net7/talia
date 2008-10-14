module KeywordsHelper
  
  def tag_cloud(keywords)
    render(:partial => 'shared/tag_cloud', :object => keywords)
  end
  
  def translate_keyword(keyword)
    t(:"talia.keywords.#{keyword.keyword_value}")
  end
  
end
