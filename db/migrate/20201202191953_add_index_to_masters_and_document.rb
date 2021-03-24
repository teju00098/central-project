class AddIndexToMastersAndDocument < ActiveRecord::Migration[6.0]
  def change
    add_index :masters, :QNT
    add_index :masters, :Stock
    add_index :masters, :RetailPrice
    add_index :masters, :SubDeptName
    add_index :masters, :Cost
    add_index :masters, :SKU
    add_index :document_products, :SKU
  end
end
