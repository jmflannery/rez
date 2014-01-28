module Rez
  class ItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :title, :heading, :bullet_ids, :paragraph_ids
  end
end
