require 'pdftoimage'

namespace :pdf do
  task :extract, [:name] do |t, args|
    filename = args[:name]
    raise "Please provide a filename: rails pdf:extract[filename.pdf]" if filename.nil? || filename.empty?

    # pages = CombinePDF.load(filename).pages;

    # pdf = CombinePDF.new
    # pdf << pages[0]
    # pdf.save("cover.pdf")

    images = PDFToImage.open(filename)
    images[0].r("72").resize("40%").save("cover.jpg")
  end
end
