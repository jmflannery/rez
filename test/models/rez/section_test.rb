require 'test_helper'

module Rez
  describe Section do

    let(:attrs) {{
      name: 'objective',
      heading: 'Objective',
      subheading: ''
    }}

    let(:subject) { Section.new(attrs) }

    it 'must be valid' do
      subject.must_be :valid?
    end

    it 'has a valid Factory' do
      FactoryGirl.build(:section).must_be :valid?
    end
  end
end
