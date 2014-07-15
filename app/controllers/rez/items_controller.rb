module Rez
  class ItemsController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_section, only: [:index]
    before_action :set_item, only: [:show, :update, :destroy]
    before_action :set_items, only: [:index]
    before_action :update_points, only: [:update]

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

    def set_section
      if params[:section_id]
        @section = Section.find_by(id: params[:section_id])
        head :not_found unless @section
      end
    end

    def set_item
      @item = Item.find_by(id: params[:id])
      head :not_found unless @item
    end

    def set_items
      if @section
        @items = @section.items
      else
        @items = Item.all
      end
    end

    def update_points
      @item.points = point_params if point_params
      params[:item].delete(:point_ids)
    end

    def point_params
      return unless params[:item][:point_ids]
      params[:item][:point_ids].uniq.map { |point_id|
        Point.find_by(id: point_id)
      }.reject { |point| point.nil? }
    end

    def item_params
      params.require(:item).permit(:name, :title, :heading, :visible)
    end
  end
end

