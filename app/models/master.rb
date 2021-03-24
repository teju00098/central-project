class Master < ApplicationRecord
  include SpreadsheetArchitect

  require "csv"
  def self.import(file)
    data = []
    filename = File.basename(file)

    if filename.present?
      where(filename: filename).destroy_all
    end

    CSV.open(file, headers: :first_row).map do |rows|
      row = {filename: filename}
      barcodes = []
      rows.each do |ky, vl|
        ky = ky.to_s.encode("Windows-1252", invalid: :replace, undef: :replace).delete("?")
        if /Barcode\d{1,}/.match?(ky.to_s)
          barcodes.push(vl) if vl.present?
        else
          row[ky] = vl
        end
      end
      row[:created_at] = DateTime.now
      row[:updated_at] = DateTime.now
      barcodes.each do |barcode|
        data.push(row.merge("BarcodeSBC" => barcode))
      end
      if barcodes.blank?
        row[:BarcodeSBC] = row["BarcodeIBC"]
        data.push(row)
      end
    end
    truncate_table("masters") if data.present?
    Master.insert_all!(data)
    update_no_counts!
  end

  def self.search(params)
    masters = Master.where("SKU LIKE ?", "%#{params[:search]}%") if params[:search].present?
    masters
  end

  def self.update_no_counts!
    sbcs = DocumentProduct.where("SBC IS NOT NULL").pluck(:SBC).uniq
    if sbcs.present?
      Master.where("BarcodeSBC IN (?)", sbcs).update_all(HasCount: true)
    end

    Master.where("BarcodeSBC NOT IN (?)", sbcs).update_all(HasCount: false)
  end

  def self.update_zero_counts!
    sbcs = DocumentProduct.where("SBC IS NOT NULL AND QNT <= 0").pluck(:SBC).uniq
    if sbcs.present?
      Master.where("BarcodeSBC IN (?)", sbcs).update_all(ZeroCount: true)
    end

    Master.where("BarcodeSBC NOT IN (?)", sbcs).update_all(ZeroCount: false)
  end

  def spreadsheet_columns
    [
        ["ReportName", "NoCount Report"],
        ["PrintDate", :created_at],
        ["SKU", :SKU],
        ["BarcodeIBC", :BarcodeIBC],
        ["BarcodeSBC", :BarcodeSBC],
        ["ProductName", :ProductName],
        ["Brand", :Brand],
        ["Model", :Model],
        ["CountQTY", 0],
        ["Department", :DeptName]
    ]
  end
end
