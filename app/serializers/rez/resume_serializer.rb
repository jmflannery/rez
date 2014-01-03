module Rez
  class ResumeSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name
    has_one :profile
    has_one :address
  end
end
