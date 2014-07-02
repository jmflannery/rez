require 'faker'

module Rez
  FactoryGirl.define do
    factory(:section, class: Section) do |item|
      item.name { Faker::Lorem.word }
      item.heading { Faker::Lorem.sentence(word_count = 3) }
      item.subheading { Faker::Lorem.sentence(word_count = 4) }
    end
  end
end

