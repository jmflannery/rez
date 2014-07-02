module Rez
  class SectionSerializer < ActiveModel::Serializer
    attributes :id, :name, :heading, :subheading
  end
end

