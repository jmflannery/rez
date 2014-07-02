require 'test_helper'

module Rez
  describe Section do

    let(:attrs) {{
      name: 'objective',
      heading: 'Objective',
      subheading: ''
    }}

    let(:subject) { Section.new(attrs) }

    it 'must be valid' do
      subject.must_be :valid?
    end

    it 'has a valid Factory' do
      FactoryGirl.build(:section).must_be :valid?
    end

    describe 'Items' do

      let(:item) { FactoryGirl.create(:item) }
      let(:item2) { FactoryGirl.create(:item) }

      it 'initialy has no items' do
        subject.items.must_be_empty
      end

      it 'can add items to its Item list' do
        subject.add_item(item)
        subject.add_item(item2)
        subject.items.must_equal [item, item2]
      end
    end
  end
end
