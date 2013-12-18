class AddNameToRezResumes < ActiveRecord::Migration
  def change
    add_column :rez_resumes, :name, :text
  end
end
