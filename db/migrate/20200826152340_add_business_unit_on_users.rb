class AddBusinessUnitOnUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :business_unit, :string
    add_column :users, :business_name, :string
  end
end
