require_dependency "rez/application_controller"

module Rez
  class AddressesController < ApplicationController

    def create
      @address = Address.create(address_params)
      render json: @address, status: 201
    end

    def show
      @address = Address.find(params[:id])
      render json: @address
    end

    def index
      @addresses = Address.all
      render json: @addresses
    end

    private

    def address_params
      params.require(:address).permit(:building_number, :street_name, :secondary_address, :city, :state, :zip_code, :county, :country)
    end
  end
end
