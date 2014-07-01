class AddPointIdsToRezItems < ActiveRecord::Migration
  def change
    add_column :rez_items, :point_ids, :integer, array: true, default: []
  end
end
