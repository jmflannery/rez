require 'faker'

module Rez
  FactoryGirl.define do
    factory(:profile, class: Profile) do |profile|
      profile.firstname { Faker::Name.first_name }
      profile.middlename { Faker::Name.first_name }
      profile.lastname { Faker::Name.last_name }
      profile.nickname { Faker::Name.last_name }
      profile.prefix { Faker::Name.prefix }
      profile.suffix { Faker::Name.suffix }
      profile.title { Faker::Name.title }
    end
  end
end
