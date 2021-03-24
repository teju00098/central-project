class CreatePerformanceReports < ActiveRecord::Migration[6.0]
  def change
    create_table :performance_reports do |t|
      # 1. Manday = total number of inspectors in document_products table
      # 2. Avg/QTY = total QTY / total inspectors
      # 3. QTY = is the total qty
      # 4. Value = is the total value
      # 5. Date = of the report generation
      # 6. Time = earliest and last time from the document_products table DateTime column
      # 7. CountName = is from master table
      # 8. BU = is from the setup page
      # 9. Store Code = from the master table
      # 10. Store Name = from the master table
      # 11. PDA MAC/NO = is from the document products table DocNum column for example
      # If the DocNum is Q001040CBBF53202008270005 then the MAC/NO will be Q (001040CBBF53) 202008270005 from digit 2 to 13 will be the MAC/NO
      # Separate every two digits with a colon 00:10:40:CB:BF:53
      # 12. Inspector = is all the different inspector names from document_products table
      # 13. Start = is the earliest time from the DateTime column in document_products table for each inspector
      # 14. Finish = is the last time from the DateTime column in document_products table for each inspector
      # 15. Total = is the difference between the finish and the start time
      # 16. Zone = no need of this column
      # 17. Location = number of different locations for each inspector from the document_products table
      # 18. SKU = total number of different SKU of each inspector
      # 19. QTY = is the total QTY of each inspector from document_products table
      # 20. Value = is QTY * sale price from the document_products table. For each inspector calculate all QTY * sale for all the items and add the total to show value

      t.string :manday
      t.string :avg_qty
      t.string :total_qty
      t.string :date
      t.string :time
      t.string :count_name
      t.string :bu
      t.string :store_code
      t.string :store_name
      t.string :pda_mac_no
      t.string :inspector
      t.string :start
      t.string :finish
      t.string :total
      t.string :location
      t.string :sku
      t.string :value

      t.timestamps
    end
  end
end
