module Rez
  class Item < ActiveRecord::Base
    has_and_belongs_to_many :resumes
    has_and_belongs_to_many :points
    has_and_belongs_to_many :subitems,
        class_name: 'Item',
        join_table: 'rez_items_subitems',
        foreign_key: 'item_id',
        association_foreign_key: 'subitem_id'

    validates :name, presence: true
  end
end
