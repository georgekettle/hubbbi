require "application_system_test_case"

class GroupsTest < ApplicationSystemTestCase
  test "user successfully creates a group" do
    user = users(:user_2)
    login_as user, scope: :user

    visit new_group_path
    fill_in 'Name *', with: 'Test Group'
    assert_difference 'Group.count', 1, 'New group should be created in DB' do
      click_on 'Create Group'
      assert page.has_content?('Your group has successfully been created', wait: 15)
    end
    assert page.has_content?('Your group has successfully been created', wait: 15), 'Successful flash appears'
  end

  test "user can not create a group if name is not provided" do
    user = users(:user_2)
    login_as user, scope: :user

    visit new_group_path
    assert_no_difference 'Group.count', 'No new group should be created in DB' do
      click_on 'Create Group'
      assert page.has_content?('Name can\'t be blank', wait: 15), 'Error should appear in the page'
    end

  end

  test "Can not create a group without login in" do
    visit new_group_path
    assert current_path == new_user_session_path
    assert page.has_content?('You need to sign in or sign up before continuing.', wait: 15), 'Error should appear in the page'
  end

  test "Removes user from group" do
    user = users(:user_2)
    group = groups(:group_1)

    login_as user, scope: :user

    visit group_path(group)
    visit group_group_members_path(group)
    assert_difference 'group.group_members.count', -1, 'Group member should be deleted' do
      find(:xpath, '//*[@id="course_members"]/div[1]/div/div/div/button').click
      assert page.has_content?('Remove from group', wait: 15), 'Link to delete user from group appears'
      click_on 'Remove from group'
      page.driver.browser.switch_to.alert.accept
      assert page.has_content?('You successfully removed George Kettle from the group', wait: 15), 'Successful flash appears'
    end
  end

  test "Makes user admin from the user page" do
    user = users(:user_2)
    group = groups(:group_1)

    login_as user, scope: :user

    visit group_path(group)
    visit group_group_members_path(group)
    find(:xpath, '//*[@id="course_members"]/div[1]/div/a').click
    assert page.has_content?('George Kettle', wait: 15), 'Show page loads correctly'

    find(:css, '#header-right [data-controller="dropdown"]').click
    assert page.has_content?('Make admin', wait: 15), 'Link to make user admin appears'
    click_on 'Make admin'
    page.driver.browser.switch_to.alert.accept
    assert page.has_content?('George Kettle was successfully updated', wait: 15), 'Successful flash appears'
    assert group.group_members.find_by_user_id(1).admin?, 'George Kettle is an admin in this group'

    find(:css, '#header-left a').click
    assert current_path == group_group_members_path(group), 'It redirects to back correctly'
  end
end
