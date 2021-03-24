class CreateVarianceMasterReports < ActiveRecord::Migration[6.0]
  def change
    create_table :variance_master_reports do |t|
      t.references :variance, foreign_key: true
      t.references :master, foreign_key: true
      t.float :QNT, default: 0
      t.float :STOCK, default: 0
      t.float :VarianceDiff, default: 0
      t.timestamps
    end
  end
end
