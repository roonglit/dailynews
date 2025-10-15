class AddPublishedAtToNewspapers < ActiveRecord::Migration[8.1]
  def change
    add_column :newspapers, :published_at, :datetime
  end
end
