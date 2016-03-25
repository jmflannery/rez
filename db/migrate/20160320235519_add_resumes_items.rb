class AddResumesItems < ActiveRecord::Migration
  def change
    create_table :rez_items_resumes, id: false do |t|
      t.belongs_to :resume, index: true
      t.belongs_to :item, index: true
    end
  end
end
