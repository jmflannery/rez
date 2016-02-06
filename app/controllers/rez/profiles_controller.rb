module Rez
  class ProfilesController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_resume, only: [:show]
    before_action :set_profile, only: [:show, :update, :destroy]

    def create
      @profile = Profile.create(profile_params)
      render json: @profile, status: :created
    end

    def show
      render json: @profile
    end

    def index
      render json: Profile.all
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

    def set_resume
      if params[:resume_id]
        @resume = Resume.find_by(id: params[:resume_id])
        head :not_found unless @resume
      end
    end

    def set_profile
      if @resume
        @profile = @resume.profile
      else
        @profile = Profile.find_by(id: params[:id])
      end
      head :not_found unless @profile
    end

    def profile_params
      params.require(:profile).permit(:firstname, :middlename, :lastname, :nickname, :prefix, :suffix, :title, :email)
    end
  end
end
