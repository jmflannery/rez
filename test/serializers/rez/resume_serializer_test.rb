require 'test_helper'

module Rez

  describe ResumeSerializer do
    
    let(:profile) { FactoryGirl.create(:profile) }
    let(:resume) { FactoryGirl.create(:resume, name: 'My Resume', profile: profile) }

    it 'serializes the Resume to JSON' do
      serialized = ResumeSerializer.new(resume).to_json
      serialized.must_equal %Q({"resume":{"id":#{resume.id},"name":"My Resume","profile_id":#{profile.id},"address_id":null}})
    end
  end
end
