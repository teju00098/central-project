class AddPlainPasswordToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :plain_password, :string
  end
end
