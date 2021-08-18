require "application_system_test_case"

class SignUpsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit "/"

    assert_selector "h4", text: "Akademy project"
  end
end
