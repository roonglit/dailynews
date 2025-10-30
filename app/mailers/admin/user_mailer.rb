module Admin
  class UserMailer < ActionMailer::Base
    default from: Rails.application.credentials.dig(:smtp, :user_name)

    def invite_admin(invitation)
      @invitation = invitation
      @email = invitation.email
      @invited_by = invitation.invited_by
      @token = invitation.token

      mail(to: @email, subject: "Invite admin, you can register with your password")
    end
  end
end
