module Rez
  class SectionSerializer < ActiveModel::Serializer
    attributes :id, :name, :heading, :subheading

    has_many :items
  end
end

