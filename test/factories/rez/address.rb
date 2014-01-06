require 'faker'

Faker::Config.locale = 'en-us'

module Rez
  FactoryGirl.define do
    factory(:address, class: Address) do |address|
      address.building_number { Faker::Address.building_number }
      address.street_name { Faker::Address.street_name }
      address.secondary_address { Faker::Address.secondary_address }
      address.city { Faker::Address.city }
      address.state { Faker::Address.state_abbr }
      address.zip_code { Faker::Address.zip_code }
      address.county { Faker::Address.city }
      address.country { Faker::Address.country }
      address.area_code { Faker::Number.number(3).to_s[1..3] }
      address.phone_number { Faker::Number.number(7).to_s[1..7] }
    end
  end
end
