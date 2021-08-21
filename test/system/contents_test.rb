require "application_system_test_case"

class ContentsTest < ApplicationSystemTestCase
  setup do
    ActionController::Base.allow_forgery_protection = true
  end

  teardown do
    ActionController::Base.allow_forgery_protection = false
  end

  test "user successfully creates a course within a group" do
    user = users(:user_2)
    course = courses(:course_1)

    login_as user, scope: :user

    visit edit_sections_page_path(course)

    assert_difference 'course.page.sections.count' do
      source = page.find('.handle.item:first-child')
      target = page.find('.dropzone', visible: false)
      source.drag_to(target)
      assert page.has_content? 'Pages'
      assert page.has_content? 'By addng pages, you can break this page up into modules'
    end

    click_on 'Add a page'

    fill_in 'Title', with: 'Test Page'
    fill_in 'Subtitle', with: 'Test Page Subtitle'
    assert_difference 'course.page.pages.count' do
      click_on 'Create Page'
    end

    assert page.has_content? 'New page successfully created'
  end

end
