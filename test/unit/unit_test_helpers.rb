require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'
require 'fileutils'

module TaliaCore
  
  module UnitTestHelpers
    
    def klass_name
      self.class.to_s.gsub(/:+/, '_')
    end
    
    # Set up the IIP directory
    def setup_iip
      TaliaCore::CONFIG["iip_root_directory_location"] = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'fixtures', 'iip_test_data')
      clean_iip
    end
    
    # Clean out the IIP directory
    def clean_iip
      iip_dir = TaliaCore::CONFIG["iip_root_directory_location"]
      FileUtils.rm_rf(iip_dir) if(File.exists?(iip_dir))
    end
    
    # Creates a dummy expression card
    def make_card(name, save = true, klass = ExpressionCard)
      kname = klass_name
      kname += klass.name.underscore unless(klass == ExpressionCard)
      card = klass.new("http://#{kname}/#{name}")
      card.save! if(save)
      card
    end
    
    # Creates a dummy book with a number of pages
    def make_book(name, page_count = 0)
      book = make_card(name, true, Book)
      book.save!
      page_count.times do |n|
        page = make_card("#{name}_page_#{n}", true, Page)
        page.hyper::part_of << book
        page.save!
      end
      book
    end
    
    # Make a catalog
    def make_catalog(name)
      make_card(name, true, Catalog)
    end
    
    # Get the class that is tested here
    def tested_klass
      return @tested_klass if(@tested_klass)
      name = self.class.name.demodulize.gsub(/Test$/, '')
      klass = nil
      begin
        klass = TaliaCore.const_get(name)
      rescue
        klass = nil
      end
      @tested_klass = klass
    end 
    
    # Runs an automatic test on the cloning if the class supports it
    def test_cloning_autotest
      can_clone = (tested_klass && tested_klass.respond_to?(:props_to_clone))
      return unless(can_clone)
      can_clone &= (tested_klass.props_to_clone.size > 0)
      clone_props = self.class.test_clone_properties
      assert(!clone_props || can_clone, "Cloning not possible on #{tested_klass.name}")
      auto_clone_test(tested_klass)
      assert_cloned(tested_klass, *clone_props) if(clone_props)
    end
    
    # Automatically tests if all the configured properties for this class are
    # cloned.
    def auto_clone_test(klass)
      assert(klass.props_to_clone.size > 0)
      orig = klass.new("http://#{klass_name}/clone_tester")
      klass.props_to_clone.each do |prop|
        orig[prop] << "#{prop} the value"
      end
      orig.save!
      clone = orig.clone(orig.uri + 'clone')
      clone.save!
      klass.props_to_clone.each do |prop|
        assert_property(clone[prop], "#{prop} the value")
      end
    end
    
    # Asserts if the given properties are cloned on this class
    def assert_cloned(klass, *properties)
      properties.each do |prop|
        assert(klass.props_to_clone.include?(prop), "The #{prop} property is not cloned")
      end
    end
    
  end
  
end

# Add some stuff to the basic test case
class Test::Unit::TestCase
  
  def self.test_clone_properties
    @test_cloning
  end
  
  # Can be used to force a test for cloning on ExpressionCards. 
  # You may optinally give a list of properties that must be cloned.
  def self.test_cloning(*properties)
    @test_cloning = properties
  end
end
