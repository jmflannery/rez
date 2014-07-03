module Rez
  class SectionsController < ApplicationController

    before_action :toke, only: [:create]
    before_action :set_resume, only: [:index]
    before_action :set_sections, only: [:index]

    def create
      section = Section.new(section_params)
      if section.save
        render json: section, status: :created
      else
        render json: section.errors, status: :bad_request
      end
    end

    def index
      render json: @sections
    end

    private

    def set_sections
      if @resume
        @sections = @resume.sections
      else
        @sections = Section.all
      end
    end

    def set_resume
      if params[:resume_id]
        @resume = Resume.find_by(id: params[:resume_id])
        head :not_found unless @resume
      end
    end

    def section_params
      params.require(:section).permit(:name, :heading, :subheading)
    end
  end
end
