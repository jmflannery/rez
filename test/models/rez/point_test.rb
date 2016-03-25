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

    it 'can be a valid Paragraph' do
      paragraph.must_be :valid?
    end

    it 'can be a valid Bullet' do
      bullet.must_be :valid?
    end

    it 'has valid factories for paragraph and bullet types' do
      FactoryGirl.build(:paragraph).must_be :valid?
      FactoryGirl.build(:bullet).must_be :valid?
    end
  end
end
