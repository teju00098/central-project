class CreateSummaryReports < ActiveRecord::Migration[6.0]
  def change
    create_table :summary_reports do |t|
      t.string :credit
      t.string :skucount
      t.string :sku_no_diff
      t.string :sku_diff_gain
      t.string :sku_diff_loss
      t.string :quantity_soh
      t.string :quantity_physical
      t.string :quantity_over
      t.string :quantity_short
      t.string :quantity_variance
      t.string :extphycnt_retail
      t.string :extphycnt_cost
      t.string :extphy_retailvar
      t.string :extphy_costvar
      t.string :extphycnt_retail_exvat
      t.string :physical_count_retail_value
      t.string :physical_count_cost_value
      t.string :gain_retail_value
      t.string :gain_cost_value
      t.string :loss_retail_value
      t.string :loss_cost_value
      t.string :gain_loss_value_retail_value
      t.string :gain_loss_value_cost_value

      t.timestamps
    end
  end
end
