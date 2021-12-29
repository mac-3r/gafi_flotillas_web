class VehicleIndicatorsController < ApplicationController
  before_action :set_vehicle_indicator, only: [:show, :edit, :update, :destroy]

  # GET /vehicle_indicators
  # GET /vehicle_indicators.json
  def index
    @vehicle_indicators = VehicleIndicator.all
  end

  # GET /vehicle_indicators/1
  # GET /vehicle_indicators/1.json
  def show
  end

  # GET /vehicle_indicators/new
  def new
    @vehicle_indicator = VehicleIndicator.new
    @tipovehiculo = VehicleType.all
  end

  # GET /vehicle_indicators/1/edit
  def edit
  end

  # POST /vehicle_indicators
  # POST /vehicle_indicators.json
  def create
    params[:vehicle_indicator][:vehicle_type_id] = params[:vehicle_indicator][:vehicle_type_id]
    @vehicle_indicator = VehicleIndicator.new(vehicle_indicator_params)

    respond_to do |format|
      if @vehicle_indicator.save
        format.html { redirect_to vehicle_indicators_path, notice: 'Se creó correctamente' }
        format.json { render :show, status: :created, location: @vehicle_indicator }
      else
        format.html { render :new }
        format.json { render json: @vehicle_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicle_indicators/1
  # PATCH/PUT /vehicle_indicators/1.json
  def update
    respond_to do |format|
      if @vehicle_indicator.update(vehicle_indicator_params)
        format.html { redirect_to vehicle_indicators_path, notice: 'Se actualizó correctamente' }
        format.json { render :show, status: :ok, location: @vehicle_indicator }
      else
        format.html { render :edit }
        format.json { render json: @vehicle_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_indicators/1
  # DELETE /vehicle_indicators/1.json
  def destroy
    @vehicle_indicator.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_indicators_url, notice: 'Se eliminó correctamente' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_indicator
      @vehicle_indicator = VehicleIndicator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_indicator_params
      params.require(:vehicle_indicator).permit(:vehicle_type_id, :dias_habiles)
    end
end
