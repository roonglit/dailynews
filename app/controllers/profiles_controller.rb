class ProfilesController < SettingsController
  before_action :set_profile, only: %i[ edit update ]

  # GET /profile
  def edit
  end

  # PATCH/PUT /profiles/1 or /profile.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profile_path, notice: "Profile was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = current_user.profile
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.expect(profile: [ :first_name, :last_name ])
    end
end
