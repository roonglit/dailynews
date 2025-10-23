# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'prawn'

# Create membership products
Product.find_or_create_by!(sku: "MEMBERSHIP_ONE_MONTH") do |product|
  product.title = "1 Month Only"
  product.amount = Money.new(25000, "THB")
  product.description = "One-time payment for 1 month membership access to all newspapers"
end

Product.find_or_create_by!(sku: "MEMBERSHIP_MONTHLY_SUBSCRIPTION") do |product|
  product.title = "Subscribe Monthly"
  product.amount = Money.new(24900, "THB")
  product.description = "Monthly recurring subscription for unlimited access to all newspapers"
end

puts "✅ Products seeded successfully"

# Helper method to create a simple PDF with title and content
def create_sample_pdf(title, date, content)
  pdf = Prawn::Document.new

  # Add header with title and date
  pdf.font_size 24
  pdf.text title, align: :center, style: :bold
  pdf.move_down 10

  pdf.font_size 12
  pdf.text date.strftime("%B %d, %Y"), align: :center
  pdf.move_down 20

  # Add sample content
  pdf.font_size 10
  pdf.text content, align: :justify

  pdf.render
end

# Helper method to create a simple cover image
def create_sample_cover(title, date)
  require 'mini_magick'

  image = MiniMagick::Image.open("identify") do |identify|
    identify.size "600x800"
    identify.background "#ffffff"
  end

  # Create a simple white background with text
  image.combine_options do |c|
    c.size "600x800"
    c.background "#f0f0f0"
    c.fill "#333333"
    c.gravity "center"
    c.pointsize "40"
    c.font "Arial"
  end

  image.format "jpg"
  image.to_blob
rescue => e
  # Fallback: create minimal image if ImageMagick is not available
  nil
end

# Sample newspapers data
newspapers_data = [
  {
    title: "Daily Morning News",
    description: "Your trusted source for morning news and updates",
    published_at: Date.current - 1.day,
    content: "Welcome to Daily Morning News. In today's edition, we bring you the latest updates from around the world. Our comprehensive coverage includes politics, business, technology, sports, and entertainment. Stay informed with our expert analysis and in-depth reporting."
  },
  {
    title: "Bangkok Business Daily",
    description: "Thailand's premier business newspaper",
    published_at: Date.current - 2.days,
    content: "Bangkok Business Daily brings you the latest in financial markets, corporate news, and economic analysis. Today's highlights include market trends, investment opportunities, and expert commentary on the Thai economy. Your essential guide to business in Southeast Asia."
  },
  {
    title: "Technology Times",
    description: "Latest technology news and innovations",
    published_at: Date.current - 3.days,
    content: "Technology Times covers the fast-paced world of tech innovation. This issue explores artificial intelligence, cybersecurity trends, startup ecosystem updates, and reviews of the latest gadgets. Stay ahead with insights from industry leaders and tech experts."
  },
  {
    title: "Sports Weekly",
    description: "Complete sports coverage and analysis",
    published_at: Date.current - 4.days,
    content: "Sports Weekly delivers comprehensive coverage of football, basketball, tennis, and more. This week's edition features match analyses, player interviews, tournament updates, and exclusive behind-the-scenes stories from your favorite sports."
  },
  {
    title: "Health & Wellness Journal",
    description: "Your guide to healthy living",
    published_at: Date.current - 5.days,
    content: "Health & Wellness Journal provides expert advice on nutrition, fitness, mental health, and medical breakthroughs. This issue includes workout routines, healthy recipes, stress management tips, and interviews with healthcare professionals."
  },
  {
    title: "Travel Explorer",
    description: "Discover destinations around the world",
    published_at: Date.current - 6.days,
    content: "Travel Explorer takes you on a journey to exotic destinations. This edition features travel guides, cultural insights, hotel reviews, and tips for budget-friendly adventures. Explore hidden gems and popular tourist attractions alike."
  },
  {
    title: "Food & Dining Magazine",
    description: "Culinary delights and restaurant reviews",
    published_at: Date.current - 7.days,
    content: "Food & Dining Magazine celebrates the art of cuisine. This issue showcases chef interviews, restaurant reviews, cooking techniques, and mouth-watering recipes from around the world. Perfect for food enthusiasts and home cooks."
  },
  {
    title: "Finance & Investment Weekly",
    description: "Smart money management and investment strategies",
    published_at: Date.current - 8.days,
    content: "Finance & Investment Weekly helps you make informed financial decisions. This week covers stock market analysis, cryptocurrency trends, real estate investments, and personal finance tips. Your pathway to financial success."
  },
  {
    title: "Arts & Culture Review",
    description: "Celebrating creativity and cultural heritage",
    published_at: Date.current - 9.days,
    content: "Arts & Culture Review explores the world of visual arts, performing arts, literature, and cultural traditions. This edition features artist profiles, exhibition reviews, book recommendations, and insights into cultural movements."
  },
  {
    title: "Science & Discovery",
    description: "Exploring the frontiers of scientific knowledge",
    published_at: Date.current - 10.days,
    content: "Science & Discovery brings you the latest scientific breakthroughs and research findings. This issue covers space exploration, climate science, medical research, and fascinating discoveries that shape our understanding of the world."
  }
]

# Create newspapers with PDFs
puts "\n📰 Creating newspapers..."

newspapers_data.each do |data|
  newspaper = Newspaper.find_or_initialize_by(title: data[:title])

  if newspaper.new_record? || !newspaper.pdf.attached?
    newspaper.description = data[:description]
    newspaper.published_at = data[:published_at]

    # Create and attach PDF
    pdf_content = create_sample_pdf(
      data[:title],
      data[:published_at],
      data[:content]
    )

    newspaper.pdf.attach(
      io: StringIO.new(pdf_content),
      filename: "#{data[:title].parameterize}.pdf",
      content_type: "application/pdf"
    )

    # Try to create and attach cover image
    cover_blob = create_sample_cover(data[:title], data[:published_at])
    if cover_blob
      newspaper.cover.attach(
        io: StringIO.new(cover_blob),
        filename: "#{data[:title].parameterize}_cover.jpg",
        content_type: "image/jpeg"
      )
    end

    newspaper.save!
    puts "  ✓ Created: #{data[:title]}"
  else
    puts "  - Skipped: #{data[:title]} (already exists)"
  end
end

puts "\n✅ Newspapers seeded successfully"
puts "📊 Total newspapers: #{Newspaper.count}"
