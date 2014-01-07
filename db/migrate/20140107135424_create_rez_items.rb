class CreateRezItems < ActiveRecord::Migration
  def change
    create_table :rez_items do |t|
      t.text :title
      t.text :heading

      t.timestamps
    end
  end
end
