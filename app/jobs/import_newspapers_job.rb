class ImportNewspapersJob < ApplicationJob
  queue_as :default

  def perform(pdf_source_id)
    pdf_source = PdfSource.find(pdf_source_id)

    # Create import operation record
    operation = pdf_source.pdf_import_operations.create!(
      started_at: Time.current,
      status: :running
    )

    # Update pdf_source status to running (for backward compatibility)
    pdf_source.update!(last_import_status: :running)

    # Run the import service
    service = NewspaperImportService.new(pdf_source)
    results = service.perform

    # Determine final status
    final_status = results[:errors].present? && results[:imported] == 0 ? :failed : :success

    # Update import operation
    operation.complete!(status: final_status, results: results)

    # Update pdf_source (for backward compatibility with settings page)
    pdf_source.update!(
      last_import_status: final_status,
      last_imported_at: Time.current,
      last_import_log: results.to_json
    )

    # Cleanup old import operations (older than 30 days)
    PdfImportOperation.cleanup_old_records

    Rails.logger.info "[ImportNewspapersJob] Import completed successfully"

  rescue => e
    error_log = { error: e.message, backtrace: e.backtrace.first(5) }

    # Update operation if it was created
    operation&.update(
      status: :failed,
      completed_at: Time.current,
      error_message: e.message,
      log: error_log
    )

    # Update pdf_source status to failed
    pdf_source&.update(
      last_import_status: :failed,
      last_imported_at: Time.current,
      last_import_log: error_log.to_json
    )

    Rails.logger.error "[ImportNewspapersJob] Import failed: #{e.message}"
    raise
  end
end
