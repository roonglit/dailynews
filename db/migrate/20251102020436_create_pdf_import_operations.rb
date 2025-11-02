class CreatePdfImportOperations < ActiveRecord::Migration[8.1]
  def change
    create_table :pdf_import_operations do |t|
      t.references :pdf_source, null: false, foreign_key: true
      t.string :status, null: false, default: 'running'
      t.datetime :started_at, null: false
      t.datetime :completed_at
      t.integer :imported_count, default: 0
      t.integer :skipped_count, default: 0
      t.integer :failed_count, default: 0
      t.jsonb :log, default: {}
      t.text :error_message

      t.timestamps
    end

    add_index :pdf_import_operations, :status
    add_index :pdf_import_operations, :started_at
  end
end
