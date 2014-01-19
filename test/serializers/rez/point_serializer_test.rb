require 'test_helper'

module Rez

  describe PointSerializer do

    let(:item) { FactoryGirl.create(:item) }
    let(:point) { FactoryGirl.create(:paragraph, item: item) }

    it 'serializes the Point to JSON' do
      serialized = PointSerializer.new(point).to_json
      serialized.must_equal %Q({"point":{"id":#{point.id},"text":"#{point.text}","rank":#{point.rank},"item_id":#{item.id},"point_type":"paragraph"}})
    end
  end
end
