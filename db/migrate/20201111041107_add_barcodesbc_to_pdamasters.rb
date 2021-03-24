class AddBarcodesbcToPdamasters < ActiveRecord::Migration[6.0]
  def change
    add_column :pdamasters, :BarcodeSBC, :string
  end
end
