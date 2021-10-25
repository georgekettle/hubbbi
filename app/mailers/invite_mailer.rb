class InviteMailer < ApplicationMailer
  def new_user_invite(invite, invitable_name, registration_url)
    @invite = invite
    @invitable_name = invitable_name
    @registration_url = registration_url
    mail(to: @invite.email, subject: "You've been invited to join #{invitable_name.capitalize}")
  end

  def existing_user_invite(invite, invitable_name)
    @invite = invite
    @invitable_name = invitable_name
    @invitable_url = set_invitable_url
    mail(to: @invite.email, subject: "You've been invited to join #{invitable_name.capitalize}")
  end

  private

  def set_invitable_url
    case @invite.invitable.class.to_s
    when 'Group' then group_url(@invite.invitable, subdomain: @invite.invitable.subdomain)
    else
      root_url
    end
  end
end
