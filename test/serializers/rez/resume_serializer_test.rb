require 'test_helper'

module Rez

  describe ResumeSerializer do
    
    let(:profile) { FactoryGirl.create(:profile) }
    let(:address) { FactoryGirl.create(:address) }
    let(:item1) { FactoryGirl.create(:item) }
    let(:item2) { FactoryGirl.create(:item) }
    let(:resume) {
      FactoryGirl.create(:resume,
        name: 'My Resume',
        profile: profile,
        address: address,
        item_ids: [item1.id,item2.id])
    }

    it 'serializes the Resume to JSON' do
      serialized = ResumeSerializer.new(resume).to_json
      serialized.must_equal %Q({"resume":{"id":#{resume.id},"name":"My Resume","profile_id":#{profile.id},"address_id":#{address.id},"item_ids":[#{item1.id},#{item2.id}]}})
    end
  end
end
