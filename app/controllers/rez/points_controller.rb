require 'test_helper'

module Rez
  class PointsController < ApplicationController

    before_action :toke
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
      render json: Point.all
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

    def set_point
      @point = Point.find_by(id: params[:id])
      head :not_found unless @point
    end

    def point_params
      params.require(:point).permit([:text, :rank, :point_type])
    end
  end
end
