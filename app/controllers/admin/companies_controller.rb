
module Admin
  class CompaniesController < BaseController
    before_action :set_company, only: %i[show edit update]

    def show
    end

    def new
      @company = Company.new
    end

    def create
      @company = Company.new(company_params)

      respond_to do |format|
        if @company.save
          format.html { redirect_to [ :admin, @company ], notice: "Company was successfully created." }
          format.json { render :show, status: :created, location: @company }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @company.update(company_params)
          format.html { redirect_to admin_company_path, notice: "Company was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @company }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    end

    private
      def set_company
        @company = Company.first || Company.new(name: "-", address_1: "-", address_2: "-", sub_district: "-", district: "-", province: "-", postal_code: "-", country: "-", phone_number: "-", email: "-")
      end

      def company_params
        params.expect(company: [ :id, :name, :address_1, :address_2, :sub_district, :district, :province, :postal_code, :country, :phone_number, :email ])
      end
  end
end
