require 'test_helper'

module Rez

  describe ProfilesController do

    describe "POST create" do

      let(:valid_attrs) {{
        firstname: 'Randy',
        middlename: 'Mario',
        lastname: 'Savage',
        nickname: 'Macho Man',
        prefix: 'Sir',
        suffix: 'II',
        title: 'Real Wrestler'
      }}

      it "returns HTTP created 201" do
        post :create, profile: valid_attrs, use_route: 'rez'
        response.status.must_equal 201
      end
    
      it "creates a Profile" do
        assert_difference('Profile.count') do
          post :create, profile: valid_attrs, use_route: 'rez'
        end
      end
    end
  end
end
