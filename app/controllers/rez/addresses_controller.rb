module Rez
  class AddressesController < ApplicationController

    before_action :set_address, only: [:show, :update, :destroy]

    def create
      @address = Address.create(address_params)
      render json: @address, status: :created
    end

    def show
      render json: @address
    end

    def index
      @addresses = Address.all
      render json: @addresses
    end

    def update
      @address.update(address_params)
      render json: @address
    end

    def destroy
      @address.destroy
      head :no_content
    end

    def self.permitted_params
      [:building_number, :street_name, :secondary_address, :city, :state, :zip_code, :county, :country, :area_code, :phone_number]
    end

    private

    def set_address
      @address = Address.find_by(id: params[:id])
      head :not_found unless @address
    end

    def address_params
      params.require(:address).permit(AddressesController.permitted_params)
    end
  end
end
