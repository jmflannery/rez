module Rez
  FactoryGirl.define do
    factory(:profile, class: Profile) do |profile|
      profile.firstname 'Randy'
      profile.middlename 'Mario'
      profile.lastname 'Savage'
      profile.nickname 'Macho Man'
      profile.prefix 'Sir'
      profile.suffix 'II'
      profile.title 'Real Wrestler'
    end
  end
end
