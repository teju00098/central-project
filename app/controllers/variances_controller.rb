class VariancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variance, only: [:show, :edit, :update, :destroy, :history]

  # GET /variances
  # GET /variances.json
  def index
    @variances = Variance.all.paginate(page: params[:page], per_page: 100)
    if params[:export].to_i == 1
      render xlsx: @variances.to_xlsx
    end
  end

  # GET /variances/1
  # GET /variances/1.json
  def show
  end

  # GET /variances/new
  def new
    @variance = Variance.new
  end

  # GET /variances/1/edit
  def edit
  end

  def search
    @variances = if params[:search].blank?
      Variance.all.paginate(page: params[:page], per_page: 200)
    else
      Variance.search(params)
    end
  end

  # POST /variances
  # POST /variances.json
  def create
    @variance = Variance.new(variance_params)

    respond_to do |format|
      if @variance.save
        format.html { redirect_to @variance, notice: 'Variance was successfully created.' }
        format.json { render :show, status: :created, location: @variance }
      else
        format.html { render :new }
        format.json { render json: @variance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variances/1
  # PATCH/PUT /variances/1.json
  def update
    respond_to do |format|
      if @variance.update(variance_params)
        format.html { redirect_to @variance, notice: 'Variance was successfully updated.' }
        format.json { render :show, status: :ok, location: @variance }
      else
        format.html { render :edit }
        format.json { render json: @variance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variances/1
  # DELETE /variances/1.json
  def destroy
    @variance.destroy
    respond_to do |format|
      format.html { redirect_to variances_url, notice: 'Variance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    Variance.import(params[:file])
    redirect_to variances_path, notice: "Variance data added successfully !!"
  end

  def history
    @variances = @variance.versions.reverse
  end

  def cleardata
    # ActiveRecord::Base.connection.execute("DELETE FROM masters")
    Variance.truncate_table("variances")
    redirect_to variances_path
  end

  def stock_report
    if params[:regenerate].to_i == 1
      StockVarianceReport.regenerate!
      prepare_stock_report
      @departements = Master.where('id IN (?)', @records.distinct('master_id').pluck('master_id')).distinct('DeptName').pluck('DeptName')
      @records = @records.includes(:master, :document_product, :uploaded_document).paginate(page: params[:page], per_page: 200)
    elsif params[:print].to_i == 1
      redirect_to stock_report_print_variances_path(dept: params[:dept])
    else
      prepare_stock_report
      @departements = Master.where('id IN (?)', @records.distinct('master_id').pluck('master_id')).distinct('DeptName').pluck('DeptName')
      @records = @records.includes(:master, :document_product, :uploaded_document).paginate(page: params[:page], per_page: 200)
    end

    if params[:export].to_i == 1
      render xlsx: @records.to_xlsx
    end
  end

  def stock_report_print
    prepare_stock_report
    render layout: false
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variance
      @variance = Variance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def variance_params
      params.require(:variance).permit(:BARCODE, :LOCATION, :QUANTITY)
    end

    def prepare_stock_report
      @records = StockVarianceReport.includes(:document_product, :master_business, :master, :uploaded_document)
      if params[:dept].present?
        @records = @records.where(masters: { DeptName: params[:dept] })
      end
    end
end
