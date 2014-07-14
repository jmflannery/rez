class RemoveItemIdsFromRezResumes < ActiveRecord::Migration
  def change
    remove_column :rez_resumes, :item_ids
  end
end
