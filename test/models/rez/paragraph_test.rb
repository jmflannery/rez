require 'test_helper'

module Rez
  describe Paragraph do

    let(:paragraph_attrs) {{
      text: 'This is a paragraph. It has 2 sentences.',
      point_type: 'paragraph',
      rank: 2
    }}

    let(:bullet_attrs) {{
      text: 'This is a paragraph.',
      point_type: 'bullet',
      rank: 3
    }}

    let(:paragraph) { Paragraph.new(paragraph_attrs) }
    let(:bullet) { Paragraph.new(bullet_attrs) }

    it 'creates a Paragraph type Point given valid attributes' do
      paragraph.must_be :valid?
    end

    it 'creates a Bullet type Point given valid attributes' do
      bullet.must_be :valid?
    end

    it 'has valid factories for paragraph and bullet types' do
      FactoryGirl.build(:paragraph).must_be :valid?
      FactoryGirl.build(:bullet).must_be :valid?
    end

    it 'is invalid with a type other than "paragraph" or "bullet"' do
      Paragraph.new(point_type: 'other', text: 'Other type').wont_be :valid?
    end

    it 'belongs to Item' do
      item = FactoryGirl.create(:item)
      bullet.update(item_id: item.id)
      bullet.item.must_equal item
    end
  end
end
