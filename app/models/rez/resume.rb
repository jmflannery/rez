module Rez
  class Resume < ActiveRecord::Base
    belongs_to :profile
    belongs_to :address

    validates :name, presence: true

    def items
      Item.where(id: item_ids).to_a
    end
  end
end
