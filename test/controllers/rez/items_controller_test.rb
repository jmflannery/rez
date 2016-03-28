require 'test_helper'

module Rez
  describe ItemsController do
    setup do
      @routes = Engine.routes
    end

    describe 'POST create' do

      let(:item_attrs) { FactoryGirl.attributes_for(:item) }

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 201 Created" do
          post :create, item: item_attrs
          response.status.must_equal 201
        end

        it "creates a new Item" do
          assert_difference('Item.count', 1) do
            post :create, item: item_attrs
          end
        end

        it "sets the new Items fields" do
          post :create, item: item_attrs
          json = JSON.parse(response.body)
          json['item']['title'].must_equal item_attrs[:title]
          json['item']['heading'].must_equal item_attrs[:heading]
        end

        it "returns the created Item in JSON format" do
          post :create, item: item_attrs
          response.body.must_equal ItemSerializer.new(assigns(:item)).to_json
        end

        describe 'given a valid resume id' do

          let(:resume) { FactoryGirl.create(:resume) }

          it 'adds the new item to the resume' do
            post :create, item: item_attrs, resume_id: resume.id
            id = JSON.parse(response.body)['item']['id']
            resume.reload.item_ids.must_include id
          end
        end

        describe 'given a valid parent Item id' do

          let(:parent) { FactoryGirl.create(:item) }

          it 'adds the new item to the parent Item' do
            post :create, item: item_attrs, parent_id: parent.id
            id = JSON.parse(response.body)['item']['id']
            parent.reload.subitem_ids.must_include id
          end
        end

        describe "given no name" do

          before do item_attrs[:name] = '' end

          it "responds with 400 Bad Request" do
            post :create, item: item_attrs
            response.status.must_equal 422
          end

          it "returns a hash with the error message" do
            post :create, item: item_attrs
            response.body.must_equal({name: ["can't be blank"]}.to_json)
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create, item: item_attrs
          response.status.must_equal 401
        end
      end
    end

    describe 'GET index' do

      let(:item1) { FactoryGirl.create(:item) }
      let(:item2) { FactoryGirl.create(:item) }

      before do
        @items = [item1, item2]
      end

      it "responds with 200 OK" do
        get :index
        response.status.must_equal 200
      end

      it "returns all the Items in JSON format" do
        get :index
        serializer = ActiveModel::ArraySerializer.new(@items, each_serializer: ItemSerializer)
        response.body.must_equal({ items: serializer }.to_json)
      end

      describe "given a resume id" do

        let(:item3) { FactoryGirl.create(:item) }

        before do
          @resume = FactoryGirl.create(:resume, item_ids: [item1.id, item3.id])
        end

        it "returns only the items for the given resume" do
          get :index, resume_id: @resume.id
          json = JSON.parse(response.body)
          json['items'].size.must_equal 2
          ids = json['items'].map{ |i| i['id'] }
          ids.wont_include item2.id
          ids.must_include item1.id
          ids.must_include item3.id
        end
      end

      describe "given an invalid resume id" do

        it "responds with 404 Not Found" do
          get :index, resume_id: 'wrong'
          response.status.must_equal 404
        end
      end

      describe "given a parent Item id" do

        let(:item3) { FactoryGirl.create(:item) }

        before do
          @parent = FactoryGirl.create(:item, subitem_ids: [item1.id, item3.id])
        end

        it "returns only the items for the given parent Item" do
          get :index, parent_id: @parent.id
          json = JSON.parse(response.body)
          json['items'].size.must_equal 2
          ids = json['items'].map{ |i| i['id'] }
          ids.wont_include item2.id
          ids.must_include item1.id
          ids.must_include item3.id
        end
      end

      describe "given an invalid parent Item id" do

        it "responds with 404 Not Found" do
          get :index, parent_id: 'wrong'
          response.status.must_equal 404
        end
      end
    end

    describe "GET show" do

      let(:item) { FactoryGirl.create(:item) }

      describe "given a valid Item id" do

        it "responds with 200 OK" do
          get :show, id: item
          response.status.must_equal 200
        end

        it "responds with the requested Item in JSON format" do
          get :show, id: item
          response.body.must_equal(ItemSerializer.new(item).to_json)
        end
      end

      describe "given an invalid Item id" do

        it "responds with 404 Not Found" do
          get :show, id: 'wrong'
          response.status.must_equal 404
        end
      end
    end

    describe "PUT update" do

      let(:item) { FactoryGirl.create(:item) }
      let(:update_attrs) {{ name: 'my item', title: 'My Awesome Title', heading: 'My Sweet Heading' }}

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "on successfull update" do

          it "responds with 200 OK" do
            put :update, id: item, item: update_attrs
            response.status.must_equal 200
          end

          it "updates the item record" do
            put :update, id: item, item: update_attrs
            item.reload.title.must_equal('My Awesome Title')
            item.heading.must_equal('My Sweet Heading')
          end

          it "returns the updated item in JSON format" do
            put :update, id: item, item: update_attrs
            response.body.must_equal(ItemSerializer.new(item.reload).to_json)
          end

          describe "given a resume id" do
            let(:resume) { FactoryGirl.create(:resume) }

            it "adds the new item to the resume" do
              put :update, id: item, item: update_attrs, resume_id: resume.id
              id = JSON.parse(response.body)['item']['id']
              resume.reload.item_ids.must_include id
            end
          end

          describe 'given a valid parent Item id' do

            let(:parent) { FactoryGirl.create(:item) }

            it 'adds the new item to the parent Item' do
              put :update, id: item, item: update_attrs, parent_id: parent.id
              id = JSON.parse(response.body)['item']['id']
              parent.reload.subitem_ids.must_include id
            end
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

            it "updates the Item's point_ids" do
              put :update, id: item, item: update_attrs
              item.reload.point_ids.must_equal [bullet1.id, bullet2.id]
            end

            it "does not update invalid bullet ids" do
              update_attrs[:bullet_ids] << 1234
              put :update, id: item, item: update_attrs
              item.reload.point_ids.wont_include 1234
            end

            it 'does not insert duplicate bullets' do
              update_attrs[:bullet_ids] << bullet1.id
              put :update, id: item, item: update_attrs
              item.reload.point_ids.must_equal [bullet1.id, bullet2.id]
            end

            it "removes all bullets if bullet_ids key is nil or empty" do
              item.points << bullet1 << bullet2
              update_attrs[:bullet_ids] = nil
              put :update, id: item, item: update_attrs
              item.reload.points.must_be_empty
            end

            describe 'when the item already has bullet(s)' do

              before do
                item.points << bullet1
                update_attrs[:bullet_ids].delete_at(0)
              end

              it 'bullets not given in bullet_ids are removed from the item' do
                put :update, id: item, item: update_attrs
                item.reload.point_ids.wont_include bullet1.id
              end
            end
          end

          describe "updating the Item's Paragraphs" do

            let(:paragraph1) { FactoryGirl.create(:paragraph) }
            let(:paragraph2) { FactoryGirl.create(:paragraph) }
            let(:update_attrs) {{
              paragraph_ids: [paragraph1.id, paragraph2.id],
              name: 'New name',
              title: 'New title',
              heading: 'New heading'
            }}

            it "updates the Item's point_ids" do
              put :update, id: item, item: update_attrs
              item.reload.point_ids.must_equal [paragraph1.id, paragraph2.id]
            end

            it "does not update invalid paragraph ids" do
              update_attrs[:paragraph_ids] << 1234
              put :update, id: item, item: update_attrs
              item.reload.point_ids.wont_include 1234
            end

            it 'does not insert duplicate paragraphs' do
              update_attrs[:paragraph_ids] << paragraph1.id
              put :update, id: item, item: update_attrs
              item.reload.point_ids.must_equal [paragraph1.id, paragraph2.id]
            end

            it "removes all paragraphs if paragraph_ids key is nil or empty" do
              item.points << paragraph1 << paragraph2
              update_attrs[:paragraph_ids] = nil
              put :update, id: item, item: update_attrs
              item.reload.points.must_be_empty
            end

            describe 'when the item already has paragraph(s)' do

              before do
                item.points << paragraph1
                update_attrs[:paragraph_ids].delete_at(0)
              end

              it 'paragraphs not given in paragraph_ids are removed from the item' do
                put :update, id: item, item: update_attrs
                item.reload.point_ids.wont_include paragraph1.id
              end
            end
          end
        end

        describe "given an invalid item id" do

          it "responds with 404 Not Found" do
            put :update, id: 'nope', item: update_attrs
            response.status.must_equal 404
          end
        end

        describe "given invalid attibutes" do
          before do update_attrs[:name] = '' end

          it "responds with 400 Bad Request" do
            put :update, id: item, item: update_attrs
            response.status.must_equal 422
          end

          it "returns a hash with the error message" do
            put :update, id: item, item: update_attrs
            response.body.must_equal({name: ["can't be blank"]}.to_json)
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          put :update, id: item, item: update_attrs
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
              delete :destroy, id: @item
            end
          end

          it "responds with 204 No Content" do
            delete :destroy, id: @item
            response.status.must_equal 204
            response.body.must_equal ''
          end
        end

        describe "given an invalid Item id" do

          it "responds with 404 Not Found" do
            delete :destroy, id: 'wrong'
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          delete :destroy, id: @item
          response.status.must_equal 401
        end
      end
    end
  end
end
