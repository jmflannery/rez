class AddItemsPoints < ActiveRecord::Migration
  def change
    create_table :rez_items_points, id: false do |t|
      t.belongs_to :item, index: true
      t.belongs_to :point, index: true
    end
  end
end
