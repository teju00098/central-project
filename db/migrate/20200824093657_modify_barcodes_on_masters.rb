class ModifyBarcodesOnMasters < ActiveRecord::Migration[6.0]
  def change
    10.times do |n|
      remove_column :masters, "Barcode#{n+1}", :string
    end
    add_column :masters, :BarcodeSBC, :string
  end
end
