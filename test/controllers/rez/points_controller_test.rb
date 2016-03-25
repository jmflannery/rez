require 'test_helper'

module Rez
  describe PointsController do
    setup do
      @routes = Engine.routes
    end

    describe "POST create" do

      let(:attrs) { FactoryGirl.attributes_for(:paragraph) }

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 201 Created" do
          post :create, point: attrs
          response.status.must_equal 201
        end

        it "creates a Point" do
          assert_difference('Point.count', 1) do
            post :create, point: attrs
          end
        end

        it "responds with the created Point in JSON format" do
          post :create, point: attrs
          json = JSON.parse(response.body)
          json['point']['id'].to_s.must_match /\d+/
          json['point']['text'].must_equal attrs[:text]
        end

        describe 'given an item_id' do

          let(:item) { FactoryGirl.create(:item) }

          it "creates a Point with the specified type and adds it to the Item" do
            post :create, item_id: item.id, point: attrs
            json = JSON.parse(response.body)
            json['point']['point_type'].must_equal 'paragraph'
            json['point']['id'].to_s.must_match /\d+/
            item.reload.point_ids.must_include json['point']['id']
          end

          describe "given an invalid point_type" do

            let(:attrs) { FactoryGirl.attributes_for(:paragraph, point_type: 'nonexistant') }

            it "responds with 400 Bad Request and an error message" do
              post :create, point: attrs
              response.status.must_equal 400
              response.body.must_equal %q({"point_type":["'nonexistant' is not a valid point_type"]})
            end

            it "will not add the point to the item" do
              post :create, point: attrs
              item.point_ids.must_be :empty?
            end
          end
        end
      end

      describe "without a valid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create, point: attrs
          response.status.must_equal 401
        end
      end
    end

    describe "GET index" do

      let(:paragraph) { FactoryGirl.create(:paragraph) }
      # let(:paragraph2) { FactoryGirl.create(:paragraph) }
      let(:bullet) { FactoryGirl.create(:bullet) }
      # let(:bullet2) { FactoryGirl.create(:bullet) }

      before do
        @points = [paragraph, bullet]
      end

      it "responds with 200 OK" do
        get :index
        response.status.must_equal 200
      end

      it "returns all the Points in JSON format" do
        get :index
        serializer = ActiveModel::ArraySerializer.new(@points, each_serializer: PointSerializer)
        response.body.must_equal({ points: serializer }.to_json)
      end

      describe "when type=bullet is given" do

        before do
          @bullets = [bullet]
        end

        it "responds with all bullet type Points in JSON format" do
          get :index, type: 'bullet'
          serializer = ActiveModel::ArraySerializer.new(@bullets, each_serializer: PointSerializer)
          response.body.must_equal({ points: serializer }.to_json)
        end
      end

      describe "when type=paragraph is given" do

        before do
          @paragraphs = [paragraph]
        end

        it "responds with all paragraph type Points in JSON format" do
          get :index, type: 'paragraph'
          serializer = ActiveModel::ArraySerializer.new(@paragraphs, each_serializer: PointSerializer)
          response.body.must_equal({ points: serializer }.to_json)
        end
      end

      describe 'given an item_id' do

        let(:item) { FactoryGirl.create(:item) }
        let(:bullet2) { FactoryGirl.create(:bullet) }
        let(:paragraph2) { FactoryGirl.create(:paragraph) }

        before do
          @points = [paragraph, bullet, paragraph2, bullet2]
          item.points << bullet << bullet2 << paragraph << paragraph2
        end

        it "returns all the Item's Points in JSON format" do
          get :index, item_id: item.id
          serializer = ActiveModel::ArraySerializer.new(@points, each_serializer: PointSerializer)
          response.body.must_equal({ points: serializer }.to_json)
        end

        describe "when type=bullet is given" do

          it "returns all the Item's bullet type Points in JSON format" do
            get :index, item_id: item.id, type: 'bullet'
            serializer = ActiveModel::ArraySerializer.new([bullet, bullet2], each_serializer: PointSerializer)
            response.body.must_equal({ points: serializer }.to_json)
          end
        end

        describe "when type=paragraph is given" do

          it "returns all the Item's paragraphs type Points in JSON format" do
            get :index, item_id: item.id, type: 'paragraph'
            serializer = ActiveModel::ArraySerializer.new([paragraph, paragraph2], each_serializer: PointSerializer)
            response.body.must_equal({ points: serializer }.to_json)
          end
        end
      end
    end

    describe "GET show" do

      let(:point) { FactoryGirl.create(:paragraph) }

      describe "given a valid Point id" do

        it "responds with 200 OK" do
          get :show, id: point
          response.status.must_equal 200
        end

        it "responds with the requested Point in JSON format" do
          get :show, id: point
          response.body.must_equal(PointSerializer.new(point).to_json)
        end
      end

      describe "given an invalid Point id" do

        it "responds with 404 Not Found" do
          get :show, id: 'wrong'
          response.status.must_equal 404
        end
      end
    end

    describe "PUT update" do

      let(:point) { FactoryGirl.create(:paragraph, text: 'My paragraph', rank: 9) }
      let(:update_attrs) {{ text: 'My Awesome Point', rank: 1 }}

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "on successfull update" do

          it "responds with 200 OK" do
            put :update, id: point, point: update_attrs
            response.status.must_equal 200
          end

          it "updates the point record" do
            put :update, id: point, point: update_attrs
            point.reload.text.must_equal 'My Awesome Point'
            point.rank.must_equal 1
          end

          it "returns the updated point in JSON format" do
            put :update, id: point, point: update_attrs
            response.body.must_equal(PointSerializer.new(point.reload).to_json)
          end
        end

        describe "given an invalid point id" do

          it "responds with 404 Not Found" do
            put :update, id: 'nope', point: update_attrs
            response.status.must_equal 404
          end
        end

        describe "given an invalid point_type" do

          let(:attrs) {{ point_type: 'nonexistant' }}

          it "responds with 400 Bad Request" do
            put :update, id: point, point: attrs
            response.status.must_equal 400
          end

          it "responds with an error message" do
            put :update, id: point, point: attrs
            response.body.must_equal %q({"point_type":["'nonexistant' is not a valid point_type"]})
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          put :update, id: point, point: update_attrs
          response.status.must_equal 401
        end
      end
    end

    describe "DELETE destroy" do

      before do @point = FactoryGirl.create(:paragraph) end

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "given a valid Point id" do

          it "destroys the point" do
            assert_difference('Point.count', -1) do
              delete :destroy, id: @point
            end
          end

          it "responds with 204 No Content" do
            delete :destroy, id: @point
            response.status.must_equal 204
            response.body.must_equal ''
          end
        end

        describe "given an invalid Point id" do

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
          delete :destroy, id: @point
          response.status.must_equal 401
        end
      end
    end
  end
end
