module KeywordsHelper
  
  def tag_cloud(keywords)
    render(:partial => 'shared/tag_cloud', :object => keywords)
  end
  
end
