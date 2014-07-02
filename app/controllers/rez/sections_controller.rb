module Rez
  class SectionsController < ApplicationController

    before_action :toke, only: [:create]

    def create
      section = Section.new(section_params)
      if section.save
        render json: section, status: :created
      else
        render json: section.errors, status: :bad_request
      end
    end

    private

    def section_params
      params.require(:section).permit(:name, :heading, :subheading)
    end
  end
end
