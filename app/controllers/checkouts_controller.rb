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
    product_title = params[:product_title]

    new_title = product_title == "1 Month Only" ? "Subscribe Monthly" : "1 Month Only"
    product = Product.find_by(title: product_title)

    if product.blank?
      redirect_to root_path, alert: "Product not found"
      return
    end

    current_user.cart.cart_item.update(product_id: product.id)
    redirect_to checkout_path, notice: "Switched to #{new_title}"
  end
end
