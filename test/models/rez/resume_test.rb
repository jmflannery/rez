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

    it "can add item_ids to it's item_id array" do
      subject.item_ids << 3 << 22 << 101
      subject.item_ids.must_equal [3, 22, 101]
    end

    it "returns an array of all items in the item_id array" do
      subject.item_ids << item1.id << item2.id
      subject.items.must_equal [item1, item2]
    end

    it "can add item objects" do
      subject.add_item(item1)
      subject.add_item(item2)
      subject.items.must_equal [item1, item2]
      subject.item_ids.must_equal [item1.id, item2.id]
    end
  end
end
