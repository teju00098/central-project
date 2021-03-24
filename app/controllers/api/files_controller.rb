class Api::FilesController < ApiController
  # if authentication is not needed, just disable it
  # before_action :authenticate_access

  def download_db
    db_path = "#{Rails.root}/#{ActiveRecord::Base.connection_config[:database]}"
    send_file db_path, type: "application/octet-stream", disposition: "attachment"
  end

  # POST /api/files/upload_csv
  # Parameter:
  #  file: file upload
  #  type: value is master, variance or product
  # Respond:
  #  {success: 1}
  def upload_csv
    if params[:file].present?
      case params[:type]
      when "variance"
        Variance.import(params[:file])
      when "master"
        Master.import(params[:file])
      when "pdamaster"
        Pdamaster.import(params[:file])
      when "product"
        DocumentProduct.import(params[:file])
      end
    end
    render json: {success: 1}
  end

  # GET /api/files/verify_upload?type=master&value=123456
  # Responds: {exist: true}
  def verify_upload
    if params[:value].present?
      case params[:type]
      when "variance"
        render json: {exist: Variance.where(BARCODE: params[:value]).exists?}
      when "master"
        render json: {exist: Master.where(CountName: params[:value]).exists?}
      else
        render json: {exist: false}
      end
    end
  end
end
