class StockVarianceReport < ApplicationRecord
  include SpreadsheetArchitect
  extend ActionView::Helpers::NumberHelper

  belongs_to :document_product
  belongs_to :master_business
  belongs_to :master
  belongs_to :uploaded_document

  def self.regenerate!(bulk = false)
    truncate_table("stock_variance_reports") unless bulk
    locations = Variance.distinct("Location").pluck("Location")
    results = ActiveRecord::Base.connection.execute("SELECT SUM(QNT) as CountQTY, SKU, Location, SBC FROM document_products WHERE Location IN (#{locations.map { |x| "'#{x}'" }.join(",")}) GROUP BY Location, SBC")

    records = []
    results.each do |result|
      variance = Variance.where(Location: result["Location"], BARCODE: result["SBC"]).first
      dp = DocumentProduct.where(SBC: result["SBC"]).first
      ud = UploadedDocument.where(docnum: dp.DocNum).first
      if variance
        master = Master.where(BarcodeSBC: result["SBC"]).first
        if master
          result["VarianceQTY"] = result["CountQTY"].to_f - master.Stock.to_f
          result["VariancePercent"] = (result["VarianceQTY"] * 100) / master.Stock.to_f if master.Stock.to_f > 0
          result["VariancePercent"] ||= 0
          result["EXTPHY_RETAIL"] = result["CountQTY"].to_f * master.RetailPrice.to_f
          result["EXTPHY_COST"] = result["CountQTY"].to_f * master.Cost.to_f
          result["EXTPHY_RETAILVAR"] = result["VarianceQTY"] * master.RetailPrice.to_f
          result["EXTPHY_COSTVAR"] = result["VarianceQTY"] * master.Cost.to_f
          result["master_id"] = master.id
          result["document_product_id"] = dp.id
          result["uploaded_document_id"] = ud.id
          result["created_at"] = Time.now
          result["updated_at"] = result["created_at"]
          result.delete("SBC")
          result.delete("Location")
          result.delete("NaN")
          records.push(result)
        end
      end
    end

    insert_all!(records) if records.present?
  end

  def spreadsheet_columns
    [
        ["ReportName", "StockTake Variance Report"],
        ["Print Date", :created_at],
        ["Count Name", document_product.StockTakeID],
        ["CNTNAME", "Full Stock Count #{created_at} #{MasterBusiness.first.business_unit}"],
        ["Store Code", master.StoreCode],
        ["Store Name", master.StoreName],
        ["Count Date", uploaded_document.created_at],
        ["Dept Code", master.DeptCode],
        ["Dept Name", master.DeptName],
        ["Sub Dept Code", master.SubDeptCode],
        ["Sub Dept Name", master.SubDeptName],
        ["SKU", document_product.SKU],
        ["Barcode IBC", document_product.IBC],
        ["Barcode SBC", document_product.SBC],
        ["Product Name", document_product.ProductName],
        ["Brand", master.Brand],
        ["Model", master.Model],
        ["Stock", ActiveSupport::NumberHelper::number_to_delimited(master.Stock.to_f.round(3))],
        ["Count QTY", ActiveSupport::NumberHelper::number_to_delimited(send(:CountQTY).to_f.round(3))],
        ["Variance QTY", ActiveSupport::NumberHelper::number_to_delimited(send(:VarianceQTY).to_f.round(3))],
        ["Variance Percent", ActiveSupport::NumberHelper::number_to_delimited(send(:VariancePercent).to_f.round(3))],
        ["EXTPHY Retail", ActiveSupport::NumberHelper::number_to_delimited(send(:EXTPHY_RETAIL).to_f.round(3))],
        ["EXTPHY CNT COST", ActiveSupport::NumberHelper::number_to_delimited(send(:EXTPHY_COST).to_f.round(3))],
        ["EXTPHY Retail Var", ActiveSupport::NumberHelper::number_to_delimited(send(:EXTPHY_RETAILVAR).to_f.round(3))],
        ["EXTPHY Cost Var", ActiveSupport::NumberHelper::number_to_delimited(send(:EXTPHY_COSTVAR).to_f.round(3))]    ]
  end
end
