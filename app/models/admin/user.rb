module Admin
  class User < ApplicationRecord
    self.table_name = "admin_users"
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

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
  end
end
