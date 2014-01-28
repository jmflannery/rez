class AddParagraphIdsToRezItems < ActiveRecord::Migration
  def change
    add_column :rez_items, :paragraph_ids, :integer, array: true, default: []
  end
end
