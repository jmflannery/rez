require 'test_helper'

module Rez
  describe Address do

    it "has a valid factory" do
      FactoryGirl.build(:address).must_be :valid?
    end

    it "is invalid without a building_number" do
      FactoryGirl.build(:address, building_number: nil).wont_be :valid?
    end

    it "is invalid without a street_name" do
      FactoryGirl.build(:address, street_name: nil).wont_be :valid?
    end

    it "is invalid without a city" do
      FactoryGirl.build(:address, city: nil).wont_be :valid?
    end

    it "is invalid without a state" do
      FactoryGirl.build(:address, state: nil).wont_be :valid?
    end

    it "is invalid without a zip_code" do
      FactoryGirl.build(:address, zip_code: nil).wont_be :valid?
    end
  end
end
