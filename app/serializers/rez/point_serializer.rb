module Rez
  class PointSerializer < ActiveModel::Serializer
    attributes :id, :text, :rank, :item_id
  end
end
