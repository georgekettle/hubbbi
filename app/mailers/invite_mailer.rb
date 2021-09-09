class InviteMailer < ApplicationMailer
  def new_user_invite(invite, invitable_name, registration_url)
    @invite = invite # Instance variable => available in view
    @invitable_name = invitable_name
    @registration_url = registration_url
    mail(to: @invite.email, subject: "You've been invited to join #{invitable_name.capitalize}")
    # This will render a view in `app/views/invite_mailer`!
  end

  def existing_user_invite(invite, invitable_name)
    @invite = invite # Instance variable => available in view
    @invitable_name = invitable_name
    mail(to: @invite.email, subject: "You've been invited to join #{invitable_name.capitalize}")
    # This will render a view in `app/views/invite_mailer`!
  end
end
