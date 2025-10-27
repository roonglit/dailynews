class Account::PaymentMethodsController < Account::BaseController
  def show
    @user = current_user
    # Future: fetch payment methods from payment provider
  end

  def edit
    @user = current_user
    # Future: allow editing payment methods
  end

  def update
    @user = current_user
    # Future: update payment methods

    respond_to do |format|
      format.html { redirect_to account_payment_method_path, notice: "Payment method updated successfully." }
    end
  end
end
