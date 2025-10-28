class Account::PaymentMethodsController < Account::BaseController
  def show
    @user = current_user
    # Future: fetch payment methods from payment provider
    customer = Omise::Customer.retrieve(@user.omise_customer_id) if @user.omise_customer_id.present?
    @cards = customer.cards if customer.present?

    p @cards
  end

  def update
    @user = current_user
    card_id = params[:card_id]
    token = params[:token]

    if @user.omise_customer_id.present? && card_id.present? && token.present?
      customer = Omise::Customer.retrieve(@user.omise_customer_id)

      # Delete the old card
      old_card = customer.cards.retrieve(card_id)
      old_card.destroy

      # Add the new card with the token
      customer.update(card: token)

      redirect_to account_payment_method_path, notice: "Payment method updated successfully."
    else
      redirect_to account_payment_method_path, alert: "Unable to update payment method."
    end
  rescue Omise::Error => e
    redirect_to account_payment_method_path, alert: "Error updating payment method: #{e.message}"
  end

  def destroy
    @user = current_user
    card_id = params[:card_id]

    if @user.omise_customer_id.present? && card_id.present?
      customer = Omise::Customer.retrieve(@user.omise_customer_id)
      card = customer.cards.retrieve(card_id)
      card.destroy
      redirect_to account_payment_method_path, notice: "Payment method deleted successfully."
    else
      redirect_to account_payment_method_path, alert: "Unable to delete payment method."
    end
  rescue Omise::Error => e
    redirect_to account_payment_method_path, alert: "Error deleting payment method: #{e.message}"
  end
end
