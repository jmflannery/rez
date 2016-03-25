class AddItemsItems < ActiveRecord::Migration
  def change
    create_table :rez_items_items, id: false do |t|
      t.belongs_to :item, index: true
      t.belongs_to :item, index: true
    end
  end
end
