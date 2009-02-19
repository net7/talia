require File.dirname(__FILE__) + '/../../test_helper'

class Admin::SourcesControllerTest < ActionController::TestCase
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::TagHelper

#  def test_should_get_index
#    login_as :admin
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:sources)
#  end

  def _ignore_test_should_get_edit
    login_as :admin
    get :edit, :id => source.id
    assert_response :success
    
    assert_select '.predicate' do
      assert_select '.should_destroy'
    end
    
    assert_select "#source_uri[value=?]", N::LOCAL + source.label
    assert_select "#data ul li" do
      assert_select "a", data_record.location
      assert_select "a[href=?]", "/source_data/#{data_record.type}/#{data_record.location}"
    end
  end

  def test_should_update_source
    login_as :admin
    put :update, :id => source.id, :source => { }
    assert_redirected_to :action => 'index'
  end
    
#  def test_should_add_relation_with_existing_source
#    login_as :admin
#    put :update, :id => source.label, :source => params
#    assert(source.direct_predicates_objects.include?("#{N::LOCAL}one"))
#  end
  
#  def test_should_add_source_relation_with_unexistent_source
#    login_as :admin
#    put :update, :id => source.label, :source => params(predicates_attributes_for_unexistent_source)
#    assert(TaliaCore::Source.exists?(N::LOCAL + 'four'))
#    assert(source.direct_predicates_objects.include?("#{N::LOCAL}Four"))
#  end
  
