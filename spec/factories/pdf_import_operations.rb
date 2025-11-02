FactoryBot.define do
  factory :pdf_import_operation do
    association :pdf_source
    status { "running" }
    started_at { Time.current }
    completed_at { nil }
    imported_count { 0 }
    skipped_count { 0 }
    failed_count { 0 }
    log { {} }
    error_message { nil }

    trait :success do
      status { "success" }
      completed_at { Time.current + 5.minutes }
      imported_count { 5 }
      skipped_count { 2 }
      failed_count { 0 }
      log do
        {
          imported: 5,
          skipped: 2,
          failed: 0,
          errors: [],
          files: ["Daily_News_2024-11-01.pdf", "Bangkok_Post_2024-11-02.pdf"]
        }
      end
    end

    trait :failed do
      status { "failed" }
      completed_at { Time.current + 2.minutes }
      failed_count { 3 }
      error_message { "Connection timeout" }
      log do
        {
          imported: 0,
          skipped: 0,
          failed: 3,
          errors: ["Connection timeout", "Network error"],
          files: []
        }
      end
    end

    trait :old do
      started_at { 45.days.ago }
      completed_at { 45.days.ago + 5.minutes }
    end
  end
end
