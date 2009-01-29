require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore

  # Test classes
  class DataTypes::DataTest1 < DataTypes::DataRecord
  end

  class DataTypes::DataTest2 < DataTypes::DataRecord
  end


  class ManifestationTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers

    suppress_fixtures

    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end

      setup_once(:manifestation) do
        manif = Manifestation.new('http://www.manifestations_test/sample_manifestation')
        manif.save!
        # Add some data elements
        data1 = DataTypes::DataTest1.new

        data1.location = 'foo.jpg'
        data1.source = manif
        data1.save!
        data2 = DataTypes::DataTest2.new
        data2.location = 'foo.gif'
        data2.source = manif
        data2.save!
        manif.save!
        manif
      end
    end

    def test_create
      assert_kind_of(Manifestation, @manifestation)
    end

    def test_data
      assert_equal(2, @manifestation.data_records.size)
    end

    def test_data_finder
      assert_equal(1, @manifestation.data_records.find(:all, :conditions => { :type => 'DataTest1' }).size)
    end

  end
end