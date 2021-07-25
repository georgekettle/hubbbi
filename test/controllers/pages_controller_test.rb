require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get pages_edit_url
    assert_response :success
  end
end
