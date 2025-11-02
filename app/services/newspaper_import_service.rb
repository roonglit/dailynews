require 'aws-sdk-s3'

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
    # Load and parse storage.yml with ERB
    storage_yml = ERB.new(File.read(Rails.root.join('config/storage.yml'))).result
    storage_config = YAML.safe_load(storage_yml, aliases: true)
    huawei_config = storage_config['huawei_import']

    Aws::S3::Client.new(
      endpoint: huawei_config['endpoint'],
      region: huawei_config['region'],
      access_key_id: huawei_config['access_key_id'],
      secret_access_key: huawei_config['secret_access_key'],
      force_path_style: huawei_config['force_path_style']
    )
  end

  def list_pdf_files(s3_client)
    prefixes_to_scan = []
    base_path = pdf_source.bucket_path.gsub(/^\/|\/+$/, '') # Remove leading/trailing slashes

    # Always scan inbox folder
    prefixes_to_scan << "#{base_path}/inbox/".gsub(/^\//, '')

    # Scan current and previous month folders (YYYYMM format)
    months_to_scan = [Date.today, 1.month.ago].map { |d| d.strftime('%Y%m') }
    months_to_scan.each do |month|
      prefixes_to_scan << "#{base_path}/#{month}/".gsub(/^\//, '')
    end

    pdf_files = []

    prefixes_to_scan.each do |prefix|
      continuation_token = nil

      # Handle pagination for large buckets
      loop do
        response = s3_client.list_objects_v2(
          bucket: pdf_source.bucket_name,
          prefix: prefix,
          continuation_token: continuation_token
        )

        # Skip if no contents (folder doesn't exist)
        if response.contents.nil?
          break
        end

        # Filter for PDF files only
        pdf_files += response.contents
          .select { |obj| obj.key.downcase.end_with?('.pdf') }
          .map(&:key)

        break unless response.is_truncated
        continuation_token = response.next_continuation_token
      end
    end

    pdf_files
  end

  def process_pdf_file(s3_client, file_key)
    filename = File.basename(file_key)
    results[:files] << filename

    Rails.logger.info "[NewspaperImport] Processing: #{filename}"

    # Parse filename for metadata (pass full file_key to determine parsing strategy)
    metadata = parse_filename(file_key)

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

  def parse_filename(file_key)
    filename = File.basename(file_key)

    # Determine if file is from inbox (flexible) or date folder (strict)
    is_inbox = file_key.include?('/inbox/') || file_key.start_with?('inbox/')

    if is_inbox
      # Flexible parsing for inbox folder
      parse_inbox_filename(filename)
    else
      # Strict parsing for YYYYMM folders
      parse_dated_filename(filename)
    end
  rescue => e
    Rails.logger.error "[NewspaperImport] Error parsing filename #{filename}: #{e.message}"
    nil
  end

  def parse_inbox_filename(filename)
    # Remove .pdf extension
    name = filename.gsub(/\.pdf$/i, '')

    # Use filename as title and current date as published_at
    {
      title: name,
      published_at: Date.today
    }
  end

  def parse_dated_filename(filename)
    # Remove .pdf extension
    name = filename.gsub(/\.pdf$/i, '')

    # Pattern: DNT_MMDDYYYY
    # Example: DNT_01152025.pdf -> January 15, 2025
    match = name.match(/^([A-Z]+)_(\d{8})$/)
    return nil unless match

    date_string = match[2]

    # Parse MMDDYYYY format
    begin
      month = date_string[0..1].to_i
      day = date_string[2..3].to_i
      year = date_string[4..7].to_i

      published_at = Date.new(year, month, day)
    rescue ArgumentError
      return nil
    end

    # Format title: "Dailynews 10 Oct 2025"
    title = "Dailynews #{published_at.strftime('%-d %b %Y')}"

    {
      title: title,
      published_at: published_at
    }
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
