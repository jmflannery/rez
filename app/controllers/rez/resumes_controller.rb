module Rez
  class ResumesController < ApplicationController

    before_action :toke

    def create
      @resume = Resume.create
      render json: @resume, status: 201
    end
  end
end
