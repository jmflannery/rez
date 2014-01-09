module Rez
  class ItemsController < ApplicationController

    before_action :toke, only: [:create, :update]
    before_action :set_item, only: [:show, :update]

    def create
      @item = Item.new(item_params)
      @item.save
      render json: @item, status: :created
    end

    def index
      render json: Item.all
    end

    def show
      render json: @item
    end

    def update
      @item.update(item_params)
      render json: @item
    end

    private

    def set_item
      @item = Item.find_by(id: params[:id])
      head :not_found unless @item
    end

    def item_params
      params.require(:item).permit(:title, :heading)
    end
  end
end
