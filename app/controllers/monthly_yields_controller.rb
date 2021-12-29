class MonthlyYieldsController < ApplicationController
  before_action :set_monthly_yield, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  # GET /monthly_yields
  # GET /monthly_yields.json
  def index
    keyword = "#{params[:keyword]}"
    if keyword !=""
      @monthly_yields = MonthlyYield.joins(:vehicle).where("vehicles.numero_economico = '"+ keyword +"'")
    else
      @monthly_yields = MonthlyYield.joins(:vehicle).order(:numero_economico)
    end
  end

  # GET /monthly_yields/1
  # GET /monthly_yields/1.json
  def show
  end

  # GET /monthly_yields/new
  def new
    @monthly_yield = MonthlyYield.new
  end

  # GET /monthly_yields/1/edit
  def edit
  end

  # POST /monthly_yields
  # POST /monthly_yields.json
  def create
    @monthly_yield = MonthlyYield.new(monthly_yield_params)

    respond_to do |format|
      if @monthly_yield.save
        format.html { redirect_to @monthly_yield, notice: 'Monthly yield was successfully created.' }
        format.json { render :show, status: :created, location: @monthly_yield }
      else
        format.html { render :new }
        format.json { render json: @monthly_yield.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monthly_yields/1
  # PATCH/PUT /monthly_yields/1.json
  def update
    respond_to do |format|
      if @monthly_yield.update(monthly_yield_params)
        format.html { redirect_to monthly_yields_path, notice: 'Registro actualizado.' }
        format.json { render :show, status: :ok, location: @monthly_yield }
      else
        format.html { render :edit }
        format.json { render json: @monthly_yield.errors, status: :unprocessable_entity }
      end
    end
  end
  def import_yields
    @monthly_yield = MonthlyYield.import_yields(params[:file])
    respond_to do |format|
      if @monthly_yield.count == 0
        format.html { redirect_to monthly_yields_url, notice: "Plantilla cargada con éxito." }
      else
        format.html { render :import_yields_errors }
        format.json { render json: @monthly_yield }
      end
    end
  end

  def template_download_yields
    send_file "#{Rails.root}/public/packs/Importaciones/Plantilla_reporte.xlsx"
  end
 
  # DELETE /monthly_yields/1
  # DELETE /monthly_yields/1.json
  def destroy
    @monthly_yield.destroy
    respond_to do |format|
      format.html { redirect_to monthly_yields_url, notice: 'Monthly yield was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monthly_yield
      @monthly_yield = MonthlyYield.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def monthly_yield_params
      params.require(:monthly_yield).permit(:vehicle_id, :catalog_branch_id, :vehicle_type_id, :catalog_model_id, :catalog_brand_id, :cierre_enero, :recorrido_enero, :lts_enero, :cierre_febrero, :recorrido_febrero, :lts_febrero, :cierre_marzo, :recorrido_marzo, :lts_marzo, :cierre_abril, :recorrido_abril, :lts_abril, :cierre_mayo, :recorrido_mayo, :lts_mayo, :cierre_junio, :recorrido_junio, :lts_junio, :cierre_julio, :recorrido_julio, :lts_julio, :cierre_agosto, :recorrido_agosto, :lts_agosto, :cierre_septiembre, :recorrido_septiembre, :lts_septiembre, :cierre_octubre, :recorrido_octubre, :lts_octubre, :cierre_noviembre, :recorrido_noviembre, :lts_noviembre, :cierre_diciembre, :recorrido_diciembre, :lts_diciembre, :rendi_enero, :rendi_febrero, :rendi_marzo, :rendi_abril, :rendi_mayo, :rendi_junio, :rendi_julio, :rendi_agosto, :rendi_septiembre, :rendi_octubre, :rendi_noviembre, :rendi_diciembre,:rendimiento_ideal)
    end
end
