require "application_system_test_case"

class SignUpsTest < ApplicationSystemTestCase
  test "user signs up correctly" do
    visit root_url
    find(:link, 'Signup', wait: 15).click
    fill_in 'Email *', with: 'mferrer@hey.com'
    fill_in 'Full name *', with: 'Miguel Ferrer'
    fill_in 'Password *', with: 'secret'
    fill_in 'Password confirmation *', with: 'secret'
    assert_difference 'User.count', 1, 'New user should be created in DB' do
      click_on 'Sign up'
      assert page.has_content?('Welcome! You have signed up successfully.' , wait: 15), 'Successful flash appears'
    end
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
      assert page.has_content?('Please review the problems below:', wait: 15), 'Error should appear in the page'
      assert page.has_content?('Email can\'t be blank', wait: 15), 'Error should appear in the page'
    end
  end


  test "user can sign up if invited by another user" do
    ActionMailer::Base.deliveries.clear
    user = users(:user_2)
    group = groups(:group_1)
    new_user_email = 'miguelistheking@gmail.com'

    login_as user, scope: :user
    visit new_group_invite_url(group, subdomain: group.subdomain)

    assert_difference 'Invite.count', 1, 'New invite should be created in DB' do
      find('div.choices', wait: 15).click
      assert page.has_css?('.choices__list', wait: 15)
      find('div.choices__item.choices__item--choice.choices__item--selectable.is-highlighted', text: 'Foundations', wait: 15).click
      fill_in 'Email *', with: new_user_email
      assert_difference 'ActionMailer::Base.deliveries.size', 1, 'New email should be enqueued' do
        click_on 'Send invite'
        assert page.has_content?('Invite sent', wait: 15), 'Successful flash appears'
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
      assert page.has_content?('Welcome! You have signed up successfully.', wait: 15), 'Successful flash appears'
    end
  end

  private

  def retrieve_invitation_token(mail)
    body = mail.body.encoded.gsub("\r","").gsub("\n","")
    body.match(/http:[^ ]+lvh.me:#{Regexp.quote(Capybara.current_session.server.port.to_s)}\/users\/sign_up\?invite_token\=[^ ]+/)[0]
        .split("invite_token=")
        .last[0..-7]
  end
end
