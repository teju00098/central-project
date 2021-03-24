class Location < ApplicationRecord
  require "csv"
  def self.import(file)
    h = CSV.open(file, headers: :first_row).map { |row|
      row.map { |key, val| [key.downcase, val] }.to_h.transform_keys { |key| key == "type" ? "kind" : key }.merge(created_at: DateTime.now, updated_at: DateTime.now)
    }
    truncate_table("locations") if h.present?
    Location.insert_all!(h)
  end
end
