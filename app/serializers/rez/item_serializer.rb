module Rez
  class ItemSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :title, :heading
    has_many :paragraphs
    has_many :bullets
  end
end
