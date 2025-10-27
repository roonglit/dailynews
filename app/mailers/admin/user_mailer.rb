module Admin
  class UserMailer < ActionMailer::Base
    default from: Rails.application.credentials.dig(:smtp, :user_name)

    def invite_admin(email)
      @email = email
      mail(to: email, subject: "Invite admin, u can init your password")
      p "="*100
    end
  end
end
