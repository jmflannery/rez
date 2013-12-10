class ChangeRezProfilesColumnType < ActiveRecord::Migration
  def change
    change_column :rez_profiles, :title, :text
  end
end
