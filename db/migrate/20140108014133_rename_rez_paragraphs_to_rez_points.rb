class RenameRezParagraphsToRezPoints < ActiveRecord::Migration
  def change
    rename_table :rez_paragraphs, :rez_points
  end
end
