module Rez
  class Item < ActiveRecord::Base
    validates :name, presence: true

    def bullets
      points.where(point_type: 'bullet')
    end

    def paragraphs
      points.where(point_type: 'paragraph')
    end

    def points
      Point.where(id: point_ids)
    end

    def add_point(point)
      if valid_point? point
        point_ids << point.id
        save_point_ids!
      end
    end

    private

    def valid_point?(point)
      point && valid_type?(point.point_type) && !point.new_record?
    end

    def valid_type?(type)
      type == 'bullet' || type == 'paragraph'
    end

    def save_point_ids!
      point_ids_will_change!
      save
    end
  end
end
