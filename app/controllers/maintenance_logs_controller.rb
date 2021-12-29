class MaintenanceLogsController < ApplicationController
  before_action :set_maintenance_log, only: [:show, :edit, :update, :destroy]

  # GET /maintenance_logs
  # GET /maintenance_logs.json
  def index
    keyword = "#{params[:keyword]}"
    if keyword != ""
      @maintenance_logs = MaintenanceLog.joins(:vehicle).where(vehicles: {numero_economico: keyword})
    else
      @maintenance_logs = MaintenanceLog.all.order(clave: :asc)
    end

  end

  # GET /maintenance_logs/1
  # GET /maintenance_logs/1.json
  def show
    @maintenance_details = @maintenance_log.maintenance_details

  end

  # GET /maintenance_logs/new
  def new
    @maintenance_log = MaintenanceLog.new
  end

  def nuevo_mantenimiento
    @maintenance_log = MaintenanceLog.new
  end

  def crear_mantenimiento
    @maintenance_log = MaintenanceLog.crear_man(params)
    #byebug
    if @maintenance_log[0] == 4
      redirect_to edit_maintenance_log_path(@maintenance_log[1])
      flash[:notice] = "Se registro correctamente "
    else
      redirect_to maintenance_logs_path
      flash[:alert] = "Ocurrio un error"
    end
  end
  # GET /maintenance_logs/1/edit
  def edit
    @maintenance_details = @maintenance_log.maintenance_details
    session["mantenimiento"] = @maintenance_log.id
    if @maintenance_log
      @maintenance_details = @maintenance_log.maintenance_details
    else
      flash[:alert]= "No existe el registro"
      redirect_to maintenance_logs_path
    end
  end
  
  def formulario_agregar_mantenimiento_detalle
    @maintenance_details = MaintenanceDetail.new
    respond_to do |format|
    format.js
    end
  end
  def guardar_detalle_mantenimiento
    @detalle = MaintenanceDetail.detalle(params,session["mantenimiento"])
    if @detalle[1] == 4
      @encabezado = MaintenanceLog.find(@detalle[2])
      @maintenance_details = @encabezado.maintenance_details
    end
    respond_to do |format|
        format.js
    end
  end
  def eliminar_detalle
    @bandera = 0
    @mensaje = ""
    detalle = MaintenanceDetail.find_by(id: params[:id_partida])
    if detalle
      id_pedido = detalle.maintenance_log_id           
      if detalle.destroy
        @mensaje = "Datos eliminados correctamente."
        @maintenance_details = MaintenanceDetail.where(maintenance_log_id: id_pedido)
      else
        @bandera = 1
        detalle.errors.full_messages.each do |mensaje|
          @mensaje += mensaje    
        end
      end
    else
      @bandera = 2
      @mensaje += "No se encontró la partida."
    end        
    respond_to do |format|
      format.js
    end
  end
  # POST /maintenance_logs
  # POST /maintenance_logs.json
  def create
    @maintenance_log = MaintenanceLog.new(maintenance_log_params)

    respond_to do |format|
      if @maintenance_log.save
        format.html { redirect_to @maintenance_log, notice: 'Maintenance log was successfully created.' }
        format.json { render :show, status: :created, location: @maintenance_log }
      else
        format.html { render :new }
        format.json { render json: @maintenance_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_logs/1
  # PATCH/PUT /maintenance_logs/1.json
  def update
    @bandera_error = 0
    @errores = ""
    @maintenance_log = MaintenanceLog.find(params[:id])
    respond_to do |format|
      if @maintenance_log.maintenance_details.count > 0
        format.html { redirect_to maintenance_logs_path, notice: 'Registro finalizado con éxito.' }
        format.json { render :show, status: :ok, location: @maintenance_log }
      else
        format.html { redirect_to edit_maintenance_log_path(@maintenance_log.id), alert: 'El registro debe tener al menos un dato.' }
      end
    end
  end

  # DELETE /maintenance_logs/1
  # DELETE /maintenance_logs/1.json
  def destroy
    @maintenance_log.destroy
    respond_to do |format|
      format.html { redirect_to maintenance_logs_url, notice: 'Maintenance log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_log
      @maintenance_log = MaintenanceLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def maintenance_log_params
      params.require(:maintenance_log).permit(:clave, :catalog_brand_id, :fecha)
    end
end
