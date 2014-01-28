require 'test_helper'

module Rez
  describe Item do

    let(:attrs) {{
      name: 'arinc',
      title: 'Arinc Inc, June 2008 to Feb 2012',
      heading: 'Software Developer'
    }}

    let(:subject) { Item.new(attrs) }

    let(:bullet1) { FactoryGirl.create(:bullet) }
    let(:bullet2) { FactoryGirl.create(:bullet) }
    let(:paragraph1) { FactoryGirl.create(:paragraph) }
    let(:paragraph2) { FactoryGirl.create(:paragraph) }

    it 'has a valid Factory' do
      FactoryGirl.build(:item).must_be :valid?
    end

    it "has an initially empty bullet_ids array" do
      subject.bullet_ids.must_equal []
    end

    it "has an initially empty paragraph_ids array" do
      subject.paragraph_ids.must_equal []
    end

    it "returns an Active Record Relation with all Bullets in bullet_ids" do
      subject.bullet_ids << bullet1.id << bullet2.id
      subject.bullets.must_equal [bullet1, bullet2]
    end

    it "returns an Active Record Relation with all Paragraphs in paragraphs_ids" do
      subject.paragraph_ids << paragraph1.id << paragraph2.id
      subject.paragraphs.must_equal [paragraph1, paragraph2]
    end

    it "can add only 'bullet' type Points with add_bullet method" do
      subject.add_bullet(bullet1)
      subject.add_bullet(bullet2)
      subject.add_bullet(paragraph1)
      subject.add_bullet(nil)
      subject.bullets.must_equal [bullet1, bullet2]
      subject.bullet_ids.must_equal [bullet1.id, bullet2.id]
    end

    it "returns an Active Record Relation with all the Item's Points (Bullets and Paragraphs)" do
      subject.bullet_ids << bullet1.id << bullet2.id
      subject.points.must_equal [bullet1, bullet2]
    end
  end
end
