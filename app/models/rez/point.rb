module Rez
  class Point < ActiveRecord::Base
    belongs_to :item

    validates :point_type, inclusion: { in: ['paragraph', 'bullet'],
      message: "%{value} is not a valid type" }
  end
end
