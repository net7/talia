module Admin::SourcesHelper
  def add_another_predicate(namespace)
    link_to_function "add another" do |page|
      page.insert_html :bottom, namespace.underscore, :partial => 'predicate', :object => TaliaCore::Source.new(''), :locals => {:namespace => namespace, :name => ''}
      page[namespace.underscore].select('.predicate').last.visual_effect :highlight
    end
  end
end
