class MileageIndicatorsController < ApplicationController
  before_action :set_mileage_indicator, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /mileage_indicators
  # GET /mileage_indicators.json
  def index
    session["empresa_km"] = ""
    session["cedis_km"] = ""
    session["fecha_km"] = ""
    session["fecha_fin_km"] = ""
    @mileage_indicators = MileageIndicator.consulta_km(session["empresa_km"],session["cedis_km"], session["fecha_km"], session["fecha_fin_km"])
  end

  def filtrado_seguimiento
    session["empresa_km"] = params[:catalog_company_id]
    session["cedis_km"] = params[:catalog_branch_id]
    if params[:start_date] != ""
      session["fecha_km"] = Date.strptime(params[:start_date], "%d/%m/%Y")
    else
      session["fecha_km"] = ""
    end
    if params[:end_date] != ""
      session["fecha_fin_km"] = Date.strptime(params[:end_date], "%d/%m/%Y")
    else
      session["fecha_fin_km"] = ""
    end
    @mileage_indicators = MileageIndicator.consulta_km(session["empresa_km"],session["cedis_km"], session["fecha_km"], session["fecha_fin_km"])
    respond_to do |format|
      format.js
    end
  end
  # GET /mileage_indicators/1
  # GET /mileage_indicators/1.json
  def show
  end

  # GET /mileage_indicators/new
  def new
    @mileage_indicator = MileageIndicator.new
  end

  # GET /mileage_indicators/1/edit
  def edit
  end

  # POST /mileage_indicators
  # POST /mileage_indicators.json
  def create
    @mileage_indicator = MileageIndicator.new(mileage_indicator_params)

    respond_to do |format|
      if @mileage_indicator.save
        format.html { redirect_to @mileage_indicator, notice: 'Mileage indicator was successfully created.' }
        format.json { render :show, status: :created, location: @mileage_indicator }
      else
        format.html { render :new }
        format.json { render json: @mileage_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mileage_indicators/1
  # PATCH/PUT /mileage_indicators/1.json
  def update
    respond_to do |format|
      if @mileage_indicator.update(mileage_indicator_params)
        format.html { redirect_to @mileage_indicator, notice: 'Mileage indicator was successfully updated.' }
        format.json { render :show, status: :ok, location: @mileage_indicator }
      else
        format.html { render :edit }
        format.json { render json: @mileage_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mileage_indicators/1
  # DELETE /mileage_indicators/1.json
  def destroy
    @mileage_indicator.destroy
    respond_to do |format|
      format.html { redirect_to mileage_indicators_url, notice: 'Mileage indicator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Mantenimiento"
      session["menu2"] = "Seguimiento de captura de kilometraje"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_mileage_indicator
      @mileage_indicator = MileageIndicator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mileage_indicator_params
      params.require(:mileage_indicator).permit(:vehicle_id, :km_actual, :fecha)
    end
end
