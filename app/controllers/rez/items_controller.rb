module Rez
  class ItemsController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_resume, only: [:index]
    before_action :set_item, only: [:show, :update, :destroy]
    before_action :set_items, only: [:index]

    def create
      @item = Item.new(item_params)
      if @item.save
        render json: @item, status: :created
      else
        render json: @item.errors, status: :bad_request
      end
    end

    def index
      render json: @items
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

    def set_resume
      if params[:resume_id]
        @resume = Resume.find_by(id: params[:resume_id])
        head :not_found unless @resume
      end
    end

    def set_item
      @item = Item.find_by(id: params[:id])
      head :not_found unless @item
    end

    def set_items
      if @resume
        @items = @resume.items
      else
        @items = Item.all
      end
    end

    def item_params
      params.require(:item).permit(:name, :title, :heading, :visible)
    end
  end
end
