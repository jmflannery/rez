module Rez
  class ItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :title, :heading

    has_many :bullets, :paragraphs
  end
end
