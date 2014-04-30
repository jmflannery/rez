module Rez
  class ResumeSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_one :profile
    has_one :address
    has_many :items
  end
end
