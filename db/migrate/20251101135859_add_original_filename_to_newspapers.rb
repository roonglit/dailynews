class AddOriginalFilenameToNewspapers < ActiveRecord::Migration[8.1]
  def change
    add_column :newspapers, :original_filename, :string
    add_index :newspapers, :original_filename
  end
end
