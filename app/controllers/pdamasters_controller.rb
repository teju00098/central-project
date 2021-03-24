class PdamastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_master, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: :prepare_import

  # GET /masters
  # GET /masters.json
  def index
    @masters = Pdamaster.all.paginate(page: params[:page], per_page: 200)
  end

  # GET /masters/1
  # GET /masters/1.json
  def show
  end

  # GET /masters/new
  def new
    @master = Pdamaster.new
  end

  # GET /masters/1/edit
  def edit
  end

  def search
    @masters = if params[:search].blank?
      Pdamaster.all.paginate(page: params[:page], per_page: 200)
    else
      Pdamaster.search(params)
    end
  end

  # POST /masters
  # POST /masters.json
  def create
    @master = Pdamaster.new(master_params)

    respond_to do |format|
      if @master.save
        format.html { redirect_to @master, notice: "Pdamaster was successfully created." }
        format.json { render :show, status: :created, location: @master }
      else
        format.html { render :new }
        format.json { render json: @master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /masters/1
  # PATCH/PUT /masters/1.json
  def update
    respond_to do |format|
      if @master.update(master_params)
        format.html { redirect_to @master, notice: "Pdamaster was successfully updated." }
        format.json { render :show, status: :ok, location: @master }
      else
        format.html { render :edit }
        format.json { render json: @master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /masters/1
  # DELETE /masters/1.json
  def destroy
    @master.destroy
    respond_to do |format|
      format.html { redirect_to pdamasters_url, notice: "Pdamaster was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    if params[:name].present? && params[:unit].present?
      PdamasterBusiness.create_or_update({
        name: params[:name],
        unit: params[:unit],
        user_id: current_user.id,
        filename: File.basename(params[:file])
      })
    end

    Pdamaster.import(params[:file])
    redirect_to pdamasters_path, notice: "Pdamaster data added successfully !!"
  end

  def cleardata
    # ActiveRecord::Base.connection.execute("DELETE FROM masters")
    Pdamaster.truncate_table("pdamasters")
    redirect_to pdamasters_path
  end

  def prepare_import
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def no_counts
    if params[:print].to_i == 1
      redirect_to no_counts_print_pdamasters_path(dept: params[:dept])
    else
      prepare_no_counts
      @departements = Pdamaster.where(HasCount: false).distinct("DeptName").pluck("DeptName")
      @no_counts = @no_counts.paginate(page: params[:page], per_page: 200)
    end
  end

  def performance_report
    if params[:print].to_i == 1
      redirect_to performance_report_print_pdamasters_path(dept: params[:dept])
    else
      @departements = Pdamaster.where(HasCount: false).distinct("DeptName").pluck("DeptName")
      @performance_reports = PerformanceReport.all.paginate(page: params[:page], per_page: 200)
    end
  end

  def performance_report_print
    @total_value = PerformanceReport.sum(:value).to_f.round(2)
    @total_qty = PerformanceReport.sum(:total_qty).to_i
    @total_sku = PerformanceReport.sum(:sku).to_i
    @total_inspectors = DocumentProduct.distinct.count(:Inspector)
    @earliest_time = DateTime.parse(DocumentProduct.select("min(DateTime) as DateTime").first.DateTime).strftime("%I:%M %p")
    @latest_time = DateTime.parse(DocumentProduct.select("max(DateTime) as DateTime").first.DateTime).strftime("%I:%M %p")
    @master = Pdamaster.find_by(DeptName: params[:dept])
    @master_business = PdamasterBusiness.find_by(user_id: current_user.id)
    @performance_reports = PerformanceReport.all.paginate(page: params[:page], per_page: 200)
    render layout: false
  end

  def no_counts_print
    prepare_no_counts
    render layout: false
  end

  def zero_counts
    if params[:print].to_i == 1
      redirect_to zero_counts_print_pdamasters_path(dept: params[:dept])
    else
      prepare_zero_counts
      @departements = Pdamaster.where(ZeroCount: true).distinct("DeptName").pluck("DeptName")
      @zero_counts = @zero_counts.paginate(page: params[:page], per_page: 200)
    end
  end

  def zero_counts_print
    prepare_zero_counts
    render layout: false
  end

  def variances
    if params[:print].to_i == 1
      redirect_to variances_print_pdamasters_path(dept: params[:dept])
    else
      prepare_variances
      @departements = Pdamaster.where("id IN (?)", @variances.distinct("master_id").pluck("master_id")).distinct("DeptName").pluck("DeptName")
      @variances = @variances.includes(:master, :variance).paginate(page: params[:page], per_page: 200)
    end
  end

  def variances_print
    prepare_variances
    render layout: false
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_master
    @master = Pdamaster.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def master_params
    params.require(:master).permit(:CountName, :StoreCode, :StoreName, :VenderCode, :VenderName, :DeptCode, :DeptName, :SubDeptCode, :SubDeptName, :Class, :ClassName, :SubClass, :SubClassName, :SKUType, :SpecialAttribute, :SKU, :BarcodeIBC, :BarcodeSBC, :Barcode1, :Barcode2, :Barcode3, :Barcode4, :Barcode5, :Barcode6, :Barcode7, :Barcode8, :Barcode9, :Barcode10, :ProductName, :Brand, :Model, :UnitOfMeasure, :Stock, :PackSize, :Cost, :RetailPrice, :Status)
  end

  def prepare_no_counts
    @no_counts = Pdamaster.where(HasCount: false)
    if params[:dept].present?
      @no_counts = @no_counts.where(DeptName: params[:dept])
    end
  end

  def prepare_zero_counts
    @zero_counts = Pdamaster.where(ZeroCount: true)
    if params[:dept].present?
      @zero_counts = @zero_counts.where(DeptName: params[:dept])
    end
  end

  def prepare_variances
    @variances = VariancePdamasterReport.all
    if params[:dept].present?
      master_ids = Pdamaster.where(DeptName: params[:dept]).pluck(:id)
      @variances = @variances.where("master_id IN (?)", master_ids)
    end
  end
end
