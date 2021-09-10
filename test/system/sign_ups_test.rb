require "application_system_test_case"

class SignUpsTest < ApplicationSystemTestCase
  test "user signs up correctly" do
    visit root_url

    find(:link, 'Signup', wait: 10).click
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
    visit group_path(group)
    visit new_group_invite_path(group)

    assert_difference 'Invite.count', 1, 'New invite should be created in DB' do
      find('div.choices').click
      assert page.has_css?('.choices__list', wait: 15)
      find('div.choices__item.choices__item--choice.choices__item--selectable.is-highlighted', text: 'Foundations').click
      fill_in 'Email *', with: new_user_email
      assert_difference 'ActionMailer::Base.deliveries.size', 1, 'New email should be enqueued' do
        click_on 'Send invite'
      end
    end

    logout

    invitation_token = retrieve_invitation_token(ActionMailer::Base.deliveries.last)
    visit new_user_registration_path(invite_token: invitation_token)

    fill_in 'Email *', with: 'miguelfixthis@gmail.com'
    fill_in 'Full name *', with: 'Miguel Ferrer'
    fill_in 'Password *', with: 'secret'
    fill_in 'Password confirmation *', with: 'secret'
    assert_difference 'User.count', 1, 'New user should be created in DB' do
      click_on 'Sign up'
    end

    assert page.has_content? 'Welcome! You have signed up successfully.'
  end

  private

  def retrieve_invitation_token(mail)
    body = mail.body.encoded.gsub("\r","").gsub("\n","")
    body.match(/http:[^ ]+localhost:#{Regexp.quote(Capybara.current_session.server.port.to_s)}\/users\/sign_up\?invite_token\=[^ ]+/)[0]
        .split("invite_token=")
        .last[0..-7]
  end
end
