FactoryGirl.define do
  factory :token, class: Toke::Token do |token|
    key Faker::Number.number(32)
  end
end
