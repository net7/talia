class CategoriesController < ApplicationController

  def show
    cat_uri = N::LOCAL + request.request_uri[1..-1]
    raise(ArgumentError, "Unknow Category #{cat_uri}") unless(TaliaCore::Category.exists?(cat_uri))
    
    @category = TaliaCore::Category.find(cat_uri)
    @all_categories = TaliaCore::Category.find(:all)
    @path = [ { :text => @category.name } ]
  end
end
