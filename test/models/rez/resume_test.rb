require 'test_helper'

module Rez
  describe Resume do

    let(:attrs) {{ name: 'My Resume' }}
    let(:subject) { Resume.new(attrs) }

    it 'is valid with valid attributes' do
      subject.must_be :valid?
    end

    it "has a valid factory" do
      FactoryGirl.build(:resume).must_be :valid?
    end

    it "has belongs to a user" do
      user = FactoryGirl.build_stubbed(:user)
      subject.user = user
      subject.user.id.must_equal user.id
    end

    describe 'Sections assoctiation' do

      let(:section1) { FactoryGirl.create(:section) }
      let(:section2) { FactoryGirl.create(:section) }

      it 'initially has no Sections' do
        subject.sections.must_be_empty
      end

      it 'can add Sections to itself' do
        subject.add_section(section1)
        subject.add_section(section2)
        subject.sections.must_equal [section1, section2]
      end

      it "can replace it's Sections with a new set of Sections" do
        subject.add_section(FactoryGirl.create(:section))
        subject.sections = [section1, section2]
        subject.sections.must_equal [section1, section2]
      end
    end
  end
end

