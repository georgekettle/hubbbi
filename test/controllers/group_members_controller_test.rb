require "test_helper"

class GroupMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get group_members_show_url
    assert_response :success
  end
end
