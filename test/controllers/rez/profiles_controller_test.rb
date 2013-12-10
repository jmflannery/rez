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

    describe "GET show" do

      let(:profile) { FactoryGirl.create(:profile) }

      it "gets the requested profile as JSON" do
        get :show, id: profile, use_route: 'rez'
        response.body.must_equal(ProfileSerializer.new(profile).to_json)
      end
    end

    describe "GET index" do

      let(:p1) { FactoryGirl.create(:profile) }
      let(:p2) { FactoryGirl.create(:profile) }

      before do
        @profiles = [p1, p2]
      end

      it "gets all the profiles in JSON format" do
        get :index, use_route: 'rez'
        serializer = ActiveModel::ArraySerializer.new(@profiles, each_serializer: ProfileSerializer)
        response.body.must_equal({ profiles: serializer }.to_json)
      end
    end

    describe 'PUT update' do

      let(:profile) {
        FactoryGirl.create(:profile,
          firstname: 'William',
          middlename: 'Jefferson',
          lastname: 'Stump',
          nickname: 'Billy',
          prefix: 'Sir',
          suffix: 'Esq',
          title: 'Train Master, Extraordinaire'
      )}
      let(:update_attrs) {{ firstname: 'Bill', middlename: '', title: 'Sr Train Master' }}

      it "updates the profile record" do
        put :update, id: profile, profile: update_attrs, use_route: 'rez'
        profile.reload.firstname.must_equal('Bill')
        profile.middlename.must_equal('')
        profile.title.must_equal('Sr Train Master')
        profile.prefix.must_equal('Sir')
      end

      it "returns the updated profile in JSON format" do
        put :update, id: profile, profile: update_attrs, use_route: 'rez'
        response.body.must_equal(ProfileSerializer.new(profile.reload).to_json)
      end
    end
  end
end
