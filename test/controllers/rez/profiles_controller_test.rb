require 'test_helper'

module Rez

  describe ProfilesController do
    setup do
      @routes = Engine.routes
    end

    describe "POST create" do

      let(:profile_attrs) { FactoryGirl.attributes_for(:profile) }

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "returns HTTP created 201" do
          post :create, profile: profile_attrs
          response.status.must_equal 201
        end

        it "creates a Profile" do
          assert_difference('Profile.count', 1) do
            post :create, profile: profile_attrs
          end
        end

        it "returns the Profile as json" do
          post :create, profile: profile_attrs
          response.body.must_equal(ProfileSerializer.new(assigns(:profile)).to_json)
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create, profile: profile_attrs
          response.status.must_equal 401
        end
      end
    end

    describe "GET show" do

      describe 'given a valid profile_id' do 

        before do
          @profile = FactoryGirl.create(:profile)
        end

        it "gets the requested profile as JSON" do
          get :show, id: @profile
          response.body.must_equal(ProfileSerializer.new(@profile).to_json)
        end
      end

      describe "given an invalid profile id" do

        it "responds with 404 Not Found" do
          get :show, id: -1
          response.status.must_equal 404
        end
      end

      describe "given a valid resume_id" do

        let(:profile) { FactoryGirl.create(:profile) }

        before do
          @resume = FactoryGirl.create(:resume, profile: profile)
        end

        it "returns the profile for the given resume in JSON format" do
          get :show, resume_id: @resume
          response.body.must_equal(ProfileSerializer.new(profile).to_json)
        end
      end

      describe 'given a resume that has no profile' do

        before do
          @resume = FactoryGirl.create(:resume)
        end

        it "responds with 404 Not Found" do
          get :show, resume_id: @resume
          response.status.must_equal 404
        end
      end

      describe "given an invalid resume_id" do

        it "responds with 404 Not Found" do
          get :show, resume_id: -1
          response.status.must_equal 404
        end
      end
    end

    describe "GET index" do

      let(:profile1) { FactoryGirl.create(:profile) }
      let(:profile2) { FactoryGirl.create(:profile) }

      before do @profiles = [profile1, profile2] end

      it "responds with 200 OK" do
        get :index
        response.status.must_equal 200
      end

      it "gets all the profiles in JSON format" do
        get :index
        serializer = ActiveModel::ArraySerializer.new(@profiles, each_serializer: ProfileSerializer)
        response.body.must_equal({ profiles: serializer }.to_json)
      end
    end

    describe 'PUT update' do

      let(:profile) { FactoryGirl.create(:profile) }
      let(:update_attrs) {{ firstname: 'Bill', title: 'Sr Train Master' }}

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 200 OK" do
          put :update, id: profile, profile: update_attrs
          response.status.must_equal 200
        end

        it "updates the profile record" do
          put :update, id: profile, profile: update_attrs
          profile.reload.firstname.must_equal('Bill')
          profile.title.must_equal('Sr Train Master')
        end

        it "returns the updated profile in JSON format" do
          put :update, id: profile, profile: update_attrs
          response.body.must_equal(ProfileSerializer.new(profile.reload).to_json)
        end

        describe "given an invalid profile id" do

          it "responds with 404 Not Found" do
            put :update, id: 'invalid', profile: update_attrs
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          put :update, id: profile, profile: update_attrs
          response.status.must_equal 401
        end
      end
    end

    describe "DELETE destroy" do

      before do @profile = FactoryGirl.create(:profile) end
      
      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "destroys the profile" do
          assert_difference('Profile.count', -1) do
            delete :destroy, id: @profile
          end
        end 

        it "returns 204 with empty body" do
          delete :destroy, id: @profile
          response.status.must_equal 204
          response.body.must_equal ''
        end

        describe "given an invalid profile id" do

          it "responds with 404 Not Found" do
            delete :destroy, id: 'invalid'
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          delete :destroy, id: @profile
          response.status.must_equal 401
        end
      end
    end
  end
end
