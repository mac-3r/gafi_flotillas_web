class VehicleLogsController < ApplicationController
  before_action :set_vehicle_log, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /vehicle_logs
  # GET /vehicle_logs.json
  def index
    numero = "#{params[:numero]}"
    fecha = "#{params[:start_date]}"
    if numero !=""
      @vehicle_logs = VehicleLog.joins(:vehicle).where(vehicles:{numero_economico:numero}).order(created_at: :desc)
    elsif fecha !=""
      selected_date = Date.parse(params[:start_date])
      @vehicle_logs = VehicleLog.where('created_at >= ? and created_at <=?', selected_date.midnight, selected_date.end_of_day)
    else
      @vehicle_logs = VehicleLog.all.order(created_at: :desc)
    end
  end

  # GET /vehicle_logs/1
  # GET /vehicle_logs/1.json
  def show
  end

  # GET /vehicle_logs/new
  def new
    @vehicle_log = VehicleLog.new
  end

  # GET /vehicle_logs/1/edit
  def edit
  end

  # POST /vehicle_logs
  # POST /vehicle_logs.json
  def create
    @vehicle_log = VehicleLog.new(vehicle_log_params)

    respond_to do |format|
      if @vehicle_log.save
        format.html { redirect_to @vehicle_log, notice: 'Vehicle log was successfully created.' }
        format.json { render :show, status: :created, location: @vehicle_log }
      else
        format.html { render :new }
        format.json { render json: @vehicle_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicle_logs/1
  # PATCH/PUT /vehicle_logs/1.json
  def update
    respond_to do |format|
      if @vehicle_log.update(vehicle_log_params)
        format.html { redirect_to @vehicle_log, notice: 'Vehicle log was successfully updated.' }
        format.json { render :show, status: :ok, location: @vehicle_log }
      else
        format.html { render :edit }
        format.json { render json: @vehicle_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_logs/1
  # DELETE /vehicle_logs/1.json
  def destroy
    @vehicle_log.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_logs_url, notice: 'Vehicle log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Bitácora de vehículos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_log
      @vehicle_log = VehicleLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_log_params
      params.fetch(:vehicle_log, {})
    end
end
