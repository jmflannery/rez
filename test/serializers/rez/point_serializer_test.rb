require 'test_helper'

module Rez

  describe PointSerializer do

    let(:point) { FactoryGirl.create(:paragraph) }

    it 'serializes the Point to JSON' do
      serialized = PointSerializer.new(point).to_json
      serialized.must_equal %Q({"point":{"id":#{point.id},"text":"#{point.text}","rank":#{point.rank},"point_type":"paragraph"}})
    end
  end
end
