class ProfilesController < ApplicationController
  before_action :set_profile

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_url, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private
    def set_profile
      @profile = Profile.find_or_create_by(user_id: current_user.id)
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :about)
    end
end
