FactoryBot.define do
  factory :pdf_source do
    bucket_name { "test-newspaper-bucket" }
    bucket_path { "/newspapers" }
    enabled { false }
    last_import_status { "idle" }
  end
end
