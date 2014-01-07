require 'test_helper'

module Rez
  class ParagraphsController < ApplicationController

    before_action :toke, only: [:create, :index, :show]
    before_action :set_paragraph, only: [:show]

    def create
      paragraph = Paragraph.create(paragraph_params)
      render json: paragraph, status: :created
    end

    def index
      render json: Paragraph.all
    end

    def show
      render json: @paragraph
    end

    private

    def set_paragraph
      @paragraph = Paragraph.find_by(id: params[:id])
      head :not_found unless @paragraph
    end

    def paragraph_params
      params.require(:paragraph).permit([:text, :rank])
    end
  end
end
