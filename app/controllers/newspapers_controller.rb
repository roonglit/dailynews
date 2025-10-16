class NewspapersController < ApplicationController
  before_action :authenticate_member!, only: %i[ read ]
  before_action :set_newspaper, only: %i[ show read edit update destroy ]

  # GET /newspapers or /newspapers.json
  def index
    @newspapers = Newspaper.where.not(published_at: nil).order(published_at: :desc)
  end

  # GET /newspaper/1 or /newspaper/1.json
  def show
  end

  def read
    authorize @newspaper
  end

  # GET /newspapers/new
  def new
    @newspaper = Newspaper.new
  end

  # GET /newspaper/1/edit
  def edit
  end

  # POST /newspaper or /newspaper.json
  def create
    @newspaper = Newspaper.new(newspaper_params)

    respond_to do |format|
      if @newspaper.save
        format.html { redirect_to admin_newspaper_path(@newspaper), notice: "Newspaper was successfully created." }
        format.json { render :show, status: :created, location: @newspaper }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @newspaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /newspaper/1 or /newspaper/1.json
  def update
    respond_to do |format|
      if @newspaper.update(newspaper_params)
        format.html { redirect_to admin_newspaper_path(@newspaper), notice: "Newspaper was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @newspaper }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @newspaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /newspaper/1 or /newspaper/1.json
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
      params.fetch(:newspaper, {})
    end
end
