require File.dirname(__FILE__) + '/../test_helper'

class Test::Unit::TestCase
  include TaliaCore
  
  protected
  def method_missing(method_name, *arguments)
    if /editions|facsimiles|manuscripts|works/.match method_name.id2name
      document("#{method_name}/#{arguments}")
    else
      super
    end
  end
  
  def fabrica_sample_dir
    File.join(File.dirname(__FILE__), '..', 'fixtures', 'fabrica_samples')
  end
  
  def document(name)
    File.open(File.join(fabrica_sample_dir, name + '.xml'))
  end
    
  def talia_core_fixtures
    @talia_core_fixtures ||= begin
      File.join(File.expand_path(RAILS_ROOT),
        'vendor', 'plugins', 'talia_core',
        'test', 'talia_util', 'fabrica_samples')
    end
  end
    
  def documents_root
    @documents_root ||= File.join(File.expand_path(RAILS_ROOT),
      'test', 'fixtures', 'import')
  end

  # Cleans the import cache
  def clean_import_cache
    TaliaUtil::HyperImporter::Importer.type_cache.clear
    TaliaUtil::HyperImporter::SourceCache.cache.clear
  end

  def source_import(file, siglum)
    assert(!TaliaCore::Source::exists?(siglum), "#{siglum} must not exist before test")
    authorize_as :hyper
    post :create, :document => document(file)
    assert_response :created  
    assert(TaliaCore::Source.exists?(siglum), "#{siglum} must exist after create")
    src = TaliaCore::Source.find(siglum) 
    yield if(block_given?)
    src
  end
end
