class AddCountStausToPdamasters < ActiveRecord::Migration[6.0]
  def change
    add_column :pdamasters, :HasCount, :boolean, default: false
  end
end
