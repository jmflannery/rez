module Rez
  class ProfilesController < ApplicationController

    def create
      @profile = Profile.create(profile_params)
      render json: @profile, status: 201
    end

    def show
      @profile = Profile.find(params[:id])
      render json: @profile
    end

    def index
      @profiles = Profile.all
      render json: @profiles
    end

    private

    def profile_params
      params.require(:profile).permit(:firstname, :middlename, :lastname, :nickname, :prefix, :suffix, :title)
    end
  end
end
