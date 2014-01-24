module Rez
  class Resume < ActiveRecord::Base
    belongs_to :profile
    belongs_to :address

    validates :name, presence: true

    def items
      Item.where(id: item_ids)
    end

    def add_item(item)
      item_ids << item.id
    end
  end
end
