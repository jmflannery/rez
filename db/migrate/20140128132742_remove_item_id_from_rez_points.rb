class RemoveItemIdFromRezPoints < ActiveRecord::Migration
  def change
    remove_column :rez_points, :item_id
  end
end
