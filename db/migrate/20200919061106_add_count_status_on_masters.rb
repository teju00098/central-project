class AddCountStatusOnMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :HasCount, :boolean, default: false
  end
end
