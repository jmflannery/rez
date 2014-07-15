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

    def points=(points)
      self.point_ids = []
      points.each do |point|
        self.point_ids << point.id
      end
      save_point_ids!
    end

    def add_point(point)
      if point && (valid_type? point.point_type)
        point_ids << point.id
        save_point_ids!
      end
    end

    private

    def valid_type?(type)
      type == 'bullet' || type == 'paragraph'
    end

    def save_point_ids!
      point_ids_will_change!
      save
    end
  end
end
