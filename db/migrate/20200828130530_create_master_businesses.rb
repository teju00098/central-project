class CreateMasterBusinesses < ActiveRecord::Migration[6.0]
  def change
    create_table :master_businesses do |t|
      t.string :business_name
      t.string :business_unit
      t.string :import_filename
      t.integer :user_id
      t.timestamps
    end
  end
end
