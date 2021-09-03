require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  test "user successfully creates a course within a group" do
    user = users(:user_2)
    group = groups(:group_1)

    login_as user, scope: :user

    visit new_group_course_path(group)
    fill_in 'Title *', with: 'Test Course'

    assert_difference 'group.courses.count', 1, 'New course should be created in DB' do
      click_on 'Create Course'
    end

    assert page.has_content?('Course successfully created'), 'Successful flash appears'
  end

  test "user can not create a course within a group if name is not provided" do
    user = users(:user_2)
    group = groups(:group_1)

    login_as user, scope: :user

    visit new_group_course_path(group)

    assert_no_difference 'group.courses.count', 'No new course should be created in DB' do
      click_on 'Create Course'
    end

    assert page.has_content?('Title can\'t be blank'), 'Error should appear in the page'
  end

  test "user can not create a course within a group in which is not member" do
    user = users(:user_2)
    group = groups(:group_2)

    login_as user, scope: :user

    visit new_group_course_path(group)
    assert page.has_content?('You are not authorized to perform this action.'), 'Error should appear in the page'
    assert current_path == authenticated_root_path
  end

  test "user can not create a course without login in" do
    group = groups(:group_2)

    visit new_group_course_path(group)

    assert current_path == new_user_session_path
    assert page.has_content?('You need to sign in or sign up before continuing.'), 'Error should appear in the page'
  end

  test "removes user from course" do
    user = users(:user_2)
    course = courses(:course_1)

    login_as user, scope: :user

    visit course_course_members_path(course)
    assert_difference 'course.course_members.count', -1, 'Course member should be deleted' do
      page.assert_selector(:xpath, '//*[@id="course_members"]/div[1]/div/div/div/button')
      find(:xpath, '//*[@id="course_members"]/div[1]/div/div/div/button').click
      assert page.has_content?('Remove from course', wait: 5), 'Link to delete user from course appears'
      click_on 'Remove from course'
      page.driver.browser.switch_to.alert.accept
      assert page.has_content?('George Kettle was successfully removed from the course', wait: 5), 'Successful flash appears'
    end
  end
end
