class ExtractCoverJob < ApplicationJob
  queue_as :default

  def perform(book_id)
    book = Book.find(book_id)

    # Check if PDF is attached
    return unless book.pdf.attached?

    # load pdf file
    book.pdf.open do |pdf_file|
      # Create a temporary file for the cover image
      cover_tempfile = Tempfile.new(["cover", ".jpg"])

      begin
        # Extract first page and save to tempfile
        images = PDFToImage.open(pdf_file.path)
        images[0].r("72").resize("40%").save(cover_tempfile.path)

        # Attach the cover image to the book
        book.cover.attach(
          io: File.open(cover_tempfile.path),
          filename: "#{book.id}_cover.jpg",
          content_type: "image/jpeg"
        )
      ensure
        # Clean up the temporary file
        cover_tempfile.close
        cover_tempfile.unlink
      end
    end
  end
end
