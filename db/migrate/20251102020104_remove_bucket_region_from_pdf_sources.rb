class RemoveBucketRegionFromPdfSources < ActiveRecord::Migration[8.1]
  def change
    remove_column :pdf_sources, :bucket_region, :string
  end
end
