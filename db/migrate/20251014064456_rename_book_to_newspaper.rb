class RenameBookToNewspaper < ActiveRecord::Migration[8.1]
  def change
    rename_table :books, :newspapers
  end
end
