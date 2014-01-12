require 'test_helper'

module Rez
  describe Resume do

    let(:attrs) {{
      name: 'My Resume'
    }}

    let(:subject) { Resume.new(attrs) }

    it "creates a Resume given valid attributes" do
      subject.must_be :valid?
    end

    it "has a valid factory" do
      FactoryGirl.build(:resume).must_be :valid?
    end

    it "is invalid without a name" do
      subject.name = ''
      subject.wont_be :valid?
    end

    it "has an array of items ids" do
      i1 = FactoryGirl.create(:item)
      i2 = FactoryGirl.create(:item)
      subject.item_ids.concat [i1.id, i2.id]
      subject.item_ids.must_equal [i1.id, i2.id]
    end

    it "has an array of Items" do
      i1 = FactoryGirl.create(:item)
      i2 = FactoryGirl.create(:item)
      subject.item_ids.concat [i1.id, i2.id]
      subject.items.must_equal [i1, i2]
    end
  end
end
