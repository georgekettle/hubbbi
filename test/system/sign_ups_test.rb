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


  test "user can sign up if invited by another user" do
    ActionMailer::Base.deliveries.clear

    user = users(:user_2)
    group = groups(:group_1)
    new_user_email = 'miguelistheking@gmail.com'

    login_as user, scope: :user
    visit new_group_group_member_path(group)

    assert_difference 'User.count', 1, 'New user should be created in DB' do
      fill_in 'Email', with: new_user_email
      assert_difference 'ActionMailer::Base.deliveries.size', 1, 'New email should be enqueued' do
        click_on 'Send invite'
      end
    end

    logout

    invitation_token = retrieve_invitation_token(ActionMailer::Base.deliveries.last)
    visit accept_user_invitation_path(invitation_token: invitation_token)

    fill_in 'Full name', with: 'Invited Miguel'
    fill_in 'Password', with: 'secret'
    fill_in 'Password confirmation', with: 'secret'
    click_on 'Set my password'
    assert page.has_content? 'Your password was set successfully. You are now signed in.'
  end

  private

  def retrieve_invitation_token(mail)
    body = mail.body.encoded.gsub("\r","").gsub("\n","")
    body.match(/http:[^ ]+localhost:3000\/users\/invitation\/accept\?invitation_token\=[^ ]+/)[0]
        .split("invitation_token=")
        .last
  end
end
