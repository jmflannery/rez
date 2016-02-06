class AddEmailToRezProfiles < ActiveRecord::Migration
  def change
    add_column :rez_profiles, :email, :string
  end
end
