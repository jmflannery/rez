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
      serialized.must_equal %Q({"resume":{"id":#{resume.id},"name":"My Resume","profile":{"id":#{profile.id},"firstname":"#{profile.firstname}","middlename":"#{profile.middlename}","lastname":"#{profile.lastname}","nickname":"#{profile.nickname}","prefix":"#{profile.prefix}","suffix":"#{profile.suffix}","title":"#{profile.title}"},"address":{"id":#{address.id},"building_number":"#{address.building_number}","street_name":"#{address.street_name}","secondary_address":"#{address.secondary_address}","city":"#{address.city}","state":"#{address.state}","zip_code":"#{address.zip_code}","county":"#{address.county}","country":"#{address.country}","area_code":"#{address.area_code}","phone_number":"#{address.phone_number}"},"items":[{"id":#{item1.id},"name":"#{item1.name}","title":"#{item1.title}","heading":"#{item1.heading}","bullet_ids":[],"paragraph_ids":[]},{"id":#{item2.id},"name":"#{item2.name}","title":"#{item2.title}","heading":"#{item2.heading}","bullet_ids":[],"paragraph_ids":[]}]}})
    end
  end
end
