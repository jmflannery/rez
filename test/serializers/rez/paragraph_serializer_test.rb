require 'test_helper'

module Rez

  describe ParagraphSerializer do

    let(:item) { FactoryGirl.create(:item) }
    let(:paragraph) { FactoryGirl.create(:paragraph, item: item) }

    it 'serializes the Paragraph to JSON' do
      serialized = ParagraphSerializer.new(paragraph).to_json
      serialized.must_equal %Q({"paragraph":{"id":#{paragraph.id},"text":"#{paragraph.text}","rank":#{paragraph.rank},"item_id":#{item.id}}})
    end
  end
end
