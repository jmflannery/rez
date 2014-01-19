module Rez
  class Item < ActiveRecord::Base
    has_many :points
    has_many :paragraphs, -> { where point_type: 'paragraph' }, class_name: 'Point'
    has_many :bullets, -> { where point_type: 'bullet' }, class_name: 'Point'

    validates :name, presence: true
  end
end
