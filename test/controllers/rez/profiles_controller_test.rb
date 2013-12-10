require 'test_helper'

module Rez

  describe ProfilesController do

    describe "POST create" do

      let(:profile_attrs) { FactoryGirl.attributes_for(:profile) }

      it "returns HTTP created 201" do
        post :create, profile: profile_attrs, use_route: 'rez'
        response.status.must_equal 201
      end
    
      it "creates a Profile" do
        assert_difference('Profile.count') do
          post :create, profile: profile_attrs, use_route: 'rez'
        end
      end

      it "returns the Profile as json" do
        post :create, profile: profile_attrs, use_route: 'rez'
        response.body.must_equal(ProfileSerializer.new(assigns(:profile)).to_json)
      end
    end
  end
end
