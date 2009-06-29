require File.dirname(__FILE__) + '/../test_helper'

class AvMediaSourcesControllerTest < ActionController::TestCase
  def test_should_get_show
    get :show, :id => av_media.uri.local_name
    assert_response :success
  end
  
  private
    def av_media
      @av_media ||= begin
        result = TaliaCore::AvMedia.create(:uri => N::LOCAL + 'av_media_sources/media')
        cat = TaliaCore::Category.new(N::LOCAL + 'test_cat_for_av_media_test')
        wmv = TaliaCore::DataTypes::WmvMedia.new(:location => 'foo.wmv')
        result.predicate_set('hyper','category', cat)
        result.data_records << wmv
        result
      end
    end
end
