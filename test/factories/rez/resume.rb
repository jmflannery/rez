require 'faker'

module Rez
  FactoryGirl.define do
    factory(:resume, class: Resume) do |resume|
      sequence :name do |n| "Resume#{n}" end
    end
  end
end
