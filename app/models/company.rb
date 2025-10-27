class Company < ApplicationRecord
  has_one_attached :logo

  validates :name, presence: true, uniqueness: true
  validates :address_1, :sub_district, :district, :province, :postal_code, :country, :phone_number, :email, presence: true
end
