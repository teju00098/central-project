class CreateMasters < ActiveRecord::Migration[6.0]
  def change
    create_table :masters do |t|
      t.string :CountName
      t.string :StoreCode
      t.string :StoreName
      t.integer :VenderCode
      t.string :VenderName
      t.integer :DeptCode
      t.string :DeptName
      t.integer :SubDeptCode
      t.string :SubDeptName
      t.integer :Class
      t.string :ClassName
      t.integer :SubClass
      t.string :SubClassName
      t.string :SKUType
      t.string :SpecialAttribute
      t.string :SKU
      t.string :BarcodeIBC
      t.string :Barcode1
      t.string :Barcode2
      t.string :Barcode3
      t.string :Barcode4
      t.string :Barcode5
      t.string :Barcode6
      t.string :Barcode7
      t.string :Barcode8
      t.string :Barcode9
      t.string :Barcode10
      t.string :ProductName
      t.string :Brand
      t.string :Model
      t.string :UnitOfMeasure
      t.decimal :Stock
      t.decimal :PackSize
      t.decimal :Cost
      t.decimal :RetailPrice
      t.string :Status

      t.timestamps
    end
  end
end
