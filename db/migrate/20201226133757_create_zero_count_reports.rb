class CreateZeroCountReports < ActiveRecord::Migration[6.0]
  def change
    create_table :zero_count_reports do |t|
      t.string :DeptName
      t.string :SubDeptName
      t.string :Location
      t.string :SKU
      t.string :IBC
      t.string :SBC
      t.string :ProductName
      t.string :Brand
      t.string :Model
      t.float :Stock
      t.float :Cost
      t.integer :QNT

      t.timestamps
    end
  end
end
