require 'test_helper'

module Rez

  describe ProfileSerializer do

    let(:attrs) {{
      id: 22,
      firstname: 'Randy',
      middlename: 'Mario',
      lastname: 'Savage',
      nickname: 'Macho Man',
      prefix: 'Sir',
      suffix: 'II',
      title: 'Real Wrestler',
      email: 'macho@wwf.com'
    }}

    it "serializes a Profile as JSON" do
      serializer = ProfileSerializer.new(Profile.new(attrs))
      serializer.to_json.must_equal '{"profile":{"id":22,"firstname":"Randy","middlename":"Mario","lastname":"Savage","nickname":"Macho Man","prefix":"Sir","suffix":"II","title":"Real Wrestler","email":"macho@wwf.com"}}'
    end
  end
end
