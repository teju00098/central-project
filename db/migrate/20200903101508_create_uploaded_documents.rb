class CreateUploadedDocuments < ActiveRecord::Migration[6.0]
  def change
    drop_table :uploaded_documents rescue nil
    create_table :uploaded_documents do |t|
      t.string  :docnum
      t.string  :inspector_name
      t.timestamps
    end
  end
end
