module Rez
  class Section < ActiveRecord::Base
    validates :name, presence: true

    def items
      Item.where(id: item_ids)
    end

    def items=(items)
      self.item_ids = []
      items.each do |item|
        self.item_ids << item.id
      end
      save_item_ids!
    end

    def add_item(item)
      self.item_ids << item.id
      save_item_ids!
    end

    private

    def save_item_ids!
      item_ids_will_change!
      save
    end
  end
end
