require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

module TaliaCore
  class MacroContributionTest < Test::Unit::TestCase
    
    Dependencies.load_paths << File.join(File.dirname(__FILE__), '..', '..', 'app', 'models')
    
    def setup
      @title = 'Macro Contribution'
      @description = 'Bla bla bla..'
      @macrocontribution_type = 'MacroContribution'
    end
    
    def teardown
      # macro_contribution.clear
    end
    
    def test_predicate
      assert_equal 'http://www.hypernietzsche.org/ontology#hasAsPart', MacroContribution::SOURCE_PREDICATE
    end
    
    def test_initialize
      assert !macro_contribution.primary_source
    end
    
    def test_sources
      assert macro_contribution.sources
    end
    
    def test_should_add_source
      macro_contribution << source
      assert macro_contribution.include?(source)
    end
    
    def test_should_add_source_via_uri
      macro_contribution << source.uri.to_s
      assert macro_contribution.include?(source)
    end
    
    def test_should_raise_argument_error_if_try_to_add_nil_source
      assert_raise ArgumentError do
        macro_contribution << nil
      end
    end
    
    def test_should_remove_source
      macro_contribution << source
      macro_contribution.remove source
      assert macro_contribution.sources.empty?
    end
    
    def test_should_not_raise_exception_if_try_to_remove_nil_source
      assert_nothing_raised Exception do
        macro_contribution.remove nil
      end
    end
    
    def test_should_not_raise_exception_it_try_to_remove_not_associated_source
      assert_nothing_raised Exception do
        macro_contribution.remove Source.new('http://test.org/not-associated')
      end      
    end
    
    def test_should_set_title
      macro_contribution.title = @title
      assert_equal @title, macro_contribution.title
    end
    
    def test_should_set_description
      macro_contribution.description = @description
      assert_equal @description, macro_contribution.description
    end
    
    def test_should_set_macrocontribution_type
      macro_contribution.macrocontribution_type = @macrocontribution_type
      assert_equal @macrocontribution_type, macro_contribution.macrocontribution_type
    end
    
    def test_should_save
      macro_contribution = create_macro_contribution('http://test.org/mc2')
      assert macro_contribution.save

      macro_contribution = MacroContribution.find('http://test.org/mc2')
      assert_equal @title, macro_contribution.title
      assert_equal @description, macro_contribution.description
      assert_equal @macrocontribution_type, macro_contribution.macrocontribution_type
    end
    
    def test_should_update_attributes
      macro_contribution = create_macro_contribution('http://test.org/mc3')
      assert macro_contribution.save
      
      macro_contribution.title = 'title12'
      assert macro_contribution.save
      
      macro_contribution = MacroContribution.find('http://test.org/mc3')
      assert_equal 'title12', macro_contribution.title
      assert_equal 1, macro_contribution.hyper::title.size
    end
    
    private
    def macro_contribution
      @macro_contribution ||= MacroContribution.new('http://test.org/mc')
    end
      
    def source
      @source ||= Source.create('http://test.org/source')
    end
      
    def create_macro_contribution(uri)
      macro_contribution = MacroContribution.new(uri)
      macro_contribution.title = @title
      macro_contribution.description = @description
      macro_contribution.macrocontribution_type = @macrocontribution_type
      macro_contribution.save!
      macro_contribution
    end
  end
end
