class AddFilenameOnMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :filename, :string
  end
end
