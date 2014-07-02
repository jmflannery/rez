require 'test_helper'

module Rez
  describe Resume do

    let(:attrs) {{ name: 'My Resume' }}

    let(:subject) { Resume.new(attrs) }

    let(:item1) { FactoryGirl.create(:item) }
    let(:item2) { FactoryGirl.create(:item) }

    it "has a valid factory" do
      FactoryGirl.build(:resume).must_be :valid?
    end

    it "has an initially empty item_id array" do
      subject.item_ids.must_equal []
    end

    it "can add Items" do
      subject.add_item(item1)
      subject.add_item(item2)
      subject.item_ids.must_equal [item1.id, item2.id]
    end

    it "returns an Active Record Relation with all Items in the item_id array" do
      subject.add_item(item1)
      subject.add_item(item2)
      subject.items.must_equal [item1, item2]
    end

    describe 'Sections assoctiation' do

      let(:section1) { FactoryGirl.create(:section) }
      let(:section2) { FactoryGirl.create(:section) }

      it 'initially has no Sections' do
        subject.sections.must_be_empty
      end

      it 'can add Sections to itself' do
        subject.add_section(section1)
        subject.add_section(section2)
        subject.sections.must_equal [section1, section2]
      end
    end
  end
end

