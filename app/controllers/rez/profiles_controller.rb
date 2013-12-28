module Rez
  class ProfilesController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_profile, only: [:show, :update, :destroy]

    def create
      @profile = Profile.create(profile_params)
      render json: @profile, status: :created
    end

    def show
      render json: @profile
    end

    def index
      @profiles = Profile.all
      render json: @profiles
    end

    def update
      @profile.update(profile_params)
      render json: @profile
    end

    def destroy
      @profile.destroy
      head :no_content
    end

    private

    def set_profile
      @profile = Profile.find_by(id: params[:id])
      head :not_found unless @profile
    end

    def profile_params
      params.require(:profile).permit(:firstname, :middlename, :lastname, :nickname, :prefix, :suffix, :title)
    end
  end
end
