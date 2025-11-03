module Admin
  module Settings
    class CompaniesController < BaseController
      before_action :set_company

      def show
      end

      def update
        if @company.update(company_params)
          redirect_to admin_settings_company_path, notice: "Company information was successfully updated."
        else
          render :show, status: :unprocessable_content
        end
      end

      private

      def set_company
        @company = Company.first || Company.new(
          name: "-",
          address_1: "-",
          address_2: "-",
          sub_district: "-",
          district: "-",
          province: "-",
          postal_code: "-",
          country: "-",
          phone_number: "-",
          email: "-"
        )
      end

      def company_params
        params.expect(company: [
          :id, :name, :address_1, :address_2, :sub_district,
          :district, :province, :postal_code, :country,
          :phone_number, :email, :logo
        ])
      end
    end
  end
end
