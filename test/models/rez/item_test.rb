require 'test_helper'

module Rez
  describe Item do

    let(:attrs) {{
      name: 'arinc',
      title: 'Arinc Inc, June 2008 to Feb 2012',
      heading: 'Software Developer'
    }}

    let(:subject) { Item.new(attrs) }

    it 'has a valid Factory' do
      FactoryGirl.build(:item).must_be :valid?
    end

    it "initialy has no points" do
      subject.points.must_be_empty
    end

    describe 'Points' do

      let(:bullet) { FactoryGirl.create(:bullet) }
      let(:bullet2) { FactoryGirl.create(:bullet) }
      let(:paragraph) { FactoryGirl.create(:paragraph) }
      let(:paragraph2) { FactoryGirl.create(:paragraph) }

      before do
        subject.add_point(bullet)
        subject.add_point(bullet2)
        subject.add_point(paragraph)
        subject.add_point(paragraph2)
      end

      it "adds Bullet and Paragraph type Points to itself" do
        subject.points.must_equal [bullet, bullet2, paragraph, paragraph2]
      end

      it "has a list of points that are type bullet" do
        subject.bullets.must_equal [bullet, bullet2]
      end

      it "has a list of points that are type paragraph" do
        subject.paragraphs.must_equal [paragraph, paragraph2]
      end

      it "can replace it's Points with a new set of Points" do
        subject.points = [bullet, paragraph]
        subject.points.must_equal [bullet, paragraph]
      end
    end
  end
end
