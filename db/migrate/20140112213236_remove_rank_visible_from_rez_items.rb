class RemoveRankVisibleFromRezItems < ActiveRecord::Migration
  def change
    remove_column :rez_items, :rank
    remove_column :rez_items, :visible
  end
end
