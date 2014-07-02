class CreateRezSections < ActiveRecord::Migration
  def change
    create_table :rez_sections do |t|
      t.text :name
      t.text :heading
      t.text :subheading
      t.integer :item_ids, array: true, default: []

      t.timestamps
    end
  end
end
