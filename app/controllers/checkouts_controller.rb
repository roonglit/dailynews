class CheckoutsController < ApplicationController
  def show
    @order = Order.new
    @product = current_user.cart&.cart_item&.product
  end

  def add_product
    product_title = params[:product_title]

    product = Product.find_by(title: product_title)
    if product.blank?
      redirect_to root_path, alert: "Product not found"
      return
    end

    cart = Cart.find_or_create_by(user_id: current_user.id)
    cart.cart_item&.destroy


    cart_item = CartItem.new(cart_id: cart.id, product_id: product.id)
    if cart_item.save
      redirect_to checkout_path
    else
      redirect_to root_path, alert: "Failed to add product to cart"
    end
  end

  def create
  end

  def toggle_product
    cart = Cart.find_or_create_by(user_id: current_user.id)
    current_product = cart.cart_item&.product

    if current_product.nil?
      redirect_to checkout_path, alert: "No product in cart"
      return
    end

    # หา product ตัวใหม่ (อีกฝั่ง)
    new_title = current_product.title == "1 Month Only" ? "Subscribe Monthly" : "1 Month Only"
    new_product = Product.find_by(title: new_title)

    if new_product.nil?
      redirect_to checkout_path, alert: "Product not found"
      return
    end

    # ลบของเก่า แล้วเพิ่มของใหม่
    cart.cart_item&.destroy
    CartItem.create!(cart_id: cart.id, product_id: new_product.id)

    redirect_to checkout_path, notice: "Switched to #{new_title}"
  end
end
