class AddKindToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :kind, :string
  end
end
