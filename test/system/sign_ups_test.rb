require "application_system_test_case"

class SignUpsTest < ApplicationSystemTestCase
  test "user signs up correctly" do
    visit root_url

    click_on 'Signup'
    fill_in 'Email *', with: 'mferrer@hey.com'
    fill_in 'Full name *', with: 'Miguel Ferrer'
    fill_in 'Password *', with: 'secret'
    fill_in 'Password confirmation *', with: 'secret'
    assert_difference 'User.count', 1, 'New user should be created in DB' do
      click_on 'Sign up'
    end
    assert page.has_content?('Welcome! You have signed up successfully.'), 'Successful flash appears'
  end

  test "user can not sign up if all required fields are not completed" do
    visit root_url
    click_on 'Signup'
    fill_in 'Email *', with: ''
    fill_in 'Full name *', with: 'Miguel Ferrer'
    fill_in 'Password *', with: 'secret'
    fill_in 'Password confirmation *', with: 'secret'

    assert_no_difference 'User.count', 'No new user should be created in DB' do
      click_on 'Sign up'
    end
    assert page.has_content?('Please review the problems below:'), 'Error should appear in the page'
    assert page.has_content?('Email can\'t be blank'), 'Error should appear in the page'
  end
end
