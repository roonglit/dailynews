class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :orders, foreign_key: :member_id
  # after_create :create_cart

  scope :search, ->(query) {
    if query.present?
      term = "%#{query}%"
      where(
        "email ILIKE :term OR first_name ILIKE :term OR last_name ILIKE :term",
        term: term
      )
    else
      all
    end
  }

  # STI: Guest and Member subclasses will override these
  def guest?
    false
  end

  def member?
    false
  end

  def name
    email || "User"
  end

  # Override Devise validations to make email/password optional for Guests
  def email_required?
    member?
  end

  def password_required?
    member? && super
  end
end
