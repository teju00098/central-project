class AddZeroCountOnMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :ZeroCount, :boolean, default: false
    add_index :masters, :ZeroCount
    add_index :masters, :HasCount
    add_index :masters, :DeptName
  end
end
