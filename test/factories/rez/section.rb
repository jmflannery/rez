require 'faker'

module Rez
  FactoryGirl.define do
    factory(:section, class: Section) do |item|
      item.name { Faker::Lorem.word }
      item.heading { Faker::Lorem.sentence(3) }
      item.subheading { Faker::Lorem.sentence(4) }
    end
  end
end

