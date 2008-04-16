module Admin::SourcesHelper
  def add_another_predicate(namespace)
    link_to_function image_tag('add.png', :size => '12x12', :alt => 'Add another predicate for '+namespace, :class => 'add') do |page|
      page.insert_html :bottom, 'new_predicates_for_'+namespace.underscore, :partial => 'predicate', :object => TaliaCore::Source.new(''), :locals => {:namespace => namespace, :name => ''}
      page[namespace.underscore].select('.predicate').last.visual_effect :highlight
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
  
  def file_type(data_type)
    data_type = case data_type
    when Class
      data_type.name
    when nil
      'Record'
    else
      data_type
    end.demodulize.gsub(/(Data|Simple)/, '').gsub(/Record/, 'File').upcase

     %(<span class="data #{h data_type.downcase}">#{h data_type}</span>)
  end
end
