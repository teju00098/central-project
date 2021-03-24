class CreateVarianceReports < ActiveRecord::Migration[6.0]
  def change
    create_table :variance_reports do |t|
      t.integer    :difference, default: 0
      t.references :variance, foreign_key: true
      t.references :document_product, foreign_key: true
      t.timestamps
    end
  end
end
