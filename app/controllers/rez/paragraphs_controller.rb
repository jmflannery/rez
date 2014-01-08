require 'test_helper'

module Rez
  class ParagraphsController < ApplicationController

    before_action :toke
    before_action :set_paragraph, only: [:show, :update, :destroy]

    def create
      paragraph = Paragraph.new(paragraph_params)
      if paragraph.save
        render json: paragraph, status: :created
      else
        render json: paragraph.errors, status: :bad_request
      end
    end

    def index
      render json: Paragraph.all
    end

    def show
      render json: @paragraph
    end

    def update
      @paragraph.update(paragraph_params)
      render json: @paragraph
    end

    def destroy
      @paragraph.destroy
      head :no_content
    end

    private

    def set_paragraph
      @paragraph = Paragraph.find_by(id: params[:id])
      head :not_found unless @paragraph
    end

    def paragraph_params
      params.require(:paragraph).permit([:text, :rank, :point_type])
    end
  end
end
