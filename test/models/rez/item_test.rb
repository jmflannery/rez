require 'test_helper'

module Rez
  describe Item do

    it 'has a valid Factory' do
      FactoryGirl.build(:item).must_be :valid?
    end
  end
end
