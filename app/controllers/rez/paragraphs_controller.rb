require 'test_helper'

module Rez
  class ParagraphsController < ApplicationController

    def create
      paragraph = Paragraph.create(paragraph_params)
      render json: paragraph, status: :created
    end

    private

    def paragraph_params
      params.require(:paragraph).permit([:text, :rank])
    end
  end
end
