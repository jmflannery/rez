require 'test_helper'

module Rez
  describe SectionsController do

    describe 'POST create' do

      let(:section_attrs) { FactoryGirl.attributes_for(:section) }

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 201 Created" do
          post :create, section: section_attrs, use_route: 'rez'
          response.status.must_equal 201
        end

        it "creates a new Section" do
          assert_difference('Section.count', 1) do
            post :create, section: section_attrs, use_route: 'rez'
          end
        end

        it "sets the new Section fields" do
          post :create, section: section_attrs, use_route: 'rez'
          json_resp = json(response, 'section')
          json_resp[:name].must_equal section_attrs[:name]
          json_resp[:heading].must_equal section_attrs[:heading]
          json_resp[:subheading].must_equal section_attrs[:subheading]
        end

        describe 'without a name given' do

          before do section_attrs[:name] = '' end

          it 'responds with 400 Bad Request' do
            post :create, section: section_attrs, use_route: 'rez'
            response.status.must_equal 400
          end

          it "returns a hash with the error message" do
            post :create, section: section_attrs, use_route: 'rez'
            response.body.must_equal({name: ["can't be blank"]}.to_json)
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create, section: section_attrs, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end
  end
end
