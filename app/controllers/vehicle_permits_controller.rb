class VehiclePermitsController < ApplicationController
  before_action :set_vehicle_permit, only: [:show, :edit, :update, :destroy]

  # GET /vehicle_permits
  # GET /vehicle_permits.json
  def index
    @vehicle_permits = VehiclePermit.all
  end

  # GET /vehicle_permits/1
  # GET /vehicle_permits/1.json
  def show
  end

  # GET /vehicle_permits/new
  def new
    @vehicle_permit = VehiclePermit.new
  end

  # GET /vehicle_permits/1/edit
  def edit
  end

  # POST /vehicle_permits
  # POST /vehicle_permits.json
  def create
    @vehicle_permit = VehiclePermit.new(vehicle_permit_params)
    if !params[:vehicle_permit][:status].present?
      @vehicle_permit.status = false
      end
    respond_to do |format|
      if @vehicle_permit.save
        format.html { redirect_to vehicle_permits_path, notice: 'El permiso se creó con exito.' }
        format.json { render :show, status: :created, location: @vehicle_permit }
      else
        format.html { render :new }
        format.json { render json: @vehicle_permit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicle_permits/1
  # PATCH/PUT /vehicle_permits/1.json
  def update
    if !params[:vehicle_permit][:status].present?
      params[:vehicle_permit][:status] = false
      else
      params[:vehicle_permit][:status] = true
      end
    respond_to do |format|
      if @vehicle_permit.update(vehicle_permit_params)
        format.html { redirect_to vehicle_permits_path, notice: 'El permiso se actualizó con exito.' }
        format.json { render :show, status: :ok, location: @vehicle_permit }
      else
        format.html { render :edit }
        format.json { render json: @vehicle_permit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_permits/1
  # DELETE /vehicle_permits/1.json
  def destroy
    @vehicle_permit.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_permits_url, notice: 'El permiso se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_permit
      @vehicle_permit = VehiclePermit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_permit_params
      params.require(:vehicle_permit).permit( :descripcion, :status,:vehicle_id,:fecha_vigencia)
    end
end
