class AddDeptnameToSummaryReports < ActiveRecord::Migration[6.0]
  def change
    add_column :summary_reports, :DeptName, :string
  end
end
