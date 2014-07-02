require 'test_helper'

module Rez

  describe SectionSerializer do

    let(:section) { FactoryGirl.create(:section) }

    it 'serializes a Section to JSON' do
      serialized = SectionSerializer.new(section).to_json
      serialized.must_equal %Q({"section":{"id":#{section.id},"name":"#{section.name}","heading":"#{section.heading}","subheading":"#{section.subheading}"}})
    end
  end
end

