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

        describe "given no resume name" do

          before do item_attrs[:name] = '' end

          it "responds with 400 Bad Request" do
            post :create, item: item_attrs, use_route: 'rez'
            response.status.must_equal 400
          end

          it "returns a hash with the error message" do
            post :create, item: item_attrs, use_route: 'rez'
            response.body.must_equal({name: ["can't be blank"]}.to_json)
          end
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

      let(:item1) { FactoryGirl.create(:item) }
      let(:item2) { FactoryGirl.create(:item) }

      before do
        @items = [item2, item1]
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

      describe "if resume_id is given" do

        let(:item3) { FactoryGirl.create(:item) }

        before do
          @resume = FactoryGirl.create(:resume, item_ids: [item1.id, item3.id])
        end

        it "returns only the items for the given resume" do
          get :index, resume_id: @resume.id, use_route: 'rez'
          json = JSON.parse(response.body)
          json['items'].size.must_equal 2
          json['items'][0]['id'].must_equal item1.id
          json['items'][1]['id'].must_equal item3.id
        end

        describe "resume_id is invalid" do

          it "responds with 404 Not Found" do
            get :index, resume_id: 'wrong', use_route: 'rez'
            response.status.must_equal 404
          end
        end 
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

    describe "PUT update" do

      let(:item) { FactoryGirl.create(:item) }
      let(:update_attrs) {{ title: 'My Awesome Title', heading: 'My Sweet Heading' }}

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "on successfull update" do

          it "responds with 200 OK" do
            put :update, id: item, item: update_attrs, use_route: 'rez'
            response.status.must_equal 200
          end

          it "updates the item record" do
            put :update, id: item, item: update_attrs, use_route: 'rez'
            item.reload.title.must_equal('My Awesome Title')
            item.heading.must_equal('My Sweet Heading')
          end

          it "returns the updated item in JSON format" do
            put :update, id: item, item: update_attrs, use_route: 'rez'
            response.body.must_equal(ItemSerializer.new(item.reload).to_json)
          end

          describe "updating the Item's Bullets" do

            let(:bullet1) { FactoryGirl.create(:bullet) }
            let(:bullet2) { FactoryGirl.create(:bullet) }
            let(:update_attrs) {{
              bullet_ids: [bullet1.id, bullet2.id],
              name: 'New name',
              title: 'New title',
              heading: 'New heading'
            }}

            it "responds with 200 OK" do
              put :update, id: item, item: update_attrs, use_route: 'rez'
              response.status.must_equal 200
            end

            it "updates the Item's bullet_ids" do
              put :update, id: item, item: update_attrs, use_route: 'rez'
              item.reload.bullet_ids.must_equal [bullet1.id, bullet2.id]
            end

            it "does not update invalid bullet ids" do
              update_attrs[:bullet_ids] << 1234
              put :update, id: item, item: update_attrs, use_route: 'rez'
              item.reload.bullet_ids.wont_include 1234
            end

            it 'does not insert duplicate bullets' do
              update_attrs[:bullet_ids] << bullet1.id
              put :update, id: item, item: update_attrs, use_route: 'rez'
              item.reload.bullet_ids.must_equal [bullet1.id, bullet2.id]
            end

            it 'removes bullets from the item that are not given in bullet_ids' do
              item.bullet_ids << bullet1.id
              item.bullet_ids_will_change!
              item.save
              update_attrs[:bullet_ids].delete_at(0)
              put :update, id: item, item: update_attrs, use_route: 'rez'
              item.reload.bullet_ids.wont_include bullet1.id
            end
          end
        end

        describe "given an invalid item id" do

          it "responds with 404 Not Found" do
            put :update, id: 'nope', item: update_attrs, use_route: 'rez'
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          put :update, id: item, item: update_attrs, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end

    describe "DELETE destroy" do

      before do @item = FactoryGirl.create(:item) end

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "given a valid Item id" do

          it "destroys the item" do
            assert_difference('Item.count', -1) do
              delete :destroy, id: @item, use_route: 'rez'
            end
          end 

          it "responds with 204 No Content" do
            delete :destroy, id: @item, use_route: 'rez'
            response.status.must_equal 204
            response.body.must_equal ''
          end
        end

        describe "given an invalid Item id" do

          it "responds with 404 Not Found" do
            delete :destroy, id: 'wrong', use_route: 'rez'
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          delete :destroy, id: @item, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end
  end
end
