class AgencyMileageIndicatorsController < ApplicationController
  before_action :set_agency_mileage_indicator, only: [:show, :edit, :update, :destroy]

  # GET /agency_mileage_indicators
  # GET /agency_mileage_indicators.json
  def index
    keyword = "#{params[:keyword]}"
    usuario = "#{params[:catalog_personal_id]}"
    if keyword !=""
      @agency_mileage_indicators = AgencyMileageIndicator.joins(:vehicle).where("vehicles.numero_economico = '"+ keyword +"'")
    elsif usuario !=""
      @agency_mileage_indicators = AgencyMileageIndicator.joins(:vehicle).where("vehicles.catalog_personal_id = '"+ usuario +"'").order(km_actual: :asc)
    elsif
      @agency_mileage_indicators = AgencyMileageIndicator.order(km_actual: :asc)
    end 
  end

  # GET /agency_mileage_indicators/1
  # GET /agency_mileage_indicators/1.json
  def show
  end

  # GET /agency_mileage_indicators/new
  def new
    @agency_mileage_indicator = AgencyMileageIndicator.new
  end

  # GET /agency_mileage_indicators/1/edit
  def edit
  end

  # POST /agency_mileage_indicators
  # POST /agency_mileage_indicators.json
  def create
    @agency_mileage_indicator = AgencyMileageIndicator.new(agency_mileage_indicator_params)

    respond_to do |format|
      if @agency_mileage_indicator.save
        format.html { redirect_to @agency_mileage_indicator, notice: 'Agency mileage indicator was successfully created.' }
        format.json { render :show, status: :created, location: @agency_mileage_indicator }
      else
        format.html { render :new }
        format.json { render json: @agency_mileage_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agency_mileage_indicators/1
  # PATCH/PUT /agency_mileage_indicators/1.json
  def update
    respond_to do |format|
      if @agency_mileage_indicator.update(agency_mileage_indicator_params)
        format.html { redirect_to @agency_mileage_indicator, notice: 'Agency mileage indicator was successfully updated.' }
        format.json { render :show, status: :ok, location: @agency_mileage_indicator }
      else
        format.html { render :edit }
        format.json { render json: @agency_mileage_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agency_mileage_indicators/1
  # DELETE /agency_mileage_indicators/1.json
  def destroy
    @agency_mileage_indicator.destroy
    respond_to do |format|
      format.html { redirect_to agency_mileage_indicators_url, notice: 'Agency mileage indicator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agency_mileage_indicator
      @agency_mileage_indicator = AgencyMileageIndicator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agency_mileage_indicator_params
      params.require(:agency_mileage_indicator).permit(:km_actual, :vehicle_id, :fecha, :tipo)
    end
end
