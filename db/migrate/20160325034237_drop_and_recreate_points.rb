class DropAndRecreatePoints < ActiveRecord::Migration
  def change
    drop_table :rez_points

    create_table :rez_points do |t|
      t.text     :text
      t.integer  :point_type
      t.integer  :rank

      t.timestamps
    end
  end
end
