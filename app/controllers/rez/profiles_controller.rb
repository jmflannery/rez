module Rez
  class ProfilesController < ApplicationController

    def create
      @profile = Profile.create(profile_params)
      render json: @profile, status: 201
    end

    private

    def profile_params
      params.require(:profile).permit(:firstname, :middlename, :lastname, :nickname, :prefix, :suffix)
    end
  end
end
