module Rez
  class PointSerializer < ActiveModel::Serializer
    attributes :id, :text, :rank, :item_id, :point_type
  end
end
