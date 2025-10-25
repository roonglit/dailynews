module Admin
  class SubscriptionsController < BaseController
    before_action :set_customer, only: %i[new create]
    before_action :set_subscription, only: %i[edit update]
    before_action :check_editable, only: %i[edit update]

    def index
      @members = Member.all.order(:id)
    end

    def new
      @subscription = @member.subscriptions.build(
        start_date: Date.current,
        end_date: Date.current + 1.month,
        auto_renew: false
      )
    end

    def create
      @subscription = @member.subscriptions.build(subscription_params.merge(auto_renew: false))

      if @subscription.save
        redirect_to admin_customer_path(@member), notice: "Subscription created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @member = @subscription.user
    end

    def update
      if @subscription.update(subscription_params)
        redirect_to admin_customer_path(@subscription.user), notice: "Subscription updated successfully."
      else
        @member = @subscription.user
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_customer
      @member = Member.find(params[:customer_id])
    end

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def check_editable
      unless @subscription.editable?
        redirect_to admin_customer_path(@subscription.user), alert: "This subscription cannot be edited because it has an associated order."
      end
    end

    def subscription_params
      params.require(:subscription).permit(:start_date, :end_date)
    end
  end
end
