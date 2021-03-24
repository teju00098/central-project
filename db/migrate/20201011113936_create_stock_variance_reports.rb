class CreateStockVarianceReports < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_variance_reports do |t|
      t.float      :CountQTY, default: 0
      t.float      :VarianceQTY, default: 0
      t.float      :VariancePercent, defaul: 0
      t.float      :EXTPHY_RETAIL, default: 0
      t.float      :EXTPHY_COST, default: 0
      t.float      :EXTPHY_RETAILVAR, default: 0
      t.float      :EXTPHY_COSTVAR, default: 0
      t.references :document_product, foreign_key: true
      t.references :master_business, foreign_key: true
      t.references :master, foreign_key: true
      t.references :uploaded_document, foreign_key: true
      t.timestamps
    end
  end
end
