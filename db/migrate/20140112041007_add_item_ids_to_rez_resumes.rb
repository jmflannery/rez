class AddItemIdsToRezResumes < ActiveRecord::Migration
  def change
    add_column :rez_resumes, :item_ids, :integer, array: true, default: []
  end
end
