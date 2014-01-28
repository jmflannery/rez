require 'test_helper'

module Rez

  describe PointSerializer do

    let(:item) { FactoryGirl.create(:item) }
    let(:bullet) { FactoryGirl.create(:bullet) }
    let(:paragraph) { FactoryGirl.create(:paragraph) }

    before do
      item.add_bullet(bullet)
      item.paragraph_ids << paragraph.id
      item.paragraph_ids_will_change!
      item.save
    end

    it 'serializes an Item to JSON' do
      serialized = ItemSerializer.new(item).to_json
      serialized.must_equal %Q({"item":{"id":#{item.id},"name":"#{item.name}","title":"#{item.title}","heading":"#{item.heading}","bullet_ids":[#{bullet.id}],"paragraph_ids":[#{paragraph.id}]}})
    end
  end
end
