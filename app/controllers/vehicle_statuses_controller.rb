class VehicleStatusesController < ApplicationController
  before_action :set_vehicle_status, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /vehicle_statuses
  # GET /vehicle_statuses.json
  def index
    @vehicle_statuses = VehicleStatus.order(nombre: :asc)
  end

  # GET /vehicle_statuses/1
  # GET /vehicle_statuses/1.json
  def show
  end

  # GET /vehicle_statuses/new
  def new
    @vehicle_status = VehicleStatus.new
  end

  # GET /vehicle_statuses/1/edit
  def edit
  end

  # POST /vehicle_statuses
  # POST /vehicle_statuses.json
  def create
    @vehicle_status = VehicleStatus.new(vehicle_status_params)
    if !params[:vehicle_status][:status].present?
      @vehicle_status.status = false
      end
    respond_to do |format|
      if @vehicle_status.save
        format.html { redirect_to vehicle_statuses_path, notice: 'El status del vehículo se creo con exito.' }
        format.json { render :show, status: :created, location: @vehicle_status }
      else
        format.html { render :new }
        format.json { render json: @vehicle_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicle_statuses/1
  # PATCH/PUT /vehicle_statuses/1.json
  def update
    if !params[:vehicle_status][:status].present?
      params[:vehicle_status][:status] = false
      else
      params[:vehicle_status][:status] = true
      end
    respond_to do |format|
      if @vehicle_status.update(vehicle_status_params)
        format.html { redirect_to vehicle_statuses_path, notice: 'El status del vehículo se actualizó con exito.' }
        format.json { render :show, status: :ok, location: @vehicle_status }
      else
        format.html { render :edit }
        format.json { render json: @vehicle_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_statuses/1
  # DELETE /vehicle_statuses/1.json
  def destroy
    @vehicle_status.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_statuses_url, notice: 'El status del vehículo se elimino con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_status
      @vehicle_status = VehicleStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_status_params
      params.require(:vehicle_status).permit(:nombre, :descripcion, :status)
    end
    def invalid_foreign_key
      redirect_to vehicle_statuses_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
