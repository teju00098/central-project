class Pdamaster < ApplicationRecord
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
    truncate_table("pdamasters") if data.present?
    Pdamaster.insert_all!(data)
    update_no_counts!
  end

  def self.search(params)
    masters = Pdamaster.where("SKU LIKE ?", "%#{params[:search]}%") if params[:search].present?
    masters
  end

  def self.update_no_counts!
    sbcs = DocumentProduct.where("SBC IS NOT NULL").pluck(:SBC).uniq
    if sbcs.present?
      Pdamaster.where("BarcodeSBC IN (?)", sbcs).update_all(HasCount: true)
    end

    Pdamaster.where("BarcodeSBC NOT IN (?)", sbcs).update_all(HasCount: false)
  end

  def self.update_zero_counts!
    sbcs = DocumentProduct.where("SBC IS NOT NULL AND QNT <= 0").pluck(:SBC).uniq
    if sbcs.present?
      Pdamaster.where("BarcodeSBC IN (?)", sbcs).update_all(ZeroCount: true)
    end

    Pdamaster.where("BarcodeSBC NOT IN (?)", sbcs).update_all(ZeroCount: false)
  end
end
