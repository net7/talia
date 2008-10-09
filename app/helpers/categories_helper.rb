module CategoriesHelper
  
  def category_tabs
    tabs = []
    for cat in @all_categories
      cat_el = {}
      cat_el[:link] = N::LOCAL + 'categories/' + cat.uri.local_name
      cat_el[:text] = cat.name
      cat_el[:selected] = (cat == @category)
      tabs << cat_el
    end
    widget(:simple_mode_tabs, :tabs_elements => tabs)
  end
  
end
