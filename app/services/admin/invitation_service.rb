module Admin
  class InvitationService
    attr_reader :invited_by

    def initialize(invited_by:)
      @invited_by = invited_by
    end

    def create_invitation(email:)
      # Check if email is already an admin
      if Admin::User.exists?(email: email, status: [ :active, :inactive ])
        return {
          success: false,
          error: "User with this email is already an admin."
        }
      end

      # Check if there's already a pending invitation
      existing_invitation = Admin::Invitation.active.find_by(email: email)
      if existing_invitation.present?
        return {
          success: false,
          error: "There is already a pending invitation for this email."
        }
      end

      # Create the Admin::User with invited status
      admin_user = Admin::User.new(
        email: email,
        status: :invited
      )

      unless admin_user.save
        return {
          success: false,
          error: admin_user.errors.full_messages.join(", ")
        }
      end

      # Create the invitation
      invitation = Admin::Invitation.new(
        email: email,
        invited_by: invited_by,
        admin_user: admin_user
      )

      if invitation.save
        {
          success: true,
          invitation: invitation,
          admin_user: admin_user
        }
      else
        admin_user.destroy
        {
          success: false,
          error: invitation.errors.full_messages.join(", ")
        }
      end
    end

    def accept_invitation(invitation:, password:, password_confirmation:)
      unless invitation.present?
        return {
          success: false,
          error: "Invitation not found."
        }
      end

      if invitation.expired?
        return {
          success: false,
          error: "This invitation has expired."
        }
      end

      if invitation.accepted?
        return {
          success: false,
          error: "This invitation has already been accepted."
        }
      end

      if invitation.accept!(password: password, password_confirmation: password_confirmation)
        {
          success: true,
          admin_user: invitation.admin_user
        }
      else
        {
          success: false,
          error: invitation.admin_user.errors.full_messages.join(", ")
        }
      end
    end

    def self.cleanup_expired_invitations
      Admin::Invitation.cleanup_expired!
    end
  end
end
