module Admin
  class ProductsController < BaseController
    before_action :set_product, only: %i[ show edit update destroy ]

    # GET /admin/products or /admin/products.json
    def index
      @products = Product.order_by_created_at
    end

    # GET /admin/products/1 or /admin/products/1.json
    def show
    end

    # GET /admin/products/new
    def new
      @product = Product.new
    end

    # GET /admin/products/1/edit
    def edit
    end

    # POST /admin/products or /admin/products.json
    def create
      @product = Product.new(product_params)

      respond_to do |format|
        if @product.save
          format.html { redirect_to [ :admin, @product ], notice: "Product was successfully created." }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/products/1 or /admin/products/1.json
    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to [ :admin, @product ], notice: "Product was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/products/1 or /admin/products/1.json
    def destroy
      @product.destroy!

      respond_to do |format|
        format.html { redirect_to admin_products_path, notice: "Product was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def product_params
        params.expect(product: [ :id, :title, :description, :amount ])
      end
  end
end
