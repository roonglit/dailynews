module Admin
  module Settings
    class PdfImportsController < BaseController
      def create
        pdf_source = PdfSource.first

        unless pdf_source&.persisted?
          redirect_to admin_settings_pdf_source_path, alert: "Please configure PDF source settings first."
          return
        end

        # Enqueue the import job
        ImportNewspapersJob.perform_later(pdf_source.id)

        redirect_to admin_settings_pdf_source_path,
                    notice: "Import started. This may take a few minutes. Refresh the page to see the status."
      end

      def index
        # Optional: Show import history
        # This can be implemented later if needed
        redirect_to admin_settings_pdf_source_path
      end
    end
  end
end
