require 'faker'

module Rez
  FactoryGirl.define do
    factory(:item, class: Item) do |item|
      item.name { Faker::Lorem.word }
      item.title { Faker::Lorem.sentence(word_count = 3) }
      item.heading { Faker::Lorem.sentence(word_count = 4) }
    end
  end
end
