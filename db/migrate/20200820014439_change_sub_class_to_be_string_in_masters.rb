class ChangeSubClassToBeStringInMasters < ActiveRecord::Migration[6.0]
  def change
    change_column :masters, :SubClass, :string
  end
end
