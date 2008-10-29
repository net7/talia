require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class AvMediaTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_data
      media = make_av_media('test_data')
      data_wmv = DataTypes::WmvMedia.new
      data_wmv.location = 'foo.wmv'
      data_mp4 = DataTypes::Mp4Media.new
      data_mp4.location = 'foo.mp4'
      media.data_records << [data_wmv, data_mp4]
      media.save!
      data_mp4.save!
      data_wmv.save!
      
      assert_equal([data_mp4], media.media(:mp4_media))
      assert_equal([data_wmv], media.media(:wmv_media))
    end
    
    private
    
    def make_av_media(name)
      make_card(name, true, AvMedia)
    end
  end
end
