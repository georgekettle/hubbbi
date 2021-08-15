require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get videos_edit_url
    assert_response :success
  end
end
