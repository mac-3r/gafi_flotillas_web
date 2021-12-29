class CatalogPermitsVehiclesController < ApplicationController
  before_action :set_catalog_permits_vehicle, only: [:show, :edit, :update, :destroy]

  # GET /catalog_permits_vehicles
  # GET /catalog_permits_vehicles.json
  def index
    @catalog_permits_vehicles = CatalogPermitsVehicle.all
  end

  # GET /catalog_permits_vehicles/1
  # GET /catalog_permits_vehicles/1.json
  def show
  end

  # GET /catalog_permits_vehicles/new
  def new
    @catalog_permits_vehicle = CatalogPermitsVehicle.new
  end

  # GET /catalog_permits_vehicles/1/edit
  def edit
  end

  # POST /catalog_permits_vehicles
  # POST /catalog_permits_vehicles.json
  def create
    @catalog_permits_vehicle = CatalogPermitsVehicle.new(catalog_permits_vehicle_params)
    if !params[:catalog_permits_vehicle][:status].present?
      @catalog_permits_vehicle.status = false
      end
    respond_to do |format|
      if @catalog_permits_vehicle.save
        format.html { redirect_to @catalog_permits_vehicle, notice: 'Se creó correctamente' }
        format.json { render :show, status: :created, location: @catalog_permits_vehicle }
      else
        format.html { render :new }
        format.json { render json: @catalog_permits_vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalog_permits_vehicles/1
  # PATCH/PUT /catalog_permits_vehicles/1.json
  def update
    if !params[:catalog_permits_vehicle][:status].present?
      params[:catalog_permits_vehicle][:status] = false
      else
      params[:catalog_permits_vehicle][:status] = true
      end
    respond_to do |format|
      if @catalog_permits_vehicle.update(catalog_permits_vehicle_params)
        format.html { redirect_to @catalog_permits_vehicle, notice: 'Se actualizó correctamente' }
        format.json { render :show, status: :ok, location: @catalog_permits_vehicle }
      else
        format.html { render :edit }
        format.json { render json: @catalog_permits_vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalog_permits_vehicles/1
  # DELETE /catalog_permits_vehicles/1.json
  def destroy
    @catalog_permits_vehicle.destroy
    respond_to do |format|
      format.html { redirect_to catalog_permits_vehicles_url, notice: 'Se eliminó correctamente' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_permits_vehicle
      @catalog_permits_vehicle = CatalogPermitsVehicle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_permits_vehicle_params
      params.require(:catalog_permits_vehicle).permit(:descripcion, :status)
    end
end
