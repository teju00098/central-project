module ApplicationHelper

  def master_business
    @master_business ||= MasterBusiness.first || MasterBusiness.new
  end

  def display_barcode(barcode_value)
    return if barcode_value.nil?

    require 'chunky_png'
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/png_outputter'

    Barby::Code128B.new(barcode_value).to_image(height: 15, margin: 5).to_data_url
  end
end
