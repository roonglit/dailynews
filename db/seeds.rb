# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create membership products
Product.find_or_create_by!(sku: "MEMBERSHIP_ONE_MONTH") do |product|
  product.title = "1 Month Only"
  product.amount = 299
  product.description = "One-time payment for 1 month membership access to all newspapers"
end

Product.find_or_create_by!(sku: "MEMBERSHIP_MONTHLY_SUBSCRIPTION") do |product|
  product.title = "Subscribe Monthly"
  product.amount = 249
  product.description = "Monthly recurring subscription for unlimited access to all newspapers"
end

puts "✅ Products seeded successfully"
