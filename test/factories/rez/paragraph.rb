require 'faker'

module Rez
  FactoryGirl.define do
    factory(:paragraph, class: Point) do |paragraph|
      paragraph.text { Faker::Lorem.sentences(word_count = 4).join(' ') }
      paragraph.rank { Faker::Number.digit }
      paragraph.point_type 'paragraph'
    end

    factory(:bullet, class: Point) do |bullet|
      bullet.text { Faker::Lorem.sentence(word_count = 5) }
      bullet.rank { Faker::Number.digit }
      bullet.point_type 'bullet'
    end
  end
end
