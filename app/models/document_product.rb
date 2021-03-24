class DocumentProduct < ApplicationRecord
  has_many :variance_reports
  #
  #   File Headers:
  #     - row: integer
  #     - stock_take_id: string
  #     - docnum: string
  #     - inspector_name: string
  #     - seq: integer
  #     -
  #     - location: string
  #     - barcode: string
  #     - product_name: string
  #     - sale_price: float
  #     - quantity: integer

  def self.import(file, bulk = false)
    uploaded_document = nil
    require "csv"
    filename = File.basename(file)
    unless bulk
      truncate_table("uploaded_documents")
      truncate_table("document_products")
    end
    qts = {}

    rows = CSV.read(file, headers: :first_row).map { |row|
      row_h = row.to_h.merge!(created_at: DateTime.now, updated_at: DateTime.now)
      uploaded_document ||= UploadedDocument.new(docnum: row_h["DocNum"], inspector_name: row_h["Inspector"], filename: filename)
      row_h["DateTime"] = begin
                           row_h["DateTime"].to_datetime
                          rescue
                            DateTime.strptime(row_h["DateTime"].to_s, "%d/%m/%Y %l:%M %p")
                          end
      row_h["filename"] = filename
      qt_key = [row_h["IBC"], row_h["Location"]].join("_")
      qts[qt_key] ||= {QNT: 0, Location: row_h["Location"], IBC: row_h["IBC"]}
      qts[qt_key][:QNT] += row_h["QNT"].to_f
      row_h
    }

    insert_all!(rows)
    uploaded_document.created_at = rows[0][:created_at]
    uploaded_document.updated_at = rows[0][:updated_at]
    uploaded_document.save
    uploaded_document.generate_variance_report
  end
end
