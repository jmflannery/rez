module Rez
  class ResumesController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]

    def create
      @resume = Resume.new(resume_params)
      if @resume.save
        render json: @resume, status: :created
      else
        render json: @resume.errors, status: :bad_request
      end
    end

    def index
      render json: Resume.all
    end

    def show
      resume = Resume.find_by(id: params[:id])
      if resume
        render json: resume
      else
        head :bad_request
      end
    end

    def update
      resume = Resume.find_by(id: params[:id])
      if resume
        resume.update(resume_params)
        render json: resume
      else
        head :not_found
      end
    end

    def destroy
      resume = Resume.find_by(id: params[:id])
      if resume
        resume.destroy
        head :no_content
      else
        head :bad_request
      end
    end

    private

    def resume_params
      params.require(:resume).permit(:name)
    end
  end
end
