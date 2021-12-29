class DeadlinesController < ApplicationController
  before_action :set_deadline, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /deadlines
  # GET /deadlines.json
  def index
    @deadlines = Deadline.all
  end
  
  # GET /deadlines/1
  # GET /deadlines/1.json
  def show
  end
  
  # GET /deadlines/new
  def new
    @deadline = Deadline.new
  end
  
  # GET /deadlines/1/edit
  def edit
  end
  
  # POST /deadlines
  # POST /deadlines.json
  def create
    begin
      busqueda = Deadline.find_by(fecha_inicio: params[:deadline][:fecha_inicio],fecha_fin:params[:deadline][:fecha_fin])
      if !busqueda
        @deadline = Deadline.new(deadline_params)
        if !params[:deadline][:estatus].present?
          @deadline.estatus = false
        end
        respond_to do |format|
          if @deadline.save
            cargas_combustible = Consumption.where(fecha_inicio:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin],fecha_fin:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
            ordenes_compra = PurchaseOrder.where(fecha:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
            ordenes_servicio = ServiceOrder.where(fecha_revision_propuesta:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
            solicitudes = TicketTireBattery.where(fecha:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
            adaptaciones = VehicleAdaptation.where(fecha:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
            if cargas_combustible.update(deadline_id:@deadline.id) and ordenes_compra.update(deadline_id:@deadline.id) and ordenes_servicio.update(deadline_id:@deadline.id) and solicitudes.update(deadline_id:@deadline.id) and adaptaciones.update(deadline_id:@deadline.id)
              MovilApiController.consulta_siniestros_indicador_correo(params[:deadline][:fecha_inicio],params[:deadline][:fecha_fin])
              MovilApiController.correo_incidencias_responsable_siniestro(params[:deadline][:fecha_inicio],params[:deadline][:fecha_fin])
              MovilApiController.correo_monto_siniestrada(params[:deadline][:fecha_inicio],params[:deadline][:fecha_fin])
              MovilApiController.correo_flotilla_siniestrada(params[:deadline][:fecha_inicio],params[:deadline][:fecha_fin])
              MovilApiController.correo_indicador_vehiculos_dentro_rendimiento(params[:deadline][:fecha_inicio],params[:deadline][:fecha_fin])
              MovilApiController.correo_reporte_acumulado(params[:deadline][:fecha_inicio],params[:deadline][:fecha_fin])
              MovilApiController.correo_reporte_reparto(params[:deadline][:fecha_inicio],params[:deadline][:fecha_fin])
              MovilApiController.notificar_gerente
              Notification.notificacion_rendimiento(params[:deadline][:fecha_inicio],params[:deadline][:fecha_fin])
              format.html { redirect_to deadlines_path, notice: 'Cierre de gasto creado con exito.' }
              format.json { render :show, status: :created, location: @deadline }
            else
              format.html { redirect_to deadlines_path, alert: 'Ocurrio un error.' }
    
            end
            
          else
            format.html { render :new }
            format.json { render json: @deadline.errors, status: :unprocessable_entity }
          end
        end
      else
        redirect_to deadlines_path
        flash[:alert] = "Ya existe este registro."
      end
    rescue => exception
      redirect_to deadlines_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /deadlines/1
  # PATCH/PUT /deadlines/1.json
  def update
    begin
      if !params[:deadline][:estatus].present?
        params[:deadline][:estatus] = false
      else
        params[:deadline][:estatus] = true
      end
      respond_to do |format|
        if @deadline.update(deadline_params)
          cargas_combustible = Consumption.where(fecha_inicio:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin],fecha_fin:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
          ordenes_compra = PurchaseOrder.where(fecha:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
          ordenes_servicio = ServiceOrder.where(fecha_revision_propuesta:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
          solicitudes = TicketTireBattery.where(fecha:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
          adaptaciones = VehicleAdaptation.where(fecha:params[:deadline][:fecha_inicio]..params[:deadline][:fecha_fin])
  
          if cargas_combustible.update(deadline_id:@deadline.id) and ordenes_compra.update(deadline_id:@deadline.id) and ordenes_servicio.update(deadline_id:@deadline.id) and solicitudes.update(deadline_id:@deadline.id) and adaptaciones.update(deadline_id:@deadline.id)
            format.html { redirect_to deadlines_path, notice: 'Cierre de gasto creado con exito.' }
            format.html { redirect_to deadlines_path, notice: 'Cierre de gasto actualizado con exito.' }
            format.json { render :show, status: :created, location: @deadline }
          else
            format.html { redirect_to deadlines_path, alert: 'Ocurrio un error.' }
          end
        else
          format.html { render :new }
          format.json { render json: @deadline.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to deadlines_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /deadlines/1
  # DELETE /deadlines/1.json
  def destroy
    @deadline.destroy
    respond_to do |format|
      format.html { redirect_to deadlines_url, notice: 'Deadline was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Cortes de gastos"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_deadline
      @deadline = Deadline.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deadline_params
      params.require(:deadline).permit(:fecha_inicio, :fecha_fin,:estatus)
    end
end
