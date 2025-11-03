class PdfImportOperation < ApplicationRecord
  belongs_to :pdf_source

  # Status enum: running, success, failed
  enum :status, { running: "running", success: "success", failed: "failed" }, default: :running

  # Validations
  validates :status, presence: true
  validates :started_at, presence: true

  # Scopes
  scope :recent, -> { order(started_at: :desc) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :older_than, ->(days) { where("started_at < ?", days.days.ago) }

  # Cleanup old records (older than 30 days)
  def self.cleanup_old_records
    deleted_count = older_than(30).delete_all
    Rails.logger.info "[PdfImportOperation] Cleaned up #{deleted_count} old import operations"
    deleted_count
  end

  # Mark operation as completed
  def complete!(status:, results:)
    update!(
      status: status,
      completed_at: Time.current,
      imported_count: results[:imported] || 0,
      skipped_count: results[:skipped] || 0,
      failed_count: results[:failed] || 0,
      log: results,
      error_message: results[:errors]&.join("\n")
    )
  end

  # Duration in seconds
  def duration
    return nil unless completed_at
    (completed_at - started_at).to_i
  end
end
