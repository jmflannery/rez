require 'test_helper'

module Rez
  describe Item do

    let(:attrs) {{
      name: 'arinc',
      title: 'Arinc Inc, June 2008 to Feb 2012',
      heading: 'Software Developer',
      rank: 4,
      visible: true
    }}

    let(:subject) { Item.new(attrs) }

    it 'creates an Item given valid attributes' do
      subject.must_be :valid?
    end

    it 'has a valid Factory' do
      FactoryGirl.build(:item).must_be :valid?
    end

    it 'is invalid without a name' do
      subject.name = ''
      subject.wont_be :valid?
    end

    it 'has many Paragraphs' do
      p = FactoryGirl.create(:paragraph, item: subject)
      p2 = FactoryGirl.create(:paragraph, item: subject)
      b = FactoryGirl.create(:bullet, item: subject)
      subject.paragraphs.must_equal [p, p2]
    end

    it 'has many Bullets' do
      b = FactoryGirl.create(:bullet, item: subject)
      b2 = FactoryGirl.create(:bullet, item: subject)
      p = FactoryGirl.create(:paragraph, item: subject)
      subject.bullets.must_equal [b, b2]
    end

    it 'can sort by rank' do
      subject.save
      last = FactoryGirl.create(:item, rank: 9)
      first = FactoryGirl.create(:item, rank: 1)
      Item.ranked.to_a.must_equal [first, subject, last]
    end

    it 'can retrieve only visible items' do
      subject.save
      hidden = FactoryGirl.create(:item, visible: false)
      Item.visible.must_include subject
      Item.visible.wont_include hidden
    end
  end
end
