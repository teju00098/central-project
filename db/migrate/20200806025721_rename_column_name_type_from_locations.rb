class RenameColumnNameTypeFromLocations < ActiveRecord::Migration[6.0]
  def change
    rename_column :locations, :type, :name
  end
end
