class AddVarianceCostToVarianceMasterReports < ActiveRecord::Migration[6.0]
  def change
    add_column :variance_master_reports, :VarianceCost, :decimal
  end
end
