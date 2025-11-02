module Admin
  module Settings
    class PdfSourcesController < BaseController
      before_action :set_pdf_source

      def show
      end

      def update
        if @pdf_source.update(pdf_source_params)
          redirect_to admin_settings_pdf_source_path, notice: "PDF source configuration was successfully updated."
        else
          render :show, status: :unprocessable_entity
        end
      end

      private

      def set_pdf_source
        @pdf_source = PdfSource.first || PdfSource.new(
          bucket_name: "",
          bucket_path: "/",
          enabled: false
        )
      end

      def pdf_source_params
        params.expect(pdf_source: [
          :id, :bucket_name, :bucket_path, :enabled
        ])
      end
    end
  end
end
