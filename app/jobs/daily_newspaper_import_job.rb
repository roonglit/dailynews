class DailyNewspaperImportJob < ApplicationJob
  queue_as :default

  def perform
    pdf_source = PdfSource.first

    # Only run if PDF source exists and is enabled
    unless pdf_source&.enabled?
      Rails.logger.info "[DailyNewspaperImportJob] Skipping - PDF source not configured or disabled"
      return
    end

    Rails.logger.info "[DailyNewspaperImportJob] Starting scheduled daily import"

    # Enqueue the actual import job
    ImportNewspapersJob.perform_later(pdf_source.id)
  end
end
