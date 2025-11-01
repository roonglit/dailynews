class ImportNewspapersJob < ApplicationJob
  queue_as :default

  def perform(pdf_source_id)
    pdf_source = PdfSource.find(pdf_source_id)

    # Update status to running
    pdf_source.update!(last_import_status: :running)

    # Run the import service
    service = NewspaperImportService.new(pdf_source)
    results = service.perform

    # Update status and log
    pdf_source.update!(
      last_import_status: :success,
      last_imported_at: Time.current,
      last_import_log: results.to_json
    )

    Rails.logger.info "[ImportNewspapersJob] Import completed successfully"

  rescue => e
    # Update status to failed
    pdf_source&.update(
      last_import_status: :failed,
      last_imported_at: Time.current,
      last_import_log: { error: e.message, backtrace: e.backtrace.first(5) }.to_json
    )

    Rails.logger.error "[ImportNewspapersJob] Import failed: #{e.message}"
    raise
  end
end
