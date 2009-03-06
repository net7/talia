require File.dirname(__FILE__) + '/../test_helper'

class AvMediaSourcesControllerTest < ActionController::TestCase
  def test_should_get_show
    get :show, :id => av_media.local_name
    assert_response :success
  end
  
  private
    def av_media
      @av_media ||= begin
        result = TaliaCore::AvMedia.create(:uri => N::LOCAL + 'av_media_sources/media')
        result.predicate_set('hyper','category', 'cartoons')
        result
      end
    end
end
