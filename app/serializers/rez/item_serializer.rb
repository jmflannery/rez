module Rez
  class ItemSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name, :title, :heading, :rank, :visible
    has_many :paragraphs
    has_many :bullets
  end
end
