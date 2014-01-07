require 'faker'

module Rez
  FactoryGirl.define do
    factory(:paragraph, class: Paragraph) do |paragraph|
      paragraph.text { Faker::Lorem.sentences(word_count = 4).join(' ') }
      paragraph.rank { Faker::Number.digit }
    end
  end
end
