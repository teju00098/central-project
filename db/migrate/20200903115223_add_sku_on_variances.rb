class AddSkuOnVariances < ActiveRecord::Migration[6.0]
  def change
    add_column :variances, :SKU, :string
    add_column :document_products, :filename, :string
    add_column :uploaded_documents, :filename, :string
  end
end
