class AddSubdeptnameToSummaryReports < ActiveRecord::Migration[6.0]
  def change
    add_column :summary_reports, :SubDeptName, :string
  end
end
