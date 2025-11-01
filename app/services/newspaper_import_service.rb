class NewspaperImportService
  attr_reader :pdf_source, :results

  def initialize(pdf_source)
    @pdf_source = pdf_source
    @results = {
      imported: 0,
      skipped: 0,
      failed: 0,
      errors: [],
      files: []
    }
  end

  def perform
    Rails.logger.info "[NewspaperImport] Starting import from bucket: #{pdf_source.bucket_name}"

    begin
      # Connect to S3-compatible Huawei OBS
      s3_client = create_s3_client

      # List all PDF files in the configured path
      pdf_files = list_pdf_files(s3_client)

      Rails.logger.info "[NewspaperImport] Found #{pdf_files.count} PDF files"

      pdf_files.each do |file_key|
        process_pdf_file(s3_client, file_key)
      end

      Rails.logger.info "[NewspaperImport] Import completed: #{results[:imported]} imported, #{results[:skipped]} skipped, #{results[:failed]} failed"

    rescue => e
      Rails.logger.error "[NewspaperImport] Import failed: #{e.message}"
      results[:errors] << "Import failed: #{e.message}"
    end

    results
  end

  private

  def create_s3_client
    Aws::S3::Client.new(
      endpoint: 'https://obs.ap-southeast-2.myhuaweicloud.com',
      region: pdf_source.bucket_region || 'ap-southeast-2',
      access_key_id: Rails.application.credentials.dig(:huawei, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:huawei, :secret_access_key),
      force_path_style: true
    )
  end

  def list_pdf_files(s3_client)
    pdf_files = []
    continuation_token = nil

    # Handle pagination for large buckets
    loop do
      response = s3_client.list_objects_v2(
        bucket: pdf_source.bucket_name,
        prefix: pdf_source.bucket_path.gsub(/^\//, ''), # Remove leading slash for S3
        continuation_token: continuation_token
      )

      # Filter for PDF files only
      pdf_files += response.contents
        .select { |obj| obj.key.downcase.end_with?('.pdf') }
        .map(&:key)

      break unless response.is_truncated
      continuation_token = response.next_continuation_token
    end

    pdf_files
  end

  def process_pdf_file(s3_client, file_key)
    filename = File.basename(file_key)
    results[:files] << filename

    Rails.logger.info "[NewspaperImport] Processing: #{filename}"

    # Parse filename for metadata
    metadata = parse_filename(filename)

    unless metadata
      results[:failed] += 1
      results[:errors] << "Invalid filename format: #{filename}"
      Rails.logger.warn "[NewspaperImport] Skipping #{filename} - invalid format"
      return
    end

    # Check if already imported
    if already_imported?(filename)
      results[:skipped] += 1
      Rails.logger.info "[NewspaperImport] Skipping #{filename} - already imported"
      return
    end

    # Download and import
    begin
      download_and_import(s3_client, file_key, filename, metadata)
      results[:imported] += 1
      Rails.logger.info "[NewspaperImport] Successfully imported: #{filename}"
    rescue => e
      results[:failed] += 1
      results[:errors] << "Failed to import #{filename}: #{e.message}"
      Rails.logger.error "[NewspaperImport] Failed to import #{filename}: #{e.message}"
    end
  end

  def parse_filename(filename)
    # Remove .pdf extension
    name = filename.gsub(/\.pdf$/i, '')

    # Pattern: Title_With_Underscores_YYYY-MM-DD
    # Extract date (last part: YYYY-MM-DD)
    date_match = name.match(/_(\d{4}-\d{2}-\d{2})$/)
    return nil unless date_match

    begin
      published_at = Date.parse(date_match[1])
    rescue ArgumentError
      return nil
    end

    # Extract title (everything before date, replace underscores with spaces)
    title = name.gsub(/_#{date_match[1]}$/, '').tr('_', ' ')

    {
      title: title,
      published_at: published_at
    }
  rescue => e
    Rails.logger.error "[NewspaperImport] Error parsing filename #{filename}: #{e.message}"
    nil
  end

  def already_imported?(filename)
    Newspaper.exists?(original_filename: filename)
  end

  def download_and_import(s3_client, file_key, filename, metadata)
    # Download PDF to temporary file
    temp_file = Tempfile.new([metadata[:title], '.pdf'])

    begin
      # Download from S3
      s3_client.get_object(
        bucket: pdf_source.bucket_name,
        key: file_key,
        response_target: temp_file.path
      )

      # Create newspaper record
      newspaper = Newspaper.new(
        title: metadata[:title],
        published_at: metadata[:published_at],
        original_filename: filename
      )

      # Attach PDF file
      newspaper.pdf.attach(
        io: File.open(temp_file.path),
        filename: filename,
        content_type: 'application/pdf'
      )

      newspaper.save!

      # Trigger cover extraction job
      ExtractCoverJob.perform_later(newspaper.id)

      Rails.logger.info "[NewspaperImport] Created newspaper ##{newspaper.id}: #{metadata[:title]}"

    ensure
      temp_file.close
      temp_file.unlink
    end
  end
end
