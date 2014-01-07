require 'test_helper'

module Rez
  class ParagraphsController < ApplicationController

    before_action :toke, only: [:create, :index]

    def create
      paragraph = Paragraph.create(paragraph_params)
      render json: paragraph, status: :created
    end

    def index
      render json: Paragraph.all
    end

    private

    def paragraph_params
      params.require(:paragraph).permit([:text, :rank])
    end
  end
end
