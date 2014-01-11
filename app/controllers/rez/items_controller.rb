module Rez
  class ItemsController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_item, only: [:show, :update, :destroy]

    def create
      @item = Item.new(item_params)
      if @item.save
        render json: @item, status: :created
      else
        render json: @item.errors, status: :bad_request
      end
    end

    def index
      render json: Item.includes([:paragraphs, :bullets])
    end

    def show
      render json: @item
    end

    def update
      @item.update(item_params)
      render json: @item
    end

    def destroy
      @item.destroy
      head :no_content
    end

    private

    def set_item
      @item = Item.find_by(id: params[:id])
      head :not_found unless @item
    end

    def item_params
      params.require(:item).permit(:name, :title, :heading, :rank, :visible)
    end
  end
end
