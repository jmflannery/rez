require 'test_helper'

module Rez
  describe Item do

    let(:attrs) {{
      name: 'arinc',
      title: 'Arinc Inc, June 2008 to Feb 2012',
      heading: 'Software Developer'
    }}

    let(:subject) { Item.new(attrs) }

    it 'should be valid with valid attrs' do
      subject.must_be :valid?
    end

    it 'has a valid Factory' do
      FactoryGirl.build(:item).must_be :valid?
    end

    describe 'has many Subitems' do

      let(:subitem1) { FactoryGirl.create(:item) }
      let(:subitem2) { FactoryGirl.create(:item) }

      it 'initially has no Subitems' do
        subject.subitems.must_be_empty
      end

      it 'can have many Subitems' do
        subject.subitems << subitem1
        subject.subitems << subitem2
        subject.subitem_ids.to_a.must_include subitem1.id
        subject.subitem_ids.to_a.must_include subitem2.id
      end

      it 'can have subitems of subitems' do
        subject.subitems << subitem1
        subitem1.subitems << subitem2
        subject.subitem_ids.must_include subitem1.id
        subitem1.subitem_ids.must_include subitem2.id
        subject.subitem_ids.wont_include subitem2.id
        subitem2.subitem_ids.wont_include subitem1.id
      end

      it 'can be both an item and a subitem' do
        subitem1.subitems << subitem2
        subitem2.subitems << subitem1
        subitem1.subitem_ids.must_include subitem2.id
        subitem2.subitem_ids.must_include subitem1.id
      end
    end

    describe 'has many Points' do

      let(:bullet) { FactoryGirl.create(:bullet) }
      let(:paragraph) { FactoryGirl.create(:paragraph) }

      it 'initially has no Points' do
        subject.points.must_be_empty
      end

      it 'can have many points' do
        subject.points << bullet
        subject.points << paragraph
        subject.points.must_include bullet
        subject.points.must_include paragraph
      end
    end
  end
end
