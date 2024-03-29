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

    visit group_path(course.group)
    visit edit_sections_page_path(course)

    assert_difference 'course.page.sections.count', 1, 'New page section should be created in DB' do
      source = page.find('.handle.item:first-child')
      target = page.find('.dropzone[data-position="1"]', visible: false)
      source.drag_to(target)
      assert page.has_content?('Add a new page', wait: 15), 'Add new page title exists'
      assert page.has_content?('By adding pages, you can break this page up into modules'), 'Add new page section subtitle exists'
    end

    find(:link, 'Add a page', match: :first).click

    fill_in 'Title', with: 'Test Page', wait: 15
    fill_in 'Subtitle', with: 'Test Page Subtitle'
    assert_difference 'course.page.pages.count', 1, 'New page should be created in DB' do
      click_on 'Create Page'
      assert page.has_content?('New page successfully created', wait: 15), 'Successful flash appears'
    end

    assert page.has_content?('New page successfully created', wait: 15), 'flash appears indicating the creation was successful'

    assert_difference 'course.page.sections.count', 1, 'New text section should be created in DB' do
      source = page.find('.handle.item:nth-child(2)')
      target = page.find('.dropzone[data-position="1"]', visible: false)
      source.drag_to(target)
      assert page.has_content?('Text', wait: 15), 'Text section title exists'
    end
  end

  test "user doesnt get a 500 error when creating an empty link" do
    user = users(:user_2)
    course = courses(:course_1)

    login_as user, scope: :user

    visit group_path(course.group)
    visit edit_sections_page_path(course.page)

    assert_difference 'course.page.sections.count', 1, 'New page section should be created in DB' do
      source = page.find('.handle.item:last-child')
      target = page.find('.dropzone[data-position="1"]', visible: false)
      source.drag_to(target)
      assert page.has_content?('Add a new link', wait: 15), 'Add new link title exists'
    end

    find(:link, 'Add link', match: :first).click
    click_on 'Create Link'

    assert page.has_content?('Url can\'t be blank and Url is invalid', wait: 15), 'URL is mandatory error appears'
    assert page.has_content?('Title can\'t be blank', wait: 15), 'Title is mandatory error appears'
  end

end
