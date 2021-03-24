class ChangeSubDeptCodeToBeStringInMasters < ActiveRecord::Migration[6.0]
  def change
    change_column :masters, :SubDeptCode, :string
  end
end
