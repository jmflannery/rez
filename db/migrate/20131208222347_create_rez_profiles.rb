class CreateRezProfiles < ActiveRecord::Migration
  def change
    create_table :rez_profiles do |t|
      t.string :firstname, limit: 32
      t.string :middlename, limit: 32
      t.string :lastname, limit: 32
      t.string :nickname, limit: 32
      t.string :prefix, limit: 6
      t.string :suffix, limit: 6
      t.string :title, limit: 32

      t.timestamps
    end
  end
end
