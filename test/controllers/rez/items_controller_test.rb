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

    describe 'GET index' do

      let(:item) { FactoryGirl.create(:item) }
      let(:item2) { FactoryGirl.create(:item) }

      before do
        @items = [item, item2]
      end

      it "responds with 200 OK" do
        get :index, use_route: 'rez'
        response.status.must_equal 200
      end

      it "returns all the Items in JSON format" do
        get :index, use_route: 'rez'
        serializer = ActiveModel::ArraySerializer.new(@items, each_serializer: ItemSerializer)
        response.body.must_equal({ items: serializer }.to_json)
      end
    end

    describe "GET show" do

      let(:item) { FactoryGirl.create(:item) }

      describe "given a valid Item id" do

        it "responds with 200 OK" do
          get :show, id: item, use_route: 'rez'
          response.status.must_equal 200
        end

        it "responds with the requested Item in JSON format" do
          get :show, id: item, use_route: 'rez'
          response.body.must_equal(ItemSerializer.new(item).to_json)
        end
      end

      describe "given an invalid Item id" do

        it "responds with 404 Not Found" do
          get :show, id: 'wrong', use_route: 'rez'
          response.status.must_equal 404
        end
      end
    end
  end
end
