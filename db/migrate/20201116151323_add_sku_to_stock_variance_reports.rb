class AddSkuToStockVarianceReports < ActiveRecord::Migration[6.0]
  def change
    add_column :stock_variance_reports, :SKU, :string
  end
end
