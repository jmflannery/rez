module Rez
  class ResumesController < ApplicationController

    before_action :toke

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

    private

    def resume_params
      params.require(:resume).permit(:name)
    end
  end
end
