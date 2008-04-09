require File.dirname(__FILE__) + '/../../test_helper'

class Admin::SourcesControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :admin
    get :index
    assert_response :success
    assert_not_nil assigns(:sources)
  end

  def test_should_get_edit
    login_as :admin
    get :edit, :id => source.label
    assert_response :success
    
    assert_select "#source_uri[value=?]", N::LOCAL + source.label
  end

  def test_should_update_source
    login_as :admin
    put :update, :id => source.label, :source => { }
    assert_redirected_to :action => 'index'
  end
    
  def test_should_add_relation_with_existing_source
    login_as :admin
    put :update, :id => source.label, :source => params
    assert(source.direct_predicates_sources.include?("#{N::LOCAL}one"))
  end
  
  def test_should_add_source_relation_with_unexistent_source
    login_as :admin
    put :update, :id => source.label, :source => params(predicates_attributes_for_unexistent_source)
    assert(TaliaCore::Source.exists?(N::LOCAL + 'four'))
    assert(source.direct_predicates_sources.include?("#{N::LOCAL}Four"))
  end
  
  def test_should_remove_source_relation
    login_as :admin
    source.talias::attribute << TaliaCore::Source.find('two')
    put :update, :id => source.label, :source => params(predicates_attributes_for_destroyable_relation)
    assert(!source.direct_predicates_sources.include?("#{N::LOCAL}two"))
  end
  
  private
  def source
    @source ||= TaliaCore::Source.find('something')
  end
  
  def params(attributes = predicates_attributes)
    {"uri"=>N::LOCAL + source.label, "primary_source"=>"false" }.merge(attributes)
  end
  
  def predicates_attributes
    {"predicates_attributes"=>[{"name"=>"attribute", "uri"=>N::LOCAL.to_s, "namespace"=>namespace, "titleized"=>'One'}]}
  end
  
  def predicates_attributes_for_unexistent_source
    {"predicates_attributes"=>[{"name"=>"attribute", "uri"=>N::LOCAL.to_s, "namespace"=>namespace, "titleized"=>'Four'}]}
  end
  
  def predicates_attributes_for_destroyable_relation
    {"predicates_attributes"=>[{"name"=>"attribute", "uri"=>N::LOCAL.to_s, "namespace"=>namespace, "titleized"=>'Two', "should_destroy" => '1'}]}
  end
  
  def namespace
    unless N::URI.shortcut_exists?(:talias)
      N::Namespace.shortcut(:talias, "http://trac.talia.discovery-project.eu/wiki/StructuralOntology#") 
    end
    :talias
  end
end
