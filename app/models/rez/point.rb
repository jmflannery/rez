module Rez
  class Point < ActiveRecord::Base
    validates :point_type, inclusion: { in: ['paragraph', 'bullet'],
      message: "%{value} is not a valid type" }

    scope :paragraphs, -> { where(point_type: 'paragraph') }
    scope :bullets, -> { where(point_type: 'bullet') }
  end
end
