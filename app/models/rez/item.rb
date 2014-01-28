module Rez
  class Item < ActiveRecord::Base
    has_many :paragraphs, -> { where point_type: 'paragraph' }, class_name: 'Point'

    validates :name, presence: true

    def bullets
      Point.where(id: bullet_ids)
    end

    def points
      Point.where(id: bullet_ids)
    end

    def add_bullet(bullet)
      if bullet && bullet.point_type == 'bullet'
        bullet_ids << bullet.id
        save_bullets_ids!
      end
    end

    def save_bullets_ids!
      bullet_ids_will_change!
      save
    end
  end
end
