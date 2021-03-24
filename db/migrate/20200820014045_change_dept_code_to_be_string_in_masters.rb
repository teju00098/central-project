class ChangeDeptCodeToBeStringInMasters < ActiveRecord::Migration[6.0]
  def change
    change_column :masters, :DeptCode, :string
  end
end
