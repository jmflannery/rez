class AddPointTypeToRezParagraphs < ActiveRecord::Migration
  def change
    add_column :rez_paragraphs, :point_type, :text
  end
end
