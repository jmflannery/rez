require 'test_helper'

module Rez

  describe SectionSerializer do

    let(:section) { FactoryGirl.create(:section) }
    let(:item) { FactoryGirl.create(:item) }

    before do
      section.add_item(item)
    end

    it 'serializes a Section to JSON' do
      serialized = SectionSerializer.new(section).to_json
      serialized.must_equal %Q({"section":{"id":#{section.id},"name":"#{section.name}","heading":"#{section.heading}","subheading":"#{section.subheading}","items":[{"id":#{item.id},"name":"#{item.name}","title":"#{item.title}","heading":"#{item.heading}","bullets":[],"paragraphs":[]}]}})
    end
  end
end

