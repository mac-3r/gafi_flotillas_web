class VehicleTypesController < ApplicationController
  before_action :set_vehicle_type, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /vehicle_types
  # GET /vehicle_types.json
  def index
    tipo = "#{params[:tipo_vehiculo]}"
    if tipo != ""
      @vehicle_types = VehicleType.where("descripcion LIKE '%#{tipo}%'").order(descripcion: :asc)
    else
      @vehicle_types = VehicleType.all.order(descripcion: :asc)
    end
  end

  # GET /vehicle_types/1
  # GET /vehicle_types/1.json
  def show
  end

  # GET /vehicle_types/new
  def new
    @vehicle_type = VehicleType.new
  end

  # GET /vehicle_types/1/edit
  def edit
  end

  # POST /vehicle_types
  # POST /vehicle_types.json
  def create
    begin
      @vehicle_type = VehicleType.new(vehicle_type_params)
      if !params[:vehicle_type][:status].present?
        @vehicle_type.status = false
        end
      respond_to do |format|
        if @vehicle_type.save
          format.html { redirect_to vehicle_types_path, notice: 'El tipo de vehículo se creó con exito.' }
          format.json { render :show, status: :created, location: @vehicle_type }
        else
          format.html { render :new }
          format.json { render json: @vehicle_type.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to vehicle_types_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /vehicle_types/1
  # PATCH/PUT /vehicle_types/1.json
  def update
    begin
      if !params[:vehicle_type][:status].present?
        params[:vehicle_type][:status] = false
        else
        params[:vehicle_type][:status] = true
        end
      respond_to do |format|
        if @vehicle_type.update(vehicle_type_params)
          format.html { redirect_to vehicle_types_path, notice: 'El tipo de vehículo se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @vehicle_type }
        else
          format.html { render :edit }
          format.json { render json: @vehicle_type.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to vehicle_types_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /vehicle_types/1
  # DELETE /vehicle_types/1.json
  def destroy
    @vehicle_type.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_types_url, notice: 'El tipo de vehículo se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_type
      @vehicle_type = VehicleType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_type_params
      params.require(:vehicle_type).permit(:clave, :descripcion, :status,:rendimiento_ideal, :abreviatura)
    end
    def invalid_foreign_key
      redirect_to vehicle_types_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
