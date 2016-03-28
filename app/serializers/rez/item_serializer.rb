module Rez
  class ItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :title, :heading

    has_many :subitems, :points
  end
end
