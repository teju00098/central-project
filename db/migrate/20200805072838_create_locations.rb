class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :location
      t.string :zone
      t.string :type
      t.string :dept
      t.string :subdept

      t.timestamps
    end
  end
end
