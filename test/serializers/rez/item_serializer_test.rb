require 'test_helper'

module Rez

  describe PointSerializer do

    let(:item) { FactoryGirl.create(:item) }
    let(:bullet) { FactoryGirl.create(:bullet) }
    let(:paragraph) { FactoryGirl.create(:paragraph) }

    before do
      item.points << bullet
      item.points << paragraph
    end

    it 'serializes an Item to JSON' do
      serialized = ItemSerializer.new(item).to_json
      serialized.must_equal %Q({"item":{"id":#{item.id},"name":"#{item.name}","title":"#{item.title}","heading":"#{item.heading}","points":[{"id":#{bullet.id},"text":"#{bullet.text}","rank":#{bullet.rank},"point_type":"bullet"},{"id":#{paragraph.id},"text":"#{paragraph.text}","rank":#{paragraph.rank},"point_type":"paragraph"}]}})
    end
  end
end
