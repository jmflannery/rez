require 'test_helper'

module Rez
  describe ItemsController do

    describe 'POST create' do

      let(:item_attrs) { FactoryGirl.attributes_for(:item) }

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 201 Created" do
          post :create, item: item_attrs, use_route: 'rez'
          response.status.must_equal 201
        end

        it "creates a new Item" do
          assert_difference('Item.count', 1) do
            post :create, item: item_attrs, use_route: 'rez'
          end
        end

        it "sets the new Items fields" do
          post :create, item: item_attrs, use_route: 'rez'
          json = JSON.parse(response.body)
          json['item']['title'].must_equal item_attrs[:title]
          json['item']['heading'].must_equal item_attrs[:heading]
        end

        it "returns the created Item in JSON format" do
          post :create, item: item_attrs, use_route: 'rez'
          response.body.must_equal ItemSerializer.new(assigns(:item)).to_json
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create, item: item_attrs, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end
  end
end
