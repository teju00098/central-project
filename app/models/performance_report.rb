class PerformanceReport < ApplicationRecord
  include SpreadsheetArchitect

  def self.regenerate!(bulk = false)
    truncate_table("performance_reports")
    reports = []

    inspector_with_qty = DocumentProduct.group(:Inspector).count
    docnums = JSON.parse(
      DocumentProduct.connection.execute("select json_group_object(Inspector, DocNum) as data from (select Inspector,DocNum from document_products group by Inspector)").first["data"]
    )
    total_qtys = JSON.parse(
      DocumentProduct.connection.execute("select json_group_object(Inspector, total_qty) as data from (select Inspector,SUM(QNT) as total_qty from document_products group by Inspector)").first["data"]
    )
    locations = JSON.parse(
      DocumentProduct.connection.execute("select json_group_object(Inspector, total_location) as data from (select Inspector, COUNT(DISTINCT Location) as total_location from document_products group by Inspector)").first["data"]
    )
    skus = JSON.parse(
      DocumentProduct.connection.execute("select json_group_object(Inspector, total_sku) as data from (select Inspector, COUNT(DISTINCT SKU) as total_sku from document_products group by Inspector)").first["data"]
    )
    values = JSON.parse(
      DocumentProduct.connection.execute("select json_group_object(Inspector, total_value) as data from (select Inspector, SUM(QNT*SalePrice) as total_value from document_products group by Inspector)").first["data"]
    )

    earilest_datetime = JSON.parse(
      DocumentProduct.connection.execute("select json_group_object(Inspector, start) as data from (select Inspector, min(DateTime) as start from document_products group by Inspector)").first["data"]
    )

    last_datetime = JSON.parse(
      DocumentProduct.connection.execute('select json_group_object(Inspector, finish) as data from (select inspector, max(DateTime) as finish from "document_products" group by "inspector")').first["data"]
    )

    inspector_with_qty.each do |inspector, qty|
      start = DateTime.parse(earilest_datetime[inspector])
      finish = DateTime.parse(last_datetime[inspector])
      reports << {
        pda_mac_no: docnums[inspector].slice(1, 12).scan(/../).join(":"),
        inspector: inspector,
        total_qty: total_qtys[inspector],
        start: start.strftime("%I:%M %p"),
        finish: finish.strftime("%I:%M %p"),
        total: total(start, finish),
        location: locations[inspector],
        sku: skus[inspector],
        updated_at: Time.current,
        value: values[inspector],
        created_at: Time.current
      }
    end

    PerformanceReport.import reports if reports.present?
  end

  def self.total(start, finish)
    total = TimeDifference.between(start, finish).in_general
    total[:minutes].zero? ? "#{total[:hours]}h" : "#{total[:hours]}h #{total[:minutes]}m"
  end

  def spreadsheet_columns
    [
        ["ReportName", "Performance Report"],
        ["PDA MAC/NO", pda_mac_no],
        ["Inspector", inspector],
        ["Start", start],
        ["Finish", finish],
        ["Total", ActiveSupport::NumberHelper::number_to_delimited(total.to_f.round(3))],
        ["Location", location],
        ["SKU", sku],
        ["QTY", ActiveSupport::NumberHelper::number_to_delimited(total_qty.to_f.round(3))],
        ["Value", ActiveSupport::NumberHelper::number_to_delimited(value.to_f.round(3))]
    ]
  end
end
