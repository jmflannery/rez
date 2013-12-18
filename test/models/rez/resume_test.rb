require 'test_helper'

module Rez
  describe Resume do

    it "has a valid factory" do
      FactoryGirl.build(:resume).must_be :valid?
    end

    it "is invalid without a name" do
      FactoryGirl.build(:resume, name: nil).wont_be :valid?
    end
  end
end
