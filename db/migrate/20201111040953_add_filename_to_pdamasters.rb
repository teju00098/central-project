class AddFilenameToPdamasters < ActiveRecord::Migration[6.0]
  def change
    add_column :pdamasters, :filename, :string
  end
end
