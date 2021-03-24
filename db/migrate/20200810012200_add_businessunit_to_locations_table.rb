class AddBusinessunitToLocationsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :businessunit, :string
  end
end
