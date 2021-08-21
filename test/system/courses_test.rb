require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  test "user successfully creates a course within a group" do
    user = users(:user_2)
    group = groups(:group_1)

    login_as user, scope: :user

    visit new_group_course_path(group)
    fill_in 'Title *', with: 'Test Course'

    assert_difference 'group.courses.count' do
      click_on 'Create Course'
    end

    assert page.has_content? 'Course successfully created'
  end

  test "user can not create a course within a group if name is not provided" do
    user = users(:user_2)
    group = groups(:group_1)

    login_as user, scope: :user

    visit new_group_course_path(group)

    assert_no_difference 'group.courses.count' do
      click_on 'Create Course'
    end

    assert page.has_content? 'Title can\'t be blank'
  end

  test "user can not create a course within a group in which is not member" do
    user = users(:user_2)
    group = groups(:group_2)

    login_as user, scope: :user

    visit new_group_course_path(group)
    assert page.has_content? 'You are not authorized to perform this action.'
    assert current_path == authenticated_root_path
  end

  test "user can not create a course without login in" do
    group = groups(:group_2)

    visit new_group_course_path(group)

    assert current_path == new_user_session_path
    assert page.has_content? 'You need to sign in or sign up before continuing.'
  end
end
