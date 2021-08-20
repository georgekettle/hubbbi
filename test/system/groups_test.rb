require "application_system_test_case"

class GroupsTest < ApplicationSystemTestCase
  test "user successfully creates a group" do
    user = users(:user_2)
    login_as user, scope: :user

    visit new_group_path
    fill_in 'Name *', with: 'Test Group'
    assert_difference 'Group.count' do
      click_on 'Create Group'
    end
    assert page.has_content? 'Your group has successfully been created'
  end

  test "user can not create a group if name is not provided" do
    user = users(:user_2)
    login_as user, scope: :user

    visit new_group_path

    assert_no_difference 'Group.count' do
      click_on 'Create Group'
    end
    assert page.has_content? 'Name can\'t be blank'
  end

  test "Can not create a group without login in" do
    visit new_group_path
    assert current_path == new_user_session_path
    assert page.has_content? 'You need to sign in or sign up before continuing.'
  end
end
