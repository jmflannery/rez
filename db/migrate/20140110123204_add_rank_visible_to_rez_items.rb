class AddRankVisibleToRezItems < ActiveRecord::Migration
  def change
    add_column :rez_items, :rank, :integer
    add_column :rez_items, :visible, :boolean
  end
end
