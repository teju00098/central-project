class Variance < ApplicationRecord
    has_paper_trail
    include SpreadsheetArchitect
    require 'csv'
    def self.import(file)
        h = CSV.open(file, headers: :first_row).map do |row|
            row_h = row.to_h.merge!(created_at: DateTime.now, updated_at: DateTime.now)
            row_h["SKU"] = row_h["BARCODE"]
            row_h
        end
        truncate_table("variances") if h.present?
        Variance.insert_all!(h)
    end

    def self.search(params)
        variances = Variance.where("BARCODE LIKE ? or LOCATION LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%" ) if params[:search].present?
        variances
      end

      def spreadsheet_columns
        [
            ["ReportName", 'variance Data'],
            ["Barcode", variance.BARCODE],
            ["Location", variance.LOCATION],
            ["Quantity", ActiveSupport::NumberHelper::number_to_delimited(variance.QUANTIT.to_f.round(3))]
        ]
      end
end
