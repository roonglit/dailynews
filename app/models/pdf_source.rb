class PdfSource < ApplicationRecord
  # Validations
  validates :bucket_name, presence: true
  validates :bucket_path, presence: true

  # Singleton pattern - only one PDF source configuration
  validate :ensure_singleton

  # Status enum
  enum :last_import_status, {
    idle: 'idle',
    running: 'running',
    success: 'success',
    failed: 'failed'
  }, default: :idle

  private

  def ensure_singleton
    if PdfSource.exists? && persisted? == false
      errors.add(:base, 'Only one PDF source configuration is allowed')
    end
  end
end
