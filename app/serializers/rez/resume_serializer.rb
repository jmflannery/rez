module Rez
  class ResumeSerializer < ActiveModel::Serializer
    attributes :id
    has_one :profile
    has_one :address
  end
end
