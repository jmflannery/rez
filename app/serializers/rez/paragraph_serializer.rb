module Rez
  class ParagraphSerializer < ActiveModel::Serializer
    attributes :id, :text, :rank, :item_id
  end
end
