class AdminInvitation < ApplicationRecord
  belongs_to :invited_by, class_name: "Admin::User"
  belongs_to :admin_user, class_name: "Admin::User", optional: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[pending accepted declined expired] }

  before_validation :generate_token, on: :create
  before_validation :set_expiration, on: :create

  after_create :send_invitation_email

  scope :pending, -> { where(status: "pending") }
  scope :active, -> { pending.where("expires_at > ?", Time.current) }
  scope :expired_pending, -> { pending.where("expires_at <= ?", Time.current) }

  def generate_token
    return if token.present?

    loop do
      self.token = SecureRandom.urlsafe_base64(32)
      break unless AdminInvitation.exists?(token: token)
    end
  end

  def set_expiration
    self.expires_at ||= 7.days.from_now
  end

  def send_invitation_email
    Admin::UserMailer.invite_admin(self).deliver_later
  end

  def accept!(password:, password_confirmation:)
    return false if expired? || accepted?

    transaction do
      admin_user.update!(
        password: password,
        password_confirmation: password_confirmation,
        status: :active
      )
      update!(status: "accepted", accepted_at: Time.current)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def decline!
    return false unless pending?

    update(status: "declined")
  end

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def pending?
    status == "pending"
  end

  def accepted?
    status == "accepted"
  end

  def declined?
    status == "declined"
  end

  def self.cleanup_expired!
    expired_pending.update_all(status: "expired")
  end
end
