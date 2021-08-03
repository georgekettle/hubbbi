require "test_helper"

class SectionElementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get section_elements_index_url
    assert_response :success
  end
end
