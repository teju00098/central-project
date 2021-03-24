class AddExtraFieldsToVarianceMasterReports < ActiveRecord::Migration[6.0]
  def change
    add_column :variance_master_reports, :LOCATION, :string
    add_column :variance_master_reports, :BARCODE, :string
    add_column :variance_master_reports, :SKU, :string
  end
end
