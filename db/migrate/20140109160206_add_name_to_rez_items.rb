class AddNameToRezItems < ActiveRecord::Migration
  def change
    add_column :rez_items, :name, :text
  end
end
