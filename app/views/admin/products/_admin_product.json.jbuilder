json.extract! admin_product, :id, :title, :description, :amount, :created_at, :updated_at
json.url admin_product_url(product, format: :json)
