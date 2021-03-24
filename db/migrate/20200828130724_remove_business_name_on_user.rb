class RemoveBusinessNameOnUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :business_name, :string
    remove_column :users, :business_unit, :string
  end
end
