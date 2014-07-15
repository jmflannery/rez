require 'test_helper'

module Rez

  describe ResumeSerializer do

    let(:profile) { FactoryGirl.create(:profile) }
    let(:address) { FactoryGirl.create(:address) }
    let(:section1) { FactoryGirl.create(:section) }
    let(:section2) { FactoryGirl.create(:section) }
    let(:resume) {
      FactoryGirl.create(:resume,
        name: 'My Resume',
        profile: profile,
        address: address,
        section_ids: [section1.id,section2.id])
    }

    it 'serializes the Resume to JSON' do
      serialized = ResumeSerializer.new(resume).to_json
      serialized.must_equal %Q({"resume":{"id":#{resume.id},"name":"My Resume","profile":{"id":#{profile.id},"firstname":"#{profile.firstname}","middlename":"#{profile.middlename}","lastname":"#{profile.lastname}","nickname":"#{profile.nickname}","prefix":"#{profile.prefix}","suffix":"#{profile.suffix}","title":"#{profile.title}"},"address":{"id":#{address.id},"building_number":"#{address.building_number}","street_name":"#{address.street_name}","secondary_address":"#{address.secondary_address}","city":"#{address.city}","state":"#{address.state}","zip_code":"#{address.zip_code}","county":"#{address.county}","country":"#{address.country}","area_code":"#{address.area_code}","phone_number":"#{address.phone_number}"},"sections":[{"id":#{section1.id},"name":"#{section1.name}","heading":"#{section1.heading}","subheading":"#{section1.subheading}","items":[]},{"id":#{section2.id},"name":"#{section2.name}","heading":"#{section2.heading}","subheading":"#{section2.subheading}","items":[]}]}})
    end
  end
end
