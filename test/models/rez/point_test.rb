require 'test_helper'

module Rez
  describe Point do

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

    let(:paragraph) { Point.new(paragraph_attrs) }
    let(:bullet) { Point.new(bullet_attrs) }

    it 'creates a Point type Point given valid attributes' do
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
      Point.new(point_type: 'other', text: 'Other type').wont_be :valid?
    end

    it 'belongs to Item' do
      item = FactoryGirl.create(:item)
      bullet.update(item_id: item.id)
      bullet.item.must_equal item
    end

    describe 'scope' do

      before do
        bullet.save
        paragraph.save
      end

      describe 'paragraphs' do

        it 'returns all paragraph points' do
          Point.paragraphs.must_include paragraph
        end

        it 'does not return non paragraph points' do
          Point.paragraphs.wont_include bullet
        end
      end

      describe 'bullets' do

        it 'returns all bullet points' do
          Point.bullets.must_include bullet
        end

        it 'does not return non bullet points' do
          Point.bullets.wont_include paragraph
        end
      end
    end 
  end
end