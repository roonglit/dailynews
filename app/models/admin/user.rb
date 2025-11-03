module Admin
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    enum :status, { invited: 0, active: 1, inactive: 2 }

    has_one :invitation, class_name: "Invitation", foreign_key: :admin_user_id, dependent: :destroy
    has_many :sent_invitations, class_name: "Invitation", foreign_key: :invited_by_id, dependent: :destroy

    scope :search, ->(query) {
      if query.present?
        term = "%#{query}%"
        where(
          "email ILIKE :term",
          term: term
        )
      else
        all
      end
    }

    # Skip password validation for invited users
    def password_required?
      return false if invited?
      super
    end
  end
end
