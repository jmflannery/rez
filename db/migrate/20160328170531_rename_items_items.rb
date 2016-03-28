class RenameItemsItems < ActiveRecord::Migration
  def change
    drop_table :rez_items_items

    create_table :rez_items_subitems, id: false do |t|
      t.belongs_to :item, index: true
      t.belongs_to :subitem, index: true
    end
  end
end
