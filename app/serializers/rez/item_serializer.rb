module Rez
  class ItemSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name, :title, :heading, :bullet_ids
    has_many :paragraphs
  end
end
