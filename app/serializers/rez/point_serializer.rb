module Rez
  class PointSerializer < ActiveModel::Serializer
    attributes :id, :text, :rank, :point_type
  end
end
