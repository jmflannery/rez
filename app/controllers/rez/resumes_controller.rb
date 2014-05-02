module Rez
  class ResumesController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_resume, only: [:show, :update, :destroy]
    before_action :update_profile, only: [:update]
    before_action :update_address, only: [:update]
    before_action :update_items, only: [:update]

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

    def update_items
      ids = []
      if params[:resume][:item_ids]
        params[:resume][:item_ids].uniq.map { |i| i.to_i }.each do |item_id|
          if Item.exists?(item_id)
            ids << item_id
          end
        end
      end
      @resume.item_ids = ids
      @resume.item_ids_will_change!
      @resume.save
    end

    def resume_params
      params.require(:resume).permit(:name)
    end
  end
end
