class SummaryReport < ApplicationRecord
  include SpreadsheetArchitect
  def self.regenerate!
    truncate_table("summary_reports")
    reports = []

    skucount = SKUCount()
    sku_no_diff = SKUNoDiff()
    sku_diff_gain = SKUDiffGain()
    sku_diff_loss = SKUDiffLoss()
    soh = SOH()
    physical = Physical()
    over = Over()
    short = Short()
    variance = Variance()
    physical_count_cost_value = PhysicalCountCostValue()
    physical_count_retail_value = PhysicalCountRetailValue()
    gain_cost_value = GainCostValue()
    gain_retail_value = GainRetailValue()
    loss_cost_value = LossCostValue()
    loss_retail_value = LossRetailValue()
    gain_loss_value_cost_value = GainLossValueCostValue()
    gain_loss_value_retail_value = GainLossValueRetailValue()

    sub_dept_names = Master.distinct.pluck(:SubDeptName, :DeptName)
    sub_dept_names.each do |sub_dept_name, dept_name|
      credit = sub_dept_name
      reports << {
        DeptName: dept_name,
        SubDeptName: sub_dept_name,
        credit: credit,
        skucount: skucount[sub_dept_name],
        sku_no_diff: sku_no_diff[sub_dept_name],
        sku_diff_gain: sku_diff_gain[sub_dept_name],
        sku_diff_loss: sku_diff_loss[sub_dept_name],
        quantity_soh: soh[sub_dept_name],
        quantity_over: over[sub_dept_name],
        quantity_short: short[sub_dept_name],
        quantity_physical: physical[sub_dept_name],
        quantity_variance: variance[sub_dept_name],
        physical_count_retail_value: physical_count_retail_value[sub_dept_name],
        physical_count_cost_value: physical_count_cost_value[sub_dept_name],
        gain_cost_value: gain_cost_value[sub_dept_name],
        gain_retail_value: gain_retail_value[sub_dept_name],
        loss_cost_value: loss_cost_value[sub_dept_name],
        loss_retail_value: loss_retail_value[sub_dept_name],
        gain_loss_value_retail_value: gain_loss_value_retail_value[sub_dept_name],
        gain_loss_value_cost_value: gain_loss_value_cost_value[sub_dept_name],
        updated_at: Time.current,
        created_at: Time.current
      }
    end

    SummaryReport.import reports if reports.present?
  end

  def self.SKUCount
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, COUNT (*) as Cnt FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU WHERE (masters.Stock - document_products.QNT = 0) GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.SKUNoDiff
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, COUNT (*) FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU WHERE (masters.Stock - document_products.QNT = 0) GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.SKUDiffGain
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, COUNT (*) FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU WHERE (masters.Stock - document_products.QNT > 0) GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.SKUDiffLoss
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, COUNT (*) FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU WHERE (masters.Stock - document_products.QNT < 0) GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.SOH
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, SUM(masters.Stock) as SOH FROM masters GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.Physical
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, SUM(document_products.QNT) as physical FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.Over
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, SUM(masters.Stock - document_products.QNT) as over FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU WHERE (masters.Stock - document_products.QNT > 0) GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.Short
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, SUM(masters.Stock - document_products.QNT) as over FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU WHERE (masters.Stock - document_products.QNT < 0) GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.Variance
    result = ActiveRecord::Base.connection.exec_query <<~SQL
      SELECT t1.SubDeptName, (t1.Physical - t2.SOH) as Variance
          FROM (
              SELECT masters.SubDeptName, SUM(document_products.QNT) as Physical FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU GROUP BY masters.SubDeptName
          ) t1 LEFT JOIN (
              SELECT masters.SubDeptName, SUM(masters.Stock) as SOH FROM masters GROUP BY masters.SubDeptName
          ) t2 ON t1.SubDeptName = t2.SubDeptName
    SQL
    result.rows.to_h
  end

  def self.PhysicalCountRetailValue
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, SUM(masters.RetailPrice * document_products.QNT) as physical_count_retail_value FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.PhysicalCountCostValue
    ActiveRecord::Base.connection.exec_query("SELECT masters.SubDeptName, SUM(masters.Cost * document_products.QNT) as physical_count_retail_value FROM document_products LEFT JOIN masters ON masters.SKU = document_products.SKU GROUP BY masters.SubDeptName").rows.to_h
  end

  def self.GainRetailValue
    result = ActiveRecord::Base.connection.exec_query <<~SQL
      WITH msoh (SubDeptName, SOH) AS (
              SELECT SubDeptName
                  , SUM(masters.Stock) as SOH
                FROM masters
              GROUP BY masters.SubDeptName
          )
        , prods (SubDeptName, physical) AS (
              SELECT SubDeptName, SUM(document_products.QNT) as physical
                FROM document_products
                LEFT JOIN masters
                  ON masters.SKU = document_products.SKU
              GROUP BY masters.SubDeptName
          )
        , cte3 AS (
              SELECT msoh.*
                  , prods.*
                  , prods.physical - msoh.SOH AS final
                FROM msoh
                JOIN prods
                  ON msoh.SubDeptName = prods.SubDeptName
          )
      SELECT cte3.SubDeptName, SUM(masters.RetailPrice * cte3.final > 0) as gain_retail_value
        FROM document_products
        JOIN masters
          ON masters.SKU = document_products.SKU
        JOIN cte3
          ON masters.SubDeptName = cte3.SubDeptName
      GROUP BY cte3.SubDeptName;
  SQL
    result.rows.to_h
  end

  def self.GainCostValue
    result = ActiveRecord::Base.connection.exec_query <<~SQL
      WITH msoh (SubDeptName, SOH) AS (
              SELECT SubDeptName
                  , SUM(masters.Stock) as SOH
                FROM masters
              GROUP BY masters.SubDeptName
          )
        , prods (SubDeptName, physical) AS (
              SELECT SubDeptName, SUM(document_products.QNT) as physical
                FROM document_products
                LEFT JOIN masters
                  ON masters.SKU = document_products.SKU
              GROUP BY masters.SubDeptName
          )
        , cte3 AS (
              SELECT msoh.*
                  , prods.*
                  , prods.physical - msoh.SOH AS final
                FROM msoh
                JOIN prods
                  ON msoh.SubDeptName = prods.SubDeptName
          )
      SELECT cte3.SubDeptName, SUM(masters.Cost * cte3.final > 0) as gain_retail_value
        FROM document_products
        JOIN masters
          ON masters.SKU = document_products.SKU
        JOIN cte3
          ON masters.SubDeptName = cte3.SubDeptName
      GROUP BY cte3.SubDeptName;
  SQL
    result.rows.to_h
  end

  def self.LossRetailValue
    result = ActiveRecord::Base.connection.exec_query <<~SQL
      WITH msoh (SubDeptName, SOH) AS (
              SELECT SubDeptName
                  , SUM(masters.Stock) as SOH
                FROM masters
              GROUP BY masters.SubDeptName
          )
        , prods (SubDeptName, physical) AS (
              SELECT SubDeptName, SUM(document_products.QNT) as physical
                FROM document_products
                LEFT JOIN masters
                  ON masters.SKU = document_products.SKU
              GROUP BY masters.SubDeptName
          )
        , cte3 AS (
              SELECT msoh.*
                  , prods.*
                  , prods.physical - msoh.SOH AS final
                FROM msoh
                JOIN prods
                  ON msoh.SubDeptName = prods.SubDeptName
          )
      SELECT cte3.SubDeptName, SUM(masters.RetailPrice * cte3.final < 0) as gain_retail_value
        FROM document_products
        JOIN masters
          ON masters.SKU = document_products.SKU
        JOIN cte3
          ON masters.SubDeptName = cte3.SubDeptName
      GROUP BY cte3.SubDeptName;
  SQL
    result.rows.to_h
  end

  def self.LossCostValue
    result = ActiveRecord::Base.connection.exec_query <<~SQL
      WITH msoh (SubDeptName, SOH) AS (
              SELECT SubDeptName
                  , SUM(masters.Stock) as SOH
                FROM masters
              GROUP BY masters.SubDeptName
          )
        , prods (SubDeptName, physical) AS (
              SELECT SubDeptName, SUM(document_products.QNT) as physical
                FROM document_products
                LEFT JOIN masters
                  ON masters.SKU = document_products.SKU
              GROUP BY masters.SubDeptName
          )
        , cte3 AS (
              SELECT msoh.*
                  , prods.*
                  , prods.physical - msoh.SOH AS final
                FROM msoh
                JOIN prods
                  ON msoh.SubDeptName = prods.SubDeptName
          )
      SELECT cte3.SubDeptName, SUM(masters.Cost * cte3.final < 0) as gain_retail_value
        FROM document_products
        JOIN masters
          ON masters.SKU = document_products.SKU
        JOIN cte3
          ON masters.SubDeptName = cte3.SubDeptName
      GROUP BY cte3.SubDeptName;
  SQL
    result.rows.to_h
  end

  def self.GainLossValueRetailValue
    result = ActiveRecord::Base.connection.exec_query <<~SQL
      WITH msoh (SubDeptName, SOH) AS (
              SELECT SubDeptName
                  , SUM(masters.Stock) as SOH
                FROM masters
              GROUP BY masters.SubDeptName
          )
        , prods (SubDeptName, physical) AS (
              SELECT SubDeptName, SUM(document_products.QNT) as physical
                FROM document_products
                LEFT JOIN masters
                  ON masters.SKU = document_products.SKU
              GROUP BY masters.SubDeptName
          )
        , cte3 AS (
              SELECT msoh.*
                  , prods.*
                  , prods.physical - msoh.SOH AS final
                FROM msoh
                JOIN prods
                  ON msoh.SubDeptName = prods.SubDeptName
          )
      SELECT cte3.SubDeptName, SUM(masters.RetailPrice * cte3.final) as gain_retail_value
        FROM document_products
        JOIN masters
          ON masters.SKU = document_products.SKU
        JOIN cte3
          ON masters.SubDeptName = cte3.SubDeptName
      GROUP BY cte3.SubDeptName;
  SQL
    result.rows.to_h
  end

  def self.GainLossValueCostValue
    result = ActiveRecord::Base.connection.exec_query <<~SQL
      WITH msoh (SubDeptName, SOH) AS (
              SELECT SubDeptName
                  , SUM(masters.Stock) as SOH
                FROM masters
              GROUP BY masters.SubDeptName
          )
        , prods (SubDeptName, physical) AS (
              SELECT SubDeptName, SUM(document_products.QNT) as physical
                FROM document_products
                LEFT JOIN masters
                  ON masters.SKU = document_products.SKU
              GROUP BY masters.SubDeptName
          )
        , cte3 AS (
              SELECT msoh.*
                  , prods.*
                  , prods.physical - msoh.SOH AS final
                FROM msoh
                JOIN prods
                  ON msoh.SubDeptName = prods.SubDeptName
          )
      SELECT cte3.SubDeptName, SUM(masters.Cost * cte3.final) as gain_retail_value
        FROM document_products
        JOIN masters
          ON masters.SKU = document_products.SKU
        JOIN cte3
          ON masters.SubDeptName = cte3.SubDeptName
      GROUP BY cte3.SubDeptName;
  SQL
    result.rows.to_h
  end

  def balance_retail_value
    quantity_physical.to_i - gain_loss_value_retail_value.to_i
  end

  def balance_cost_value
    quantity_physical.to_i - gain_cost_value.to_i
  end

  def spreadsheet_columns
    [
        ["ReportName", 'Summary Report'],
        ["Credit", credit],
        ["SKUCount",ActiveSupport::NumberHelper::number_to_delimited(skucount.to_f.round(3))],
        ["SKUNoDiff", ActiveSupport::NumberHelper::number_to_delimited(sku_no_diff.to_f.round(3))],
        ["SKUDiffGain", ActiveSupport::NumberHelper::number_to_delimited(sku_diff_gain.to_f.round(3))],
        ["SKUDiffLoss", ActiveSupport::NumberHelper::number_to_delimited(sku_diff_loss.to_f.round(3))],
        ["SOH", ActiveSupport::NumberHelper::number_to_delimited(quantity_soh.to_f.round(3))],
        ["Physical", ActiveSupport::NumberHelper::number_to_delimited(quantity_physical.to_f.round(3))],
        ["Over", ActiveSupport::NumberHelper::number_to_delimited(quantity_over.to_f.round(3))],
        ["Short", ActiveSupport::NumberHelper::number_to_delimited(quantity_short.to_f.round(3))],
        ["Variance", ActiveSupport::NumberHelper::number_to_delimited(quantity_variance.to_f.round(3))],
        ["PhysicalCountRetailValue", ActiveSupport::NumberHelper::number_to_delimited(physical_count_retail_value.to_f.round(3))],
        ["PhysicalCountCostValue", ActiveSupport::NumberHelper::number_to_delimited(physical_count_cost_value.to_f.round(3))],
        ["GainRetailValue", ActiveSupport::NumberHelper::number_to_delimited(gain_retail_value.to_f.round(3))],
        ["GainCostValue", ActiveSupport::NumberHelper::number_to_delimited(gain_cost_value.to_f.round(3))],
        ["LossRetailValue", ActiveSupport::NumberHelper::number_to_delimited(loss_retail_value.to_f.round(3))],
        ["LossCostValue", ActiveSupport::NumberHelper::number_to_delimited(loss_cost_value.to_f.round(3))],
        ["Gain-LossRetailValue", ActiveSupport::NumberHelper::number_to_delimited(gain_loss_value_retail_value.to_f.round(3))],
        ["Gain-LossCostValue", ActiveSupport::NumberHelper::number_to_delimited(gain_loss_value_cost_value.to_f.round(3))]
    ]
  end
end
