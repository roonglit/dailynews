module Admin
  class UserMailer < ActionMailer::Base
    default from: Rails.application.credentials.dig(:smtp, :user_name)

    def invite_admin(email)
      verifier = Rails.application.message_verifier(:user_mailer)
      @token = verifier.generate({ email: email, exp: 1.days.from_now })

      mail(to: email, subject: "Invite admin, you can register with your password")
    end
  end
end
