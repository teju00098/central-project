class ModifyColumnsOnVariances < ActiveRecord::Migration[6.0]
  def change
    add_column :variances, :is_count, :boolean, default: false
    add_index  :document_products, [:DocNum, :Inspector], name: 'product_docnum_inspector'
    add_index  :document_products, :Barcode
    add_index  :variances, [:SKU, :Location]
  end
end
