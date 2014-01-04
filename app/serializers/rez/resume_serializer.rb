module Rez
  class ResumeSerializer < ActiveModel::Serializer
    attributes :id, :name, :profile_id, :address_id
  end
end
