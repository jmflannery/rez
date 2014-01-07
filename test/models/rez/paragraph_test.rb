require 'test_helper'

module Rez
  describe Paragraph do

    it 'has a valid factory' do
      FactoryGirl.build(:paragraph).must_be :valid?
    end
  end
end
