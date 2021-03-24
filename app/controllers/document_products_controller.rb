class DocumentProductsController < ApplicationController

  def upload_histories
    @upload_histories = UploadedDocument.all.paginate(page: params[:page], per_page: 200)
  end

  def bulk_import
    DocumentProductBulkJob.new.perform(nil, true)
    VarianceMasterReport.regenerate!
    flash[:notice] = "Upload is processed in background job"
    redirect_to request.referrer
  end

  def removedata
    # ActiveRecord::Base.connection.execute("DELETE FROM masters")
    StockVarianceReport.truncate_table("stock_variance_reports")
    DocumentProduct.truncate_table("document_products")
    UploadedDocument.truncate_table("uploaded_documents")
    redirect_to upload_histories_document_products_path
  end

end
