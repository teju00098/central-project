class VarianceMasterReport < ApplicationRecord
  include SpreadsheetArchitect

  belongs_to :master
  belongs_to :variance

  def self.regenerate!(bulk = false)
    truncate_table("variance_master_reports") unless bulk

    result = connection.execute <<~SQL
      SELECT LOCATION AS LOCATION,
                        datetime() AS created_at,
                        datetime() AS updated_at,
                        IBC AS BARCODE,
                        VarianceDIff,
                        VarianceCost,
                        master_id,
                        QNT,
                        Stock AS STOCK
      FROM
        (SELECT masters.DeptName,
                masters.SubDeptName,
                document_products.Location,
                document_products.SKU,
                document_products.IBC,
                document_products.ProductName,
                masters.Brand,
                masters.Model,
                masters.id AS master_id,
                masters.Cost,
                masters.Stock,
                Sum(document_products.QNT) AS QNT,
                (Sum(document_products.QNT) - masters.stock) AS VarianceDiff,
                ((Sum(document_products.QNT)*masters.Cost) - masters.stock) AS VarianceCost
        FROM document_products
        INNER JOIN masters ON masters.BarcodeIBC = document_products.IBC
        GROUP BY masters.DeptName,
                  masters.SubDeptName,
                  document_products.Location,
                  document_products.SKU,
                  document_products.IBC,
                  document_products.ProductName,
                  masters.Brand,
                  masters.Model,
                  masters.Stock,
                  masters.Cost)
    SQL

    VarianceMasterReport.insert_all!(result)
  end

  def spreadsheet_columns
    [
        ["ReportName", "Variance Report"],
        ["PrintDate", :created_at],
        ["CountName", master.CountName],
        ["DeptCode", master.DeptCode],
        ["DeptName", master.DeptName],
        ["Location", :LOCATION],
        ["SKU", :BARCODE],
        ["BarcodeIBC", :BARCODE],
        ["BarcodeSBC", :BARCODE],
        ["ProductName", master.ProductName],
        ["Brand", master.Brand],
        ["Model", master.Model],
        ["Stock", ActiveSupport::NumberHelper::number_to_delimited(send(:STOCK).to_f.round(3))],
        ["QNT", ActiveSupport::NumberHelper::number_to_delimited(send(:QNT).to_f.round(3))],
        ["Variance", ActiveSupport::NumberHelper::number_to_delimited(send(:VarianceDiff).to_f.round(3))],
        ["SKUType", master.SKUType]
    ]
  end
end
