class ChangeVendorCodeToBeStringInMasters < ActiveRecord::Migration[6.0]
  def change
    change_column :masters, :VenderCode, :string
  end
end
