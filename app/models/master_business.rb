class MasterBusiness < ApplicationRecord

  belongs_to :user, optional: true

  def self.create_or_update(params)
    (first || new).tap do |r|
      r.business_name = params[:name]
      r.business_unit = params[:unit]
      r.user_id = params[:user_id]
      r.import_filename = params[:filename]
      r.save
    end
  end

end
