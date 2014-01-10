require 'test_helper'

module Rez

  describe PointSerializer do

    let(:item) { FactoryGirl.create(:item) }

    before do
      @paragraph = FactoryGirl.create(:paragraph, item: item)
      @bullet = FactoryGirl.create(:bullet, item: item)
    end

    it 'serializes an Item to JSON' do
      serialized = ItemSerializer.new(item).to_json
      serialized.must_equal %Q({"item":{"id":#{item.id},"name":"#{item.name}","title":"#{item.title}","heading":"#{item.heading}","rank":#{item.rank},"visible":#{item.visible},"paragraph_ids":[#{@paragraph.id}],"bullet_ids":[#{@bullet.id}]}})
    end
  end
end
