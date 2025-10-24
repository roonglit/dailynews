class NewspapersController < ApplicationController
  before_action :authenticate_member!, only: %i[ show ]
  before_action :set_newspaper, only: %i[ show ]

  # GET /newspaper/1 or /newspaper/1.json
  def show
    authorize @newspaper
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_newspaper
      @newspaper = Newspaper.find(params.expect(:id))
    end
end
