module Rez
  class Section < ActiveRecord::Base
    validates :name, presence: true

    def items
      Item.where(id: item_ids)
    end

    def add_item(item)
      if valid_item? item
        item_ids << item.id
        save_item_ids!
      end
    end

    private

    def valid_item?(item)
      item && !item.new_record? && item.id > 0
    end

    def save_item_ids!
      item_ids_will_change!
      save
    end
  end
end
