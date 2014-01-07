require 'test_helper'

module Rez
  describe ParagraphsController do

    describe "POST create" do

      let(:attrs) { FactoryGirl.attributes_for(:paragraph) }

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 201 Created" do
          post :create, paragraph: attrs, use_route: 'rez'
          response.status.must_equal 201
        end
        
        it "creates a Paragraph" do
          assert_difference('Paragraph.count', 1) do
            post :create, paragraph: attrs, use_route: 'rez'
          end
        end
      end

      describe "without a valid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create, paragraph: attrs, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end
  end
end
