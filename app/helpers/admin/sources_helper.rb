module Admin::SourcesHelper
  def add_another_predicate(namespace)
    link_to_function image_tag('add.png', :size => '12x12', :alt => 'Add another predicate for '+namespace, :class => 'add') do |page|
      page.insert_html :bottom, 'new_predicates_for_'+namespace.underscore, :partial => 'predicate', :object => TaliaCore::SourceTransferObject.new(''), :locals => {:namespace => namespace, :name => ''}
      page[namespace.underscore].select('.predicate').last.visual_effect :highlight
      page << "$('#{h(namespace.underscore)}').select('.predicate').last().select('.source').first().setAttribute('value', true);"
      page << "attachAjaxAutocompleterOnNewElement('"+h(namespace.underscore)+"');"
      page << "showPredicatesOfDiv('"+h(namespace.underscore)+"');"
    end
  end
  
  def show_upload_form
    link_to_function "upload", :id => 'upload_link' do |page|
      page.replace_html 'data_form', :partial => 'upload'
      page['upload_link'].visual_effect :fade, :duration => 0.001
      page['data_form'].visual_effect :appear, :duration => 0.4
    end
  end
  
  def hide_upload_form
    link_to_function "cancel" do |page|
      page['data_form'].visual_effect :fade, :duration => 0.001
      page['upload_link'].visual_effect :appear, :duration => 0.4
      page.replace_html 'data_form', ''
    end
  end
  
  def file_type(data)
    data_type = data.class.name.demodulize.gsub(/(Data|Simple)/, '').gsub(/Record/, 'File').upcase
     %(<span class="data #{h data_type.downcase}">#{h data_type}</span>)
  end
  
  # Use this method in your view to generate a return for the AJAX autocomplete requests.
  #
  # Example action:
  #
  #   def auto_complete_for_item_title
  #     @items = Item.find(:all, 
  #       :conditions => [ 'LOWER(description) LIKE ?', 
  #       '%' + request.raw_post.downcase + '%' ])
  #     render :inline => "<%= auto_complete_result(@items, 'description') %>"
  #   end
  #
  # The auto_complete_result can of course also be called from a view belonging to the 
  # auto_complete action if you need to decorate it further.
  def auto_complete_result(entries, field, phrase = nil)
    return unless entries
    items = entries.map { |entry| content_tag("li", phrase ? highlight(entry.send(field), phrase) : h(entry.send(field))) }
    content_tag("ul", items.uniq)
  end
end
