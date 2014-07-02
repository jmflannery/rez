require 'test_helper'

module Rez
  describe Section do

    let(:attrs) {{
      name: 'objective',
      heading: 'Objective',
      subheading: ''
    }}

    let(:subject) { Section.new(attrs) }

    it 'is valid with valid attributes' do
      subject.must_be :valid?
    end

    it 'is invalid without a name' do
      Section.new(attrs.merge(name: '')).wont_be :valid?
    end

    it 'has a valid Factory' do
      FactoryGirl.build(:section).must_be :valid?
    end

    describe 'Items association' do

      let(:item) { FactoryGirl.create(:item) }
      let(:item2) { FactoryGirl.create(:item) }

      it 'initialy has no items' do
        subject.items.must_be_empty
      end

      it 'can add Items to itself' do
        subject.add_item(item)
        subject.add_item(item2)
        subject.items.must_equal [item, item2]
      end
    end
  end
end
