# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create subscription products
Product.find_or_create_by!(sku: "MEMBERSHIP_ONE_MONTH") do |product|
  product.title = "1 Month Only"
  product.amount = Money.new(25000, "THB")
  product.description = "One-time payment for 1 month subscription access to all newspapers"
end

Product.find_or_create_by!(sku: "MEMBERSHIP_MONTHLY_SUBSCRIPTION") do |product|
  product.title = "Subscribe Monthly"
  product.amount = Money.new(24900, "THB")
  product.description = "Monthly recurring subscription for unlimited access to all newspapers"
end

puts "✅ Products seeded successfully"

# Create company information
puts "\n🏢 Creating company record..."

Company.find_or_create_by!(name: "บริษัท เดลินิวส์ เว็บ จำกัด") do |company|
  company.address_1     = "1/4 ถนนวิภาวดีรังสิต"
  company.address_2     = ""
  company.sub_district  = "ตลาดบางเขน"
  company.district      = "หลักสี่"
  company.province      = "กรุงเทพมหานคร"
  company.postal_code   = "10210"
  company.country       = "ประเทศไทย"
  company.phone_number  = "0-2790-1111"
  company.email         = "webmaster@dailynews.co.th"
end

puts "\n✅ Company seeded successfully"