class ZeroCountReport < ApplicationRecord
  include SpreadsheetArchitect   
  belongs_to :master

  def self.regenerate!(bulk = false)
    truncate_table("zero_count_reports") unless bulk

    result = connection.execute <<~SQL
      Select
      datetime() AS created_at,
      datetime() AS updated_at,
      masters.id as master_id,
      masters.DeptName,
      masters.SubDeptName,
      document_products.Location,
      document_products.SKU,
      document_products.IBC,
      document_products.SBC,
      document_products.ProductName,
      masters.Brand,
      masters.Model,
      masters.Stock,
      masters.Cost,
      document_products.QNT
      From
      document_products Inner Join
      masters On masters.BarcodeIBC = document_products.IBC
      Where
      document_products.QNT = 0
    SQL

    insert_all!(result)
  end

  def spreadsheet_columns
    [
        ["ReportName", 'ZeroCount Report'],
        ["PrintDate", :created_at],
        ["Location", :Location],
        ["Variance", ActiveSupport::NumberHelper::number_to_delimited((0-master.Stock.to_f * master.Cost.to_f).round(3))],
        ["SKU", master.BarcodeIBC],
        ["BarcodeIBC", master.BarcodeIBC],
        ["BarcodeSBC", master.BarcodeSBC],
        ["Brand", master.Brand],
        ["Model", master.Model],
        ["CountQTY", '0'],
        ["Department", master.DeptName]
    ]
  end
end
