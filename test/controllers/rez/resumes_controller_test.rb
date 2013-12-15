require 'test_helper'

module Rez
  describe ResumesController do

    describe "POST create" do

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 201 Created" do
          post :create, use_route: 'rez'
          response.status.must_equal 201
        end

        it "creates a Resume" do
          assert_difference('Resume.count', 1) do
            post :create, use_route: 'rez'
          end
        end

        it "returns the created Resume in JSON format" do
          post :create, use_route: 'rez'
          response.body.must_equal ResumeSerializer.new(assigns(:resume)).to_json
        end
      end

      describe "with an invalid Toke key in the header" do

        it "responds with 401 Unauthorized" do
          post :create, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end
  end
end
