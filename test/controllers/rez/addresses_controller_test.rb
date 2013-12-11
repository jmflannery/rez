require 'test_helper'

module Rez
  describe AddressesController do

    describe "POST create" do

      let(:address_attrs) { FactoryGirl.attributes_for(:address) }

      it "returns HTTP created 201" do
        post :create, address: address_attrs, use_route: 'rez'
        response.status.must_equal 201
      end
    
      it "creates an address" do
        assert_difference('Address.count', 1) do
          post :create, address: address_attrs, use_route: 'rez'
        end
      end

      it "returns the address in json format" do
        post :create, address: address_attrs, use_route: 'rez'
        response.body.must_equal(AddressSerializer.new(assigns(:address)).to_json)
      end
    end

    describe "GET show" do

      let(:address) { FactoryGirl.create(:address) }

      it "gets the requested address as JSON" do
        get :show, id: address, use_route: 'rez'
        response.body.must_equal(AddressSerializer.new(address).to_json)
      end
    end

    describe "GET index" do

      let(:addr) { FactoryGirl.create(:address) }
      let(:addr2) { FactoryGirl.create(:address) }

      before do
        @addresses = [addr, addr2]
      end

      it "gets all the addresses in JSON format" do
        get :index, use_route: 'rez'
        serializer = ActiveModel::ArraySerializer.new(@addresses, each_serializer: AddressSerializer)
        response.body.must_equal({ addresses: serializer }.to_json)
      end
    end
  end
end
