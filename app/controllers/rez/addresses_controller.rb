require_dependency "rez/application_controller"

module Rez
  class AddressesController < ApplicationController

    def create
      @address = Address.create(address_params)
      render json: @address, status: :created
    end

    def show
      @address = Address.find(params[:id])
      render json: @address
    end

    def index
      @addresses = Address.all
      render json: @addresses
    end

    def update
      @address = Address.find(params[:id])
      @address.update_attributes(address_params)
      render json: @address
    end

    def destroy
      @address = Address.find(params[:id])
      @address.destroy
      head :no_content
    end

    private

    def address_params
      params.require(:address).permit(:building_number, :street_name, :secondary_address, :city, :state, :zip_code, :county, :country)
    end
  end
end
