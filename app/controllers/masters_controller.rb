class MastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_master, only: [:show, :edit, :update, :destroy]
  before_action :set_columns, only: [:variances]
  protect_from_forgery except: :prepare_import

  # GET /masters
  # GET /masters.json
  def index
    @masters = Master.all.paginate(page: params[:page], per_page: 200)
  end

  # GET /masters/1
  # GET /masters/1.json
  def show
  end

  # GET /masters/new
  def new
    @master = Master.new
  end

  # GET /masters/1/edit
  def edit
  end

  def search
    @masters = if params[:search].blank?
                 Master.all.paginate(page: params[:page], per_page: 200)
               else
                 Master.search(params)
               end
  end

  # POST /masters
  # POST /masters.json
  def create
    @master = Master.new(master_params)

    respond_to do |format|
      if @master.save
        format.html { redirect_to @master, notice: "Master was successfully created." }
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
        format.html { redirect_to @master, notice: "Master was successfully updated." }
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
      format.html { redirect_to masters_url, notice: "Master was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    if params[:name].present? && params[:unit].present?
      MasterBusiness.create_or_update({
                                          name: params[:name],
                                          unit: params[:unit],
                                          user_id: current_user.id,
                                          filename: File.basename(params[:file])
                                      })
    end

    Master.import(params[:file])
    redirect_to masters_path, notice: "Master data added successfully !!"
  end

  def cleardata
    # ActiveRecord::Base.connection.execute("DELETE FROM masters")
    Master.truncate_table("masters")
    redirect_to masters_path
  end

  def prepare_import
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def no_counts
    @departements = Master.where(HasCount: false).distinct("DeptName").pluck("DeptName")
    if params[:regenerate].to_i == 1
      Master.update_no_counts!
    elsif params[:print].to_i == 1
      redirect_to no_counts_print_masters_path(dept: params[:dept])
    end
    prepare_no_counts

    if params[:export].to_i == 1
      render xlsx: @no_counts.to_xlsx
    else
      @no_counts = @no_counts.paginate(page: params[:page], per_page: 200)
    end
  end

  def performance_report
    prepare_performance_report
    if params[:regenerate].to_i == 1
      PerformanceReport.regenerate!
      @inspectors = PerformanceReport.pluck(:inspector)
    elsif params[:print].to_i == 1
      redirect_to performance_report_print_masters_path(inspector: params[:inspector])
    else
      @inspectors = PerformanceReport.pluck(:inspector)
    end
    if params[:export].to_i == 1
      render xlsx: @performance_reports.to_xlsx
    else
      @performance_reports = @performance_reports.paginate(page: params[:page], per_page: 200)
    end
  end

  def performance_report_print
    @total_value = PerformanceReport.sum(:value).to_f.round(2)
    @total_qty = PerformanceReport.sum(:total_qty).to_i
    @total_sku = PerformanceReport.sum(:sku).to_i
    @total_inspectors = DocumentProduct.distinct.count(:Inspector)
    @earliest_time = DateTime.parse(DocumentProduct.select("min(DateTime) as DateTime").first.DateTime).strftime("%I:%M %p")
    @latest_time = DateTime.parse(DocumentProduct.select("max(DateTime) as DateTime").first.DateTime).strftime("%I:%M %p")
    @master = Master.first
    @master_business = MasterBusiness.find_by(user_id: current_user.id)
    prepare_performance_report
    @performance_reports = @performance_reports.paginate(page: params[:page], per_page: 200)
    render layout: false
  end

  def summary_report
    if params[:regenerate].to_i == 1
      SummaryReport.regenerate!
      @departements = Master.where(HasCount: false).distinct("DeptName").pluck("DeptName")
      @summary_reports = SummaryReport.all.paginate(page: params[:page], per_page: 200)
    elsif params[:print].to_i == 1
      redirect_to summary_report_print_masters_path(dept: params[:dept])
    else
      @departements = Master.where(HasCount: false).distinct("DeptName").pluck("DeptName")
      @summary_reports = SummaryReport.all.paginate(page: params[:page], per_page: 200)
    end
    if params[:export].to_i == 1
      render xlsx: @summary_reports.to_xlsx
    end
  end

  def summary_report_print
    @departements = Master.where(HasCount: false).distinct("DeptName").pluck("DeptName")
    @summary_reports = SummaryReport.all.paginate(page: params[:page], per_page: 200)
    render layout: false
  end

  def no_counts_print
    prepare_no_counts
    render layout: false
  end

  def zero_counts
    if params[:regenerate].to_i == 1
      ZeroCountReport.regenerate!
    elsif params[:print].to_i == 1
      redirect_to zero_counts_print_masters_path(dept: params[:dept])
    end
    prepare_zero_counts

    if params[:export].to_i == 1
      render xlsx: @zero_counts.to_xlsx
    else
      @zero_counts = @zero_counts.paginate(page: params[:page], per_page: 200)
    end
  end

  def zero_counts_print
    prepare_zero_counts
    render layout: false
  end

  def variances
    if params[:print].to_i == 1
      redirect_to variances_print_masters_path(params.permit(:dept, :variance, :minimum_loss_value, :maximum_loss_value, :minimum_gain_value, :maximum_gain_value))
    else
      prepare_variances
      @departements = Master.where("id IN (?)", @variances.distinct("master_id").pluck("master_id")).distinct("DeptName").pluck("DeptName")
      @variances = @variances.includes(:master, :variance)
      @variances = sorting(@variances)
      @variances = @variances.paginate(page: params[:page], per_page: 200)
    end

    if params[:export].to_i == 1
      render xlsx: @variances.to_xlsx
    end
  end

  def variances_print
    prepare_variances
    render layout: false
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_master
    @master = Master.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def master_params
    params.require(:master).permit(:CountName, :StoreCode, :StoreName, :VenderCode, :VenderName, :DeptCode, :DeptName, :SubDeptCode, :SubDeptName, :Class, :ClassName, :SubClass, :SubClassName, :SKUType, :SpecialAttribute, :SKU, :BarcodeIBC, :BarcodeSBC, :Barcode1, :Barcode2, :Barcode3, :Barcode4, :Barcode5, :Barcode6, :Barcode7, :Barcode8, :Barcode9, :Barcode10, :ProductName, :Brand, :Model, :UnitOfMeasure, :Stock, :PackSize, :Cost, :RetailPrice, :Status)
  end

  def prepare_no_counts
    @no_counts = Master.where(HasCount: false)
    if params[:dept].present?
      @no_counts = @no_counts.where(DeptName: params[:dept])
    end
    if params[:sort_by].present?
      sort_by = params[:sort_by] == "desc" ? "DESC NULLS LAST" : "ASC NULLS FIRST"
      @no_counts = @no_counts.order(Arel.sql("(1- (Stock * Cost)) #{sort_by}"))
    end
  end

  def prepare_performance_report
    @performance_reports = PerformanceReport.all
    if params[:inspector].present?
      @performance_reports = @performance_reports.where(inspector: params[:inspector])
    end
  end

  def prepare_zero_counts
    @departements = Master.where(HasCount: false).distinct("DeptName").pluck("DeptName")
    @zero_counts = ZeroCountReport.includes(:master).all
    if params[:dept].present?
      @zero_counts = @zero_counts.where(DeptName: params[:dept])
    end
    if params[:sort_by].present?
      sort_by = params[:sort_by] == "desc" ? "DESC NULLS LAST" : "ASC NULLS FIRST"
      @zero_counts = @zero_counts.order(Arel.sql("(1- (Stock * Cost)) #{sort_by}"))
    end
  end

  def prepare_variances
    @variances = VarianceMasterReport.includes(:master, :variance)
    if params[:dept].present?
      # master_ids = Master.where(DeptName: params[:dept]).pluck(:id)
      @variances = @variances.where(masters: {DeptName: params[:dept]})
    end

    if filter_by_variance?
      @variances = @variances.where("VarianceDiff != 0.0")
    end

    main_query =  @variances
    main_query_value = main_query
    main_query_gian_value = main_query

    if params[:minimum_loss_value].present?
      main_query_value = main_query_value.where("VarianceDiff < 0 AND VarianceDiff >= ?", params[:minimum_loss_value])
    end

    if params[:maximum_loss_value].present?
      main_query_value = main_query_value.where("VarianceDiff < 0 AND VarianceDiff <= ?", params[:maximum_loss_value])
    end

    if params[:minimum_gain_value].present?
      main_query_gian_value = main_query_gian_value.where("VarianceDiff >= 0 AND VarianceDiff >= ?", params[:minimum_gain_value])
    end

    if params[:maximum_gain_value].present?
      main_query_gian_value = main_query_gian_value.where("VarianceDiff >= 0 AND VarianceDiff <= ?", params[:maximum_gain_value])
    end

    if (params[:minimum_loss_value].present? or params[:maximum_loss_value].present?) and
        (params[:minimum_gain_value].present? or params[:maximum_gain_value].present?)
      @variances = main_query_value.or(main_query_gian_value)
    elsif (params[:minimum_loss_value].present? or params[:maximum_loss_value].present?)
      @variances = main_query_value
    elsif (params[:minimum_gain_value].present? or params[:maximum_gain_value].present?)
      @variances = main_query_gian_value
    end
  end

  def filter_by_variance?
    params[:variance].present? && params[:variance] == "variance"
  end

  def sorting(variances)
    return variances unless params[:sort_name].present?

    variances.order(Arel.sql("#{params[:sort_name]} #{params[:sort_by]}"))
  end

  def set_columns
    @columns = [
        ["PrintDate", "created_at"],
        ["CountName", "masters.CountName"],
        ["DeptCode", "masters.DeptCode"],
        ["DeptName", "masters.DeptName"],
        ["Location", "variances.LOCATION"],
        ["SKU", "variances.SKU"],
        ["BarcodeIBC", "variances.BARCODE"],
        ["ProductName", "masters.ProductName"],
        ["Brand", "masters.Brand"],
        ["Model", "masters.Model"],
        ["Stock", "STOCK"],
        ["QNT", "QNT"],
        ["Variance", "VarianceDiff"],
        ["VarianceCost", "VarianceCost"],
        ["SKUType", "masters.SKUType"]
    ]
  end
end
