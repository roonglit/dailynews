class Account::InformationController < Account::BaseController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to account_information_path, notice: "Account information updated successfully." }
      else
        format.html { render :edit, status: :unprocessable_content }
      end
    end
  end

  private

  def user_params
    params.require(:member).permit(:email, :first_name, :last_name)
  end
end
