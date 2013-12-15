FactoryGirl.define do
  factory :user, class: Toke::User do |user|
    username Faker::Internet.user_name
    password "secret"
    password_confirmation "secret"
  end
end
