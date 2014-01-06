require 'test_helper'

module Rez

  describe AddressSerializer do

    let(:attrs) {{
      id: 22,
      building_number: '14013',
      street_name: 'Captains Rd',
      secondary_address: 'Apt 314',
      city: 'Los Angeles',
      state: 'CA',
      zip_code: '90212',
      county: 'Los Angeles',
      country: 'USA',
      area_code: '310',
      phone_number: '4397455'
    }}

    it "serialized an Address to JSON" do
      serializer = AddressSerializer.new(Address.new(attrs))
      serializer.to_json.must_equal '{"address":{"id":22,"building_number":"14013","street_name":"Captains Rd","secondary_address":"Apt 314","city":"Los Angeles","state":"CA","zip_code":"90212","county":"Los Angeles","country":"USA","area_code":"310","phone_number":"4397455"}}'
    end
  end
end
