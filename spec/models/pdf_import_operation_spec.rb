require 'rails_helper'

RSpec.describe PdfImportOperation, type: :model do
  include ActiveSupport::Testing::TimeHelpers
  describe 'associations' do
    it 'belongs to pdf_source' do
      pdf_source = create(:pdf_source)
      operation = create(:pdf_import_operation, pdf_source: pdf_source)
      expect(operation.pdf_source).to eq(pdf_source)
    end
  end

  describe 'validations' do
    it 'validates presence of status' do
      operation = build(:pdf_import_operation, status: nil)
      expect(operation).not_to be_valid
      expect(operation.errors[:status]).to be_present
    end

    it 'validates presence of started_at' do
      operation = build(:pdf_import_operation, started_at: nil)
      expect(operation).not_to be_valid
      expect(operation.errors[:started_at]).to be_present
    end
  end

  describe 'enums' do
    it 'defines status enum' do
      pdf_source = create(:pdf_source)
      operation = create(:pdf_import_operation, pdf_source: pdf_source)

      operation.update(status: :running)
      expect(operation.running?).to be true

      operation.update(status: :success)
      expect(operation.success?).to be true

      operation.update(status: :failed)
      expect(operation.failed?).to be true
    end
  end

  describe 'scopes' do
    let!(:pdf_source) { create(:pdf_source) }
    let!(:recent_operation) { create(:pdf_import_operation, :success, pdf_source: pdf_source, started_at: 1.day.ago) }
    let!(:old_operation) { create(:pdf_import_operation, :success, pdf_source: pdf_source, started_at: 5.days.ago) }
    let!(:running_operation) { create(:pdf_import_operation, pdf_source: pdf_source, started_at: 1.hour.ago) }

    describe '.recent' do
      it 'orders by started_at desc' do
        expect(PdfImportOperation.recent.first).to eq(running_operation)
        expect(PdfImportOperation.recent.last).to eq(old_operation)
      end
    end

    describe '.completed' do
      it 'returns only completed operations' do
        completed = PdfImportOperation.completed
        expect(completed).to include(recent_operation, old_operation)
        expect(completed).not_to include(running_operation)
      end
    end

    describe '.older_than' do
      it 'returns operations older than specified days' do
        old_ops = PdfImportOperation.older_than(3)
        expect(old_ops).to include(old_operation)
        expect(old_ops).not_to include(recent_operation, running_operation)
      end
    end
  end

  describe '.cleanup_old_records' do
    let!(:pdf_source) { create(:pdf_source) }
    let!(:recent_operation) { create(:pdf_import_operation, :success, pdf_source: pdf_source, started_at: 15.days.ago) }
    let!(:old_operation1) { create(:pdf_import_operation, :success, pdf_source: pdf_source, started_at: 35.days.ago) }
    let!(:old_operation2) { create(:pdf_import_operation, :failed, pdf_source: pdf_source, started_at: 45.days.ago) }

    it 'deletes records older than 30 days' do
      expect {
        PdfImportOperation.cleanup_old_records
      }.to change { PdfImportOperation.count }.by(-2)

      expect(PdfImportOperation.exists?(recent_operation.id)).to be true
      expect(PdfImportOperation.exists?(old_operation1.id)).to be false
      expect(PdfImportOperation.exists?(old_operation2.id)).to be false
    end

    it 'returns the count of deleted records' do
      count = PdfImportOperation.cleanup_old_records
      expect(count).to eq(2)
    end
  end

  describe '#complete!' do
    let(:pdf_source) { create(:pdf_source) }
    let(:operation) { create(:pdf_import_operation, pdf_source: pdf_source) }
    let(:results) do
      {
        imported: 5,
        skipped: 2,
        failed: 1,
        errors: [ 'Error 1', 'Error 2' ],
        files: [ 'file1.pdf', 'file2.pdf' ]
      }
    end

    it 'updates the operation with results' do
      travel_to Time.current do
        operation.complete!(status: :success, results: results)

        operation.reload
        expect(operation.status).to eq('success')
        expect(operation.completed_at).to eq(Time.current)
        expect(operation.imported_count).to eq(5)
        expect(operation.skipped_count).to eq(2)
        expect(operation.failed_count).to eq(1)
        expect(operation.log).to eq(results.stringify_keys)
        expect(operation.error_message).to eq("Error 1\nError 2")
      end
    end

    it 'handles results without errors' do
      results_without_errors = results.except(:errors)
      operation.complete!(status: :success, results: results_without_errors)

      operation.reload
      expect(operation.error_message).to be_nil
    end
  end

  describe '#duration' do
    let(:pdf_source) { create(:pdf_source) }

    context 'when operation is completed' do
      it 'returns duration in seconds' do
        operation = create(:pdf_import_operation, :success,
                          pdf_source: pdf_source,
                          started_at: Time.current - 5.minutes,
                          completed_at: Time.current)
        expect(operation.duration).to eq(300)
      end
    end

    context 'when operation is not completed' do
      it 'returns nil' do
        operation = create(:pdf_import_operation, pdf_source: pdf_source)
        expect(operation.duration).to be_nil
      end
    end
  end
end
