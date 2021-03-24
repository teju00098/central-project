class AddMasterIdToZeroCountReports < ActiveRecord::Migration[6.0]
  def change
    add_column :zero_count_reports, :master_id, :bigint
  end
end
