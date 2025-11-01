class CreatePdfSources < ActiveRecord::Migration[8.1]
  def change
    create_table :pdf_sources do |t|
      t.string :bucket_name, null: false
      t.string :bucket_region
      t.string :bucket_path, default: '/'
      t.boolean :enabled, default: false, null: false
      t.datetime :last_imported_at
      t.string :last_import_status, default: 'idle'
      t.text :last_import_log

      t.timestamps
    end
  end
end
