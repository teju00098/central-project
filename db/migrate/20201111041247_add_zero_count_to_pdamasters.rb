class AddZeroCountToPdamasters < ActiveRecord::Migration[6.0]
  def change
    add_column :pdamasters, :ZeroCount, :boolean, default: false
    add_index :pdamasters, :ZeroCount
    add_index :pdamasters, :HasCount
    add_index :pdamasters, :DeptName
  end
end
