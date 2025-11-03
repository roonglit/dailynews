module Admin
  class InvitationsController < ApplicationController
    before_action :set_invitation, only: [ :show, :accept ]

    def show
      if @invitation.expired?
        @status = :expired
      elsif @invitation.accepted?
        @status = :accepted
      elsif @invitation.declined?
        @status = :declined
      else
        @status = :pending
        @admin_user = @invitation.admin_user
      end
    end

    def accept
      if @invitation.expired?
        redirect_to admin_invitation_path(@invitation.token), alert: "This invitation has expired."
        return
      end

      if @invitation.accepted?
        redirect_to admin_invitation_path(@invitation.token), alert: "This invitation has already been accepted."
        return
      end

      service = InvitationService.new(invited_by: @invitation.invited_by)
      result = service.accept_invitation(
        invitation: @invitation,
        password: params[:admin_user][:password],
        password_confirmation: params[:admin_user][:password_confirmation]
      )

      if result[:success]
        sign_in(@invitation.admin_user, scope: :admin_user)
        redirect_to admin_root_path, notice: "Welcome! Your admin account has been activated."
      else
        @admin_user = @invitation.admin_user
        @status = :pending
        flash.now[:alert] = result[:error]
        render :show
      end
    end

    private

    def set_invitation
      @invitation = Admin::Invitation.find_by!(token: params[:token])
    rescue ActiveRecord::RecordNotFound
      redirect_to new_admin_user_session_path, alert: "Invitation not found."
    end
  end
end
