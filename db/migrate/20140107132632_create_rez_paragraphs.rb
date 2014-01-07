class CreateRezParagraphs < ActiveRecord::Migration
  def change
    create_table :rez_paragraphs do |t|
      t.integer :item_id
      t.integer :rank
      t.text :text

      t.timestamps
    end
  end
end
