module Rez
  class PointsController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_type, only: [:index]
    before_action :set_item, only: [:index]
    before_action :set_points, only: [:index]
    before_action :set_point, only: [:show, :update, :destroy]

    def create
      point = Point.new(point_params)
      if point.save
        render json: point, status: :created
      else
        render json: point.errors, status: :bad_request
      end
    end

    def index
      render json: @points
    end

    def show
      render json: @point
    end

    def update
      if @point.update(point_params)
        render json: @point
      else
        render json: @point.errors, status: :bad_request
      end
    end

    def destroy
      @point.destroy
      head :no_content
    end

    private

    def set_item
      if params[:item_id]
        @item = Item.find_by(id: params[:item_id])
      end
    end

    def set_type
      if params[:type]
        if params[:type] == 'bullet'
          @type = :bullets
        elsif params[:type] = 'paragraph'
          @type = :paragraphs
        end
      end
    end

    def set_points
      @points = @item.send(@type) if @type && @item
      @points = Point.send(@type) if @type && !@item
      @points = @item.points if !@type && @item
      @points = Point.all if !@type && !@item
    end

    def set_point
      @point = Point.find_by(id: params[:id])
      head :not_found unless @point
    end

    def point_params
      params.require(:point).permit([:text, :rank, :point_type])
    end
  end
end
