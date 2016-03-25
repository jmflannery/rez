module Rez
  class Point < ActiveRecord::Base
    enum point_type: [:bullet, :paragraph]
    has_and_belongs_to_many :items
    # validates :point_type, inclusion: { in: ['paragraph', 'bullet'],
    #   message: "%{value} is not a valid type" }
    # 
    # scope :paragraphs, -> { where(point_type: 'paragraph') }
    # scope :bullets, -> { where(point_type: 'bullet') }
  end
end
