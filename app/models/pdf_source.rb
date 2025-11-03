class PdfSource < ApplicationRecord
  # Associations
  has_many :pdf_import_operations, dependent: :destroy

  # Validations
  validates :bucket_name, presence: true
  validates :bucket_path, presence: true

  # Singleton pattern - only one PDF source configuration
  validate :ensure_singleton

  # Status enum
  enum :last_import_status, {
    idle: "idle",
    running: "running",
    success: "success",
    failed: "failed"
  }, default: :idle

  # Set defaults for new records
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.bucket_name ||= Rails.application.credentials.dig(:huawei, :bucket)
    self.bucket_path ||= "/"
  end

  def ensure_singleton
    if PdfSource.exists? && persisted? == false
      errors.add(:base, "Only one PDF source configuration is allowed")
    end
  end
end
