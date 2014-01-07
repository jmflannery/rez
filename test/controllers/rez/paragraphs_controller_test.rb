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

    describe "GET index" do

      let(:p) { FactoryGirl.create(:paragraph) }
      let(:p2) { FactoryGirl.create(:paragraph) }

      before do
        @paragraphs = [p, p2]
      end

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 200 OK" do
          get :index, use_route: 'rez'
          response.status.must_equal 200
        end

        it "returns all the Paragraphs in JSON format" do
          get :index, use_route: 'rez'
          serializer = ActiveModel::ArraySerializer.new(@paragraphs, each_serializer: ParagraphSerializer)
          response.body.must_equal({ paragraphs: serializer }.to_json)
        end
      end

      describe "without a valid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          get :index, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end

    describe "GET show" do

      let(:paragraph) { FactoryGirl.create(:paragraph) }

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "given a valid Paragraph id" do

          it "responds with 200 OK" do
            get :show, id: paragraph, use_route: 'rez'
            response.status.must_equal 200
          end

          it "responds with the requested Paragraph in JSON format" do
            get :show, id: paragraph, use_route: 'rez'
            response.body.must_equal(ParagraphSerializer.new(paragraph).to_json)
          end
        end

        describe "given an invalid Paragraph id" do

          it "responds with 404 Not Found" do
            get :show, id: 'wrong', use_route: 'rez'
            response.status.must_equal 404
          end
        end
      end

      describe "without a valid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          get :show, id: paragraph, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end
  end
end
