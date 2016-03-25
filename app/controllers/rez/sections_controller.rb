module Rez
  class SectionsController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_resume, only: [:index]
    before_action :set_sections, only: [:index]
    before_action :set_section, only: [:show, :update, :destroy]
    before_action :update_items, only: [:update]

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

    def show
      render json: @section
    end

    def update
      @section.update(section_params)
      render json: @section
    end

    def destroy
      @section.destroy
      head :no_content
    end

    private

    def set_sections
      if defined?(@resume)
        # @sections = @resume.sections
      else
        @sections = Section.all
      end
    end

    def set_section
      if params[:id]
        @section = Section.find_by(id: params[:id])
        head :not_found unless @section
      end
    end

    def update_items
      return unless params[:section][:item_ids]
      @section.items = item_params
      params[:section].delete(:item_ids)
    end

    def item_params
      params[:section][:item_ids].uniq.map { |item_id|
        Item.find_by(id: item_id)
      }.reject { |item| item.nil? }
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
