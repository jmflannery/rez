require 'test_helper'

module Rez
  describe Item do

    let(:attrs) {{
      title: 'Arinc Inc, June 2008 to Feb 2012',
      heading: 'Software Developer'
    }}

    let(:subject) { Item.new(attrs) }

    it 'creates an Item given valid attributes' do
      subject.must_be :valid?
    end

    it 'has a valid Factory' do
      FactoryGirl.build(:item).must_be :valid?
    end

    it 'has many Paragraphs' do
      p = FactoryGirl.create(:paragraph, item: subject)
      p2 = FactoryGirl.create(:paragraph, item: subject)
      subject.paragraphs.must_equal [p, p2]
    end
  end
end
