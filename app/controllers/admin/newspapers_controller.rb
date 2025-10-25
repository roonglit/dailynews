module Admin
  class NewspapersController < BaseController
    include Pagy::Backend
    before_action :set_newspaper, only: %i[ show edit update destroy ]

    # GET /admin/newspapers or /admin/newspapers.json
    def index
      items_per_page = params[:per_page].to_i
      items_per_page = 10 unless items_per_page.positive?
      page = params[:page].present? && params[:page].to_i > 0 ? params[:page].to_i : 1
      newspapers = Newspaper.search(params[:q])
      @pagy, @newspapers = pagy(newspapers, limit: items_per_page, page: page, params: { q: params[:q], per_page: params[:per_page] }.compact)
    end

    # GET /admin/newspapers/1 or /admin/newspapers/1.json
    def show
    end

    # GET /admin/newspapers/new
    def new
      @newspaper = Newspaper.new
    end

    # GET /admin/newspapers/1/edit
    def edit
    end

    # POST /admin/newspapers or /admin/newspapers.json
    def create
      @newspaper = Newspaper.new(newspaper_params)

      respond_to do |format|
        if @newspaper.save
          ExtractCoverJob.perform_later @newspaper.id
          format.html { redirect_to [ :admin, @newspaper ], notice: "Newspaper was successfully created." }
          format.json { render :show, status: :created, location: @newspaper }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @newspaper.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/newspapers/1 or /admin/newspapers/1.json
    def update
      respond_to do |format|
        if @newspaper.update(newspaper_params)
          ExtractCoverJob.perform_later @newspaper.id
          format.html { redirect_to [ :admin, @newspaper ], notice: "Newspaper was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @newspaper }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @newspaper.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/newspapers/1 or /admin/newspapers/1.json
    def destroy
      @newspaper.destroy!

      respond_to do |format|
        format.html { redirect_to admin_newspapers_path, notice: "Newspaper was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_newspaper
        @newspaper = Newspaper.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def newspaper_params
        params.expect(newspaper: [ :title, :description, :published_at, :pdf ])
      end
  end
end
