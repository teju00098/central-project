class ChangeClassToBeStringInMasters < ActiveRecord::Migration[6.0]
  def change
    change_column :masters, :Class, :string
  end
end
