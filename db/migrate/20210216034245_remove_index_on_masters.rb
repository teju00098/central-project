class RemoveIndexOnMasters < ActiveRecord::Migration[6.0]
  def change
    remove_index :QNT, name: "index_masters_on_QNT"
  end
end
