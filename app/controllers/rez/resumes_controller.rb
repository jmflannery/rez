module Rez
  class ResumesController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_resume, only: [:show, :update, :destroy]
    before_action :update_profile, only: [:update]
    before_action :update_address, only: [:update]
    before_action :update_items, only: [:update]

    def create
      params[:resume].delete(:item_ids) if params[:resume].has_key?(:item_ids)
      @resume = Resume.new(resume_params)
      if @resume.save
        render json: @resume, status: :created
      else
        render json: @resume.errors, status: :unprocessable_entity
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
      return unless params[:resume][:profile_id]
      profile_id = params[:resume][:profile_id]
      profile = Profile.find_by(id: profile_id)
      if profile
        @resume.profile = profile
        @resume.save
      else
        error = { profile_id: "Profile #{profile_id} not found" }
        render json: error, status: :bad_request
      end
      params[:resume].delete(:profile_id)
    end

    def update_address
      return unless params[:resume][:address_id]
      address_id = params[:resume][:address_id]
      address = Address.find_by(id: address_id)
      if address
        @resume.address = address
      else
        error = { address_id: "Address #{address_id} not found" }
        render json: error, status: :bad_request
      end
      params[:resume].delete(:address_id)
    end

    def update_items
      return unless params[:resume].has_key?(:item_ids)
      items = (params[:resume].fetch(:item_ids, []) || []).uniq.map do |item_id|
        Item.find_by(id: item_id)
      end.compact
      @resume.items = items
      params[:resume].delete(:item_ids)
    end

    def resume_params
      params.require(:resume).permit(:name)
    end
  end
end
