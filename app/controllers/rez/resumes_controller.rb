module Rez
  class ResumesController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_resume, only: [:show, :update, :destroy]
    before_action :update_profile, only: [:update]
    before_action :update_address, only: [:update]
    before_action :update_sections, only: [:update]

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
      render json: @resume
    end

    def update
      if @resume.update(resume_params)
        render json: @resume
      else
        render json: @resume.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @resume.destroy
      head :no_content
    end

    private

    def set_resume
      @resume = Resume.find_by(id: params[:id])
      head :not_found unless @resume
    end

    def update_profile
      if params[:resume][:profile_id]
        profile_id = params[:resume][:profile_id]
        if Profile.exists?(profile_id)
          @resume.update(profile_id: profile_id)
        else
          error = { profile_id: "Profile #{profile_id} not found" }
          render json: error, status: :not_found
        end
        params[:resume].delete(:profile_id)
      end
    end

    def update_address
      if params[:resume][:address_id]
        address_id = params[:resume][:address_id]
        if Address.exists?(address_id)
          @resume.update(address_id: address_id)
        else
          error = { address_id: "Address #{address_id} not found" }
          render json: error, status: :not_found
        end
        params[:resume].delete(:address_id)
      end
    end

    def update_sections
      @resume.sections = section_params if section_params
      params[:resume].delete(:section_ids)
    end

    def section_params
      return unless params[:resume][:section_ids]
      params[:resume][:section_ids].uniq.map { |section_id|
        Section.find_by(id: section_id)
      }.reject { |section| section.nil? }
    end

    def resume_params
      params.require(:resume).permit(:name)
    end
  end
end
