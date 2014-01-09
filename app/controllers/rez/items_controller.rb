module Rez
  class ItemsController < ApplicationController

    before_action :toke, only: [:create]

    def create
      @item = Item.new(item_params)
      @item.save
      render json: @item, status: :created
    end

    def index
      render json: Item.all
    end

    private

    def item_params
      params.require(:item).permit(:title, :heading)
    end
  end
end
