require 'test_helper'

module Rez
  describe Paragraph do

    let(:attrs) {{
      text: 'This is a paragraph. It has 2 sentences.',
      rank: 2
    }}

    let(:subject) { Paragraph.new(attrs) }

    it 'creates a Paragraph given valid attributes' do
      subject.must_be :valid?
    end

    it 'has a valid factory' do
      FactoryGirl.build(:paragraph).must_be :valid?
    end

    it 'belongs to Item' do
      item = FactoryGirl.create(:item)
      subject.update(item_id: item.id)
      subject.item.must_equal item
    end
  end
end
