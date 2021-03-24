class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.truncate_table(tbl_name)
    begin
      connection.execute("DELETE FROM #{tbl_name}") 
    rescue
      connection.execute("PRAGMA defer_foreign_keys = OFF")
      connection.execute("PRAGMA foreign_keys = OFF")
      connection.execute("DELETE FROM #{tbl_name}")
      connection.execute("PRAGMA defer_foreign_keys = ON")
      connection.execute("PRAGMA foreign_keys = ON")
    end
  end
end
