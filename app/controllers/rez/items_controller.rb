module Rez
  class ItemsController < ApplicationController

    before_action :toke, only: [:create, :update, :destroy]
    before_action :set_parent, only: [:create, :index, :update]
    before_action :set_item, only: [:show, :update, :destroy]
    before_action :set_items, only: [:index]
    before_action :update_items, only: [:update]
    before_action :update_points, only: [:update]
    after_action :update_parent, only: [:create, :update]

    def create
      params[:item].delete(:bullet_ids) if params[:item].has_key?(:bullet_ids)
      params[:item].delete(:paragraph_ids) if params[:item].has_key?(:paragraph_ids)
      @item = Item.new(item_params)
      if @item.save
        render json: @item, status: :created
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def index
      render json: @items
    end

    def show
      render json: @item
    end

    def update
      if @item.update(item_params)
        render json: @item
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @item.destroy
      head :no_content
    end

    private

    def set_parent
      return unless params[:item_id] || params[:resume_id]
      @parent = if params[:item_id]
        Item.find_by(id: params[:item_id])
      elsif params[:resume_id]
        Resume.find_by(id: params[:resume_id])
      end
      head :not_found unless @parent
    end

    def set_item
      @item = Item.find_by(id: params[:id])
      head :not_found unless @item
    end

    def set_items
      @items = if defined? @parent
        params[:item_id] ? @parent.subitems : @parent.items
      else
        Item.all
      end
    end

    def update_items
      return unless params[:item].has_key?(:subitem_ids)
      items = (params[:item].fetch(:subitem_ids, []) || []).uniq.map do |item_id|
        Item.find_by(id: item_id)
      end.compact
      @item.subitems = items
      params[:item].delete(:subitem_ids)
    end

    def update_points
      return unless params[:item] && (params[:item].has_key?(:bullet_ids) || params[:item].has_key?(:paragraph_ids))
      @item.points = point_params
      params[:item].delete(:bullet_ids) if params[:item].has_key?(:bullet_ids)
      params[:item].delete(:paragraph_ids) if params[:item].has_key?(:paragraph_ids)
    end

    def update_parent
      return unless defined?(@item) && @item.persisted? && defined?(@parent)
      if params[:item_id]
        @parent.subitems << @item
      elsif params[:resume_id]
        @parent.items << @item
      end
    end

    def point_params
      (params[:item].fetch(:bullet_ids, []) || []).concat(params[:item].fetch(:paragraph_ids, []) || []).uniq.map do |point_id|
        Point.find_by(id: point_id)
      end.compact
    end

    def item_params
      params.require(:item).permit(:name, :title, :heading, :visible)
    end
  end
end