#  def test_should_remove_source_relation
#    login_as :admin
#    source.talias::attribute << TaliaCore::Source.find('two')
#    put :update, :id => source.label, :source => params(predicates_attributes_for_destroyable_relation)
#    assert(!source.direct_predicates_objects.include?("#{N::LOCAL}two"))
#  end
  
  def _ignore_test_should_show_data_records_list
    login_as :admin
    get :edit, :id => source.label
    assert_select('h2', 'Files')
    assert_select '#data' do
      assert_select('ul#list') do
        assert_select('span.data')
      end
    end
  end
  
  def _ignore_test_show_upload_form
    login_as :admin
    get :edit, :id => source.label
    html = %(<a href="#" id="upload_link" onclick="try {
      Element.update(&quot;data_form&quot;, &quot;\u003Cform action=\&quot;/source_data/create\&quot; enctype=\&quot;multipart/form-data\&quot; method=\&quot;post\&quot; onsubmit=\&quot;if (this.action.indexOf('upload_id') \u0026lt; 0){ this.action += '?upload_id=1'; }this.target = 'UploadTarget1';$('UploadStatus1').innerHTML='Upload starting...'; if($('UploadProgressBar1')){$('UploadProgressBar1').firstChild.firstChild.style.width='0%'}; if (document.uploadStatus1) { document.uploadStatus1.stop(); }document.uploadStatus1 = new Ajax.PeriodicalUpdater('UploadStatus1','/source_data/upload_status?upload_id=1', Object.extend({asynchronous:true, evalScripts:true, onComplete:function(request){$('UploadStatus1').innerHTML='Upload finished.';if($('UploadProgressBar1')){$('UploadProgressBar1').firstChild.firstChild.style.width='100%'};document.uploadStatus1 = null; onFinishedUpload()}},{decay:1.8,frequency:2.0})); return true\&quot;\u003E\u003Ciframe id=\&quot;UploadTarget1\&quot; name=\&quot;UploadTarget1\&quot; src=\&quot;\&quot; style=\&quot;width:0px;height:0px;border:0\&quot;\u003E\u003C/iframe\u003E\n  \u003Cinput id=\&quot;data_record[source_record_id]\&quot; name=\&quot;data_record[source_record_id]\&quot; type=\&quot;hidden\&quot; value=\&quot;247\&quot; /\u003E\n  \u003Cinput id=\&quot;data_record_file\&quot; name=\&quot;data_record[file]\&quot; size=\&quot;30\&quot; type=\&quot;file\&quot; /\u003E\n  \u003Cinput id=\&quot;data_record_submit\&quot; name=\&quot;commit\&quot; onclick=\&quot;showUploadProgressBar();\&quot; type=\&quot;submit\&quot; value=\&quot;Upload\&quot; /\u003E or \u003Ca href=\&quot;#\&quot; onclick=\&quot;try {\n$(\u0026quot;data_form\u0026quot;).visualEffect(\u0026quot;fade\u0026quot;, {\u0026quot;duration\u0026quot;: 0.001});\n$(\u0026quot;upload_link\u0026quot;).visualEffect(\u0026quot;appear\u0026quot;, {\u0026quot;duration\u0026quot;: 0.4});\nElement.update(\u0026quot;data_form\u0026quot;, \u0026quot;\u0026quot;);\n} catch (e) { alert('RJS error:\\n\\n' + e.toString()); alert('$(\\\u0026quot;data_form\\\u0026quot;).visualEffect(\\\u0026quot;fade\\\u0026quot;, {\\\u0026quot;duration\\\u0026quot;: 0.001});\\n$(\\\u0026quot;upload_link\\\u0026quot;).visualEffect(\\\u0026quot;appear\\\u0026quot;, {\\\u0026quot;duration\\\u0026quot;: 0.4});\\nElement.update(\\\u0026quot;data_form\\\u0026quot;, \\\u0026quot;\\\u0026quot;);'); throw e }; return false;\&quot;\u003Ecancel\u003C/a\u003E\n  \u003Cdiv class=\&quot;progressBar\&quot; id=\&quot;UploadProgressBar1\&quot;\u003E\u003Cdiv class=\&quot;border\&quot;\u003E\u003Cdiv class=\&quot;background\&quot;\u003E\u003Cdiv class=\&quot;foreground\&quot;\u003E\u003C/div\u003E\u003C/div\u003E\u003C/div\u003E\u003C/div\u003E\u003Cdiv class=\&quot;uploadStatus\&quot; id=\&quot;UploadStatus1\&quot;\u003E\u003C/div\u003E\n\u003C/form\u003E    \n&quot;);
      $(&quot;upload_link&quot;).visualEffect(&quot;fade&quot;, {&quot;duration&quot;: 0.001});
      $(&quot;data_form&quot;).visualEffect(&quot;appear&quot;, {&quot;duration&quot;: 0.4});
      } catch (e) { alert('RJS error:\n\n' + e.toString()); alert('Element.update(\&quot;data_form\&quot;, \&quot;\\u003Cform action=\\\&quot;/source_data/create\\\&quot; enctype=\\\&quot;multipart/form-data\\\&quot; method=\\\&quot;post\\\&quot; onsubmit=\\\&quot;if (this.action.indexOf(\'upload_id\') \\u0026lt; 0){ this.action += \'?upload_id=1\'; }this.target = \'UploadTarget1\';$(\'UploadStatus1\').innerHTML=\'Upload starting...\'; if($(\'UploadProgressBar1\')){$(\'UploadProgressBar1\').firstChild.firstChild.style.width=\'0%\'}; if (document.uploadStatus1) { document.uploadStatus1.stop(); }document.uploadStatus1 = new Ajax.PeriodicalUpdater(\'UploadStatus1\',\'/source_data/upload_status?upload_id=1\', Object.extend({asynchronous:true, evalScripts:true, onComplete:function(request){$(\'UploadStatus1\').innerHTML=\'Upload finished.\';if($(\'UploadProgressBar1\')){$(\'UploadProgressBar1\').firstChild.firstChild.style.width=\'100%\'};document.uploadStatus1 = null; onFinishedUpload()}},{decay:1.8,frequency:2.0})); return true\\\&quot;\\u003E\\u003Ciframe id=\\\&quot;UploadTarget1\\\&quot; name=\\\&quot;UploadTarget1\\\&quot; src=\\\&quot;\\\&quot; style=\\\&quot;width:0px;height:0px;border:0\\\&quot;\\u003E\\u003C/iframe\\u003E\\n  \\u003Cinput id=\\\&quot;data_record[source_record_id]\\\&quot; name=\\\&quot;data_record[source_record_id]\\\&quot; type=\\\&quot;hidden\\\&quot; value=\\\&quot;247\\\&quot; /\\u003E\\n  \\u003Cinput id=\\\&quot;data_record_file\\\&quot; name=\\\&quot;data_record[file]\\\&quot; size=\\\&quot;30\\\&quot; type=\\\&quot;file\\\&quot; /\\u003E\\n  \\u003Cinput id=\\\&quot;data_record_submit\\\&quot; name=\\\&quot;commit\\\&quot; onclick=\\\&quot;showUploadProgressBar();\\\&quot; type=\\\&quot;submit\\\&quot; value=\\\&quot;Upload\\\&quot; /\\u003E or \\u003Ca href=\\\&quot;#\\\&quot; onclick=\\\&quot;try {\\n$(\\u0026quot;data_form\\u0026quot;).visualEffect(\\u0026quot;fade\\u0026quot;, {\\u0026quot;duration\\u0026quot;: 0.001});\\n$(\\u0026quot;upload_link\\u0026quot;).visualEffect(\\u0026quot;appear\\u0026quot;, {\\u0026quot;duration\\u0026quot;: 0.4});\\nElement.update(\\u0026quot;data_form\\u0026quot;, \\u0026quot;\\u0026quot;);\\n} catch (e) { alert(\'RJS error:\\\\n\\\\n\' + e.toString()); alert(\'$(\\\\\\u0026quot;data_form\\\\\\u0026quot;).visualEffect(\\\\\\u0026quot;fade\\\\\\u0026quot;, {\\\\\\u0026quot;duration\\\\\\u0026quot;: 0.001});\\\\n$(\\\\\\u0026quot;upload_link\\\\\\u0026quot;).visualEffect(\\\\\\u0026quot;appear\\\\\\u0026quot;, {\\\\\\u0026quot;duration\\\\\\u0026quot;: 0.4});\\\\nElement.update(\\\\\\u0026quot;data_form\\\\\\u0026quot;, \\\\\\u0026quot;\\\\\\u0026quot;);\'); throw e }; return false;\\\&quot;\\u003Ecancel\\u003C/a\\u003E\\n  \\u003Cdiv class=\\\&quot;progressBar\\\&quot; id=\\\&quot;UploadProgressBar1\\\&quot;\\u003E\\u003Cdiv class=\\\&quot;border\\\&quot;\\u003E\\u003Cdiv class=\\\&quot;background\\\&quot;\\u003E\\u003Cdiv class=\\\&quot;foreground\\\&quot;\\u003E\\u003C/div\\u003E\\u003C/div\\u003E\\u003C/div\\u003E\\u003C/div\\u003E\\u003Cdiv class=\\\&quot;uploadStatus\\\&quot; id=\\\&quot;UploadStatus1\\\&quot;\\u003E\\u003C/div\\u003E\\n\\u003C/form\\u003E    \\n\&quot;);\n$(\&quot;upload_link\&quot;).visualEffect(\&quot;fade\&quot;, {\&quot;duration\&quot;: 0.001});\n$(\&quot;data_form\&quot;).visualEffect(\&quot;appear\&quot;, {\&quot;duration\&quot;: 0.4});'); throw e }; return false;">upload</a></p>)
    assert_select('#upload_link', :onclick => html)
  end

  private
  def source
    @source ||= TaliaCore::Source.find("something")
  end
  
  def params(attributes = predicates_attributes)
    {"uri"=>N::LOCAL + source.label, "primary_source"=>"false" }.merge(attributes)
  end
  
  def predicates_attributes
    {"predicates_attributes"=>[{"name"=>"attribute", "uri"=>N::LOCAL.to_s, "namespace"=>namespace, "titleized"=>'One'}]}
  end
  
  def predicates_attributes_for_unexistent_source
    {"predicates_attributes"=>[{"name"=>"attribute", "uri"=>N::LOCAL.to_s, "namespace"=>namespace, "titleized"=>'Four', "should_destroy" => ''}]}
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
  
  def data_record
    @data_record ||= TaliaCore::DataTypes::DataRecord.find(:first)
  end
end
