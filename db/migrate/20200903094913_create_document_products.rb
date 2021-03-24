class CreateDocumentProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :document_products do |t|
      t.string  :rowid
      t.string  :StockTakeID
      t.string  :DocNum
      t.string  :Inspector
      t.string  :SEQ
      t.string  :Location
      t.string  :SKU
      t.string  :Barcode
      t.string  :IBC
      t.string  :SBC
      t.string  :ProductName
      t.decimal :QNT
      t.decimal :SalePrice
      t.string  :DateTime
      t.timestamps
    end
  end
end
