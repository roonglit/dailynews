
module Admin
  class CompaniesController < BaseController
    before_action :set_company, only: %i[show edit update]
    def show
    end

    def edit
    end

    def update
      respond_to do |format|
        if @company.update(company_params)
          format.html { redirect_to admin_company_path(@company), notice: "Company was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @company }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    end

    private
      def set_company
        @company = Company.first
      end

      def company_params
        params.expect(company: [ :id, :address_1, :address_2, :sub_district, :district, :province, :postal_code, :country, :phone_number, :email ])
      end
  end
end
