class CreateVariances < ActiveRecord::Migration[6.0]
  def change
    create_table :variances do |t|
      t.string :BARCODE
      t.string :LOCATION
      t.decimal :QUANTITY

      t.timestamps
    end
  end
end
