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

    describe 'belongs to Profile' do
      let(:profile) { FactoryGirl.create(:profile) }

      it 'initially has no profile' do
        subject.profile.must_equal nil
      end

      it 'belongs to a profile' do
        subject.profile = profile
        subject.profile_id.must_equal profile.id
      end
    end

    describe 'belongs to Address' do
      let(:address) { FactoryGirl.create(:address) }

      it 'initially has no address' do
        subject.address.must_equal nil
      end

      it 'belongs to a address' do
        subject.address = address
        subject.address_id.must_equal address.id
      end
    end

    describe 'items' do

      let(:item1) { FactoryGirl.create(:item) }
      let(:item2) { FactoryGirl.create(:item) }

      it 'initially has no Items' do
        subject.items.must_be_empty
      end

      it 'can have many Items' do
        subject.items << item1
        subject.items << item2
        subject.items.must_include item1
        subject.items.must_include item2
      end
    end
  end
end
