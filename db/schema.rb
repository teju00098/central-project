# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_16_034245) do

  create_table "document_products", force: :cascade do |t|
    t.string "rowid"
    t.string "StockTakeID"
    t.string "DocNum"
    t.string "Inspector"
    t.string "SEQ"
    t.string "Location"
    t.string "SKU"
    t.string "Barcode"
    t.string "IBC"
    t.string "SBC"
    t.string "ProductName"
    t.decimal "QNT"
    t.decimal "SalePrice"
    t.string "DateTime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "filename"
    t.index ["Barcode"], name: "index_document_products_on_Barcode"
    t.index ["DocNum", "Inspector"], name: "product_docnum_inspector"
    t.index ["SKU"], name: "index_document_products_on_SKU"
  end

  create_table "locations", force: :cascade do |t|
    t.string "location"
    t.string "zone"
    t.string "name"
    t.string "dept"
    t.string "subdept"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "businessunit"
    t.string "kind"
  end

  create_table "master_businesses", force: :cascade do |t|
    t.string "business_name"
    t.string "business_unit"
    t.string "import_filename"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "masters", force: :cascade do |t|
    t.string "CountName"
    t.string "StoreCode"
    t.string "StoreName"
    t.string "VenderCode"
    t.string "VenderName"
    t.string "DeptCode"
    t.string "DeptName"
    t.string "SubDeptCode"
    t.string "SubDeptName"
    t.string "Class"
    t.string "ClassName"
    t.string "SubClass"
    t.string "SubClassName"
    t.string "SKUType"
    t.string "SpecialAttribute"
    t.string "SKU"
    t.string "BarcodeIBC"
    t.string "ProductName"
    t.string "Brand"
    t.string "Model"
    t.string "UnitOfMeasure"
    t.decimal "Stock"
    t.decimal "PackSize"
    t.decimal "Cost"
    t.decimal "RetailPrice"
    t.string "Status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "BarcodeSBC"
    t.string "filename"
    t.boolean "HasCount", default: false
    t.boolean "ZeroCount", default: false
    t.index ["Cost"], name: "index_masters_on_Cost"
    t.index ["DeptName"], name: "index_masters_on_DeptName"
    t.index ["HasCount"], name: "index_masters_on_HasCount"
    t.index ["RetailPrice"], name: "index_masters_on_RetailPrice"
    t.index ["SKU"], name: "index_masters_on_SKU"
    t.index ["Stock"], name: "index_masters_on_Stock"
    t.index ["SubDeptName"], name: "index_masters_on_SubDeptName"
    t.index ["ZeroCount"], name: "index_masters_on_ZeroCount"
  end

  create_table "pdamaster_businesses", force: :cascade do |t|
    t.string "business_name"
    t.string "business_unit"
    t.string "import_filename"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pdamasters", force: :cascade do |t|
    t.string "CountName"
    t.string "StoreCode"
    t.string "StoreName"
    t.integer "VenderCode"
    t.string "VenderName"
    t.integer "DeptCode"
    t.string "DeptName"
    t.integer "SubDeptCode"
    t.string "SubDeptName"
    t.integer "Class"
    t.string "ClassName"
    t.integer "SubClass"
    t.string "SubClassName"
    t.string "SKUType"
    t.string "SpecialAttribute"
    t.string "SKU"
    t.string "BarcodeIBC"
    t.string "Barcode1"
    t.string "Barcode2"
    t.string "Barcode3"
    t.string "Barcode4"
    t.string "Barcode5"
    t.string "Barcode6"
    t.string "Barcode7"
    t.string "Barcode8"
    t.string "Barcode9"
    t.string "Barcode10"
    t.string "ProductName"
    t.string "Brand"
    t.string "Model"
    t.string "UnitOfMeasure"
    t.decimal "Stock"
    t.decimal "PackSize"
    t.decimal "Cost"
    t.decimal "RetailPrice"
    t.string "Status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "filename"
    t.string "BarcodeSBC"
    t.boolean "ZeroCount", default: false
    t.boolean "HasCount", default: false
    t.index ["DeptName"], name: "index_pdamasters_on_DeptName"
    t.index ["HasCount"], name: "index_pdamasters_on_HasCount"
    t.index ["ZeroCount"], name: "index_pdamasters_on_ZeroCount"
  end

  create_table "performance_reports", force: :cascade do |t|
    t.string "manday"
    t.string "avg_qty"
    t.string "total_qty"
    t.string "date"
    t.string "time"
    t.string "count_name"
    t.string "bu"
    t.string "store_code"
    t.string "store_name"
    t.string "pda_mac_no"
    t.string "inspector"
    t.string "start"
    t.string "finish"
    t.string "total"
    t.string "location"
    t.string "sku"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stock_variance_reports", force: :cascade do |t|
    t.float "CountQTY", default: 0.0
    t.float "VarianceQTY", default: 0.0
    t.float "VariancePercent"
    t.float "EXTPHY_RETAIL", default: 0.0
    t.float "EXTPHY_COST", default: 0.0
    t.float "EXTPHY_RETAILVAR", default: 0.0
    t.float "EXTPHY_COSTVAR", default: 0.0
    t.integer "document_product_id"
    t.integer "master_business_id"
    t.integer "master_id"
    t.integer "uploaded_document_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "SKU"
    t.index ["document_product_id"], name: "index_stock_variance_reports_on_document_product_id"
    t.index ["master_business_id"], name: "index_stock_variance_reports_on_master_business_id"
    t.index ["master_id"], name: "index_stock_variance_reports_on_master_id"
    t.index ["uploaded_document_id"], name: "index_stock_variance_reports_on_uploaded_document_id"
  end

  create_table "summary_reports", force: :cascade do |t|
    t.string "credit"
    t.string "skucount"
    t.string "sku_no_diff"
    t.string "sku_diff_gain"
    t.string "sku_diff_loss"
    t.string "quantity_soh"
    t.string "quantity_physical"
    t.string "quantity_over"
    t.string "quantity_short"
    t.string "quantity_variance"
    t.string "extphycnt_retail"
    t.string "extphycnt_cost"
    t.string "extphy_retailvar"
    t.string "extphy_costvar"
    t.string "extphycnt_retail_exvat"
    t.string "physical_count_retail_value"
    t.string "physical_count_cost_value"
    t.string "gain_retail_value"
    t.string "gain_cost_value"
    t.string "loss_retail_value"
    t.string "loss_cost_value"
    t.string "gain_loss_value_retail_value"
    t.string "gain_loss_value_cost_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "SubDeptName"
    t.string "DeptName"
  end

  create_table "uploaded_documents", force: :cascade do |t|
    t.string "docnum"
    t.string "inspector_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "filename"
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "plain_password"
    t.string "username"
    t.string "type"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variance_master_reports", force: :cascade do |t|
    t.integer "variance_id"
    t.integer "master_id"
    t.float "QNT", default: 0.0
    t.float "STOCK", default: 0.0
    t.float "VarianceDiff", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "VarianceCost"
    t.string "LOCATION"
    t.string "BARCODE"
    t.string "SKU"
    t.index ["master_id"], name: "index_variance_master_reports_on_master_id"
    t.index ["variance_id"], name: "index_variance_master_reports_on_variance_id"
  end

  create_table "variance_reports", force: :cascade do |t|
    t.integer "difference", default: 0
    t.integer "variance_id"
    t.integer "document_product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["document_product_id"], name: "index_variance_reports_on_document_product_id"
    t.index ["variance_id"], name: "index_variance_reports_on_variance_id"
  end

  create_table "variances", force: :cascade do |t|
    t.string "BARCODE"
    t.string "LOCATION"
    t.decimal "QUANTITY"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_count", default: false
    t.string "SKU"
    t.index ["SKU", "LOCATION"], name: "index_variances_on_SKU_and_Location"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "zero_count_reports", force: :cascade do |t|
    t.string "DeptName"
    t.string "SubDeptName"
    t.string "Location"
    t.string "SKU"
    t.string "IBC"
    t.string "SBC"
    t.string "ProductName"
    t.string "Brand"
    t.string "Model"
    t.float "Stock"
    t.float "Cost"
    t.integer "QNT"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "master_id"
  end

  add_foreign_key "stock_variance_reports", "document_products"
  add_foreign_key "stock_variance_reports", "master_businesses"
  add_foreign_key "stock_variance_reports", "masters"
  add_foreign_key "stock_variance_reports", "uploaded_documents"
  add_foreign_key "variance_master_reports", "masters"
  add_foreign_key "variance_master_reports", "variances"
  add_foreign_key "variance_reports", "document_products"
  add_foreign_key "variance_reports", "variances"
end
