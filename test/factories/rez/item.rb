require 'faker'

module Rez
  FactoryGirl.define do
    factory(:item, class: Item) do |item|
      item.name { Faker::Lorem.word }
      item.title { Faker::Lorem.sentence(3) }
      item.heading { Faker::Lorem.sentence(4) }
    end
  end
end
