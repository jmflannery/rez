class AddBulletIdsToRezItems < ActiveRecord::Migration
  def change
    add_column :rez_items, :bullet_ids, :integer, array: true, default: []
  end
end
