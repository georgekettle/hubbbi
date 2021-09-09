require "application_system_test_case"

class ContentsTest < ApplicationSystemTestCase
  setup do
    ActionController::Base.allow_forgery_protection = true
  end

  teardown do
    ActionController::Base.allow_forgery_protection = false
  end

  test "user successfully edits the content of a course page" do
    user = users(:user_2)
    course = courses(:course_1)

    login_as user, scope: :user

    visit edit_sections_page_path(course)

    assert_difference 'course.page.sections.count', 1, 'New page section should be created in DB' do
      source = page.find('.handle.item:first-child')
      target = page.find('.dropzone[data-position="1"]', visible: false)
      source.drag_to(target)
      assert page.has_content?('Add a new page', wait: 15), 'Add new page title exists'
      assert page.has_content?('By adding pages, you can break this page up into modules'), 'Add new pagem section subtitle exists'
    end

    click_on 'Add a page'

    fill_in 'Title', with: 'Test Page'
    fill_in 'Subtitle', with: 'Test Page Subtitle'
    assert_difference 'course.page.pages.count', 1, 'New page should be created in DB' do
      click_on 'Create Page'
    end

    assert page.has_content?('New page successfully created'), 'flash appears indicating the creation was successful'

    assert_difference 'course.page.sections.count', 1, 'New text section should be created in DB' do
      source = page.find('.handle.item:nth-child(2)')
      target = page.find('.dropzone[data-position="1"]', visible: false)
      source.drag_to(target)
      assert page.has_content?('Text', wait: 15), 'Text section title exists'
    end
  end

end
