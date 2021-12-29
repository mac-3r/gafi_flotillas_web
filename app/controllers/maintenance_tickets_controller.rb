class MaintenanceTicketsController < ApplicationController
  before_action :set_maintenance_ticket, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /maintenance_tickets
  # GET /maintenance_tickets.json
  def index
    session["empresa_ti"] = ""
    session["cedis_ti"] = ""
    session["user_ti"] = ""
    session["tipo_ti"] = ""
    session["linea_ti"] = ""
    session["area_ti"] = ""
    @maintenance_tickets = MaintenanceTicket.consulta_tickets(session["empresa_ti"],session["cedis_ti"], session["user_ti"], session["tipo_ti"], session["linea_ti"], session["area_ti"])
  end
 
  def filtrado_tickets
    session["empresa_ti"] = params[:catalog_company_id]
    session["cedis_ti"] = params[:catalog_branch_id]
    session["user_ti"] = params[:catalog_personal_id]
    session["tipo_ti"] = params[:vehicle_type_id]
    session["linea_ti"] = params[:catalog_brand_id]
    session["area_ti"] = params[:catalog_area_id]
    @maintenance_tickets = MaintenanceTicket.consulta_tickets(session["empresa_ti"],session["cedis_ti"], session["user_ti"], session["tipo_ti"], session["linea_ti"], session["area_ti"])
    respond_to do |format|
      format.js
    end
  end


  # GET /maintenance_tickets/1
  # GET /maintenance_tickets/1.json
  def show
  end

  # GET /maintenance_tickets/new
  def new
    @maintenance_ticket = MaintenanceTicket.new
  end

  # GET /maintenance_tickets/1/edit
  def edit
  end

  # POST /maintenance_tickets
  # POST /maintenance_tickets.json
  def create
    @maintenance_ticket = MaintenanceTicket.new(maintenance_ticket_params)

    respond_to do |format|
      if @maintenance_ticket.save
        format.html { redirect_to @maintenance_ticket, notice: 'Maintenance ticket was successfully created.' }
        format.json { render :show, status: :created, location: @maintenance_ticket }
      else
        format.html { render :new }
        format.json { render json: @maintenance_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_tickets/1
  # PATCH/PUT /maintenance_tickets/1.json
  def update
    respond_to do |format|
      if @maintenance_ticket.update(maintenance_ticket_params)
        format.html { redirect_to maintenance_tickets_path, notice: 'Descripción actualizada con éxito.' }
        format.json { render :show, status: :ok, location: @maintenance_ticket }
      else
        format.html { render :edit }
        format.json { render json: @maintenance_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maintenance_tickets/1
  # DELETE /maintenance_tickets/1.json
  def destroy
    @maintenance_ticket.destroy
    respond_to do |format|
      format.html { redirect_to maintenance_tickets_url, notice: 'Maintenance ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autorizar_ticket
    @ticket= MaintenanceTicket.find_by(id: params[:id])
    if @ticket
      @ticket.update(estatus:"Autorizado")
      if @ticket.service_order_id
        cantidad_tickets = MaintenanceTicket.where(service_order_id: @ticket.service_order_id).length
        orden_compuesta = "#{@ticket.service_order_id}.#{cantidad_tickets}"
        orden = ServiceOrder.new(n_orden:orden_compuesta,vehicle_id:@ticket.vehicle_id,maintenance_ticket_id:@ticket.id, catalog_area_id: @ticket.vehicle.catalog_area_id, catalog_branch_id: @ticket.vehicle.catalog_branch_id, estatus: "En captura")
        #byebug
      else 
        numero_consecutivo = ServiceOrder.last
        numero_consecutivo ? nuevo_numero = numero_consecutivo.n_orden.to_i + 1 : nuevo_numero = 1
        orden = ServiceOrder.new(n_orden:nuevo_numero,vehicle_id:@ticket.vehicle_id,maintenance_ticket_id:@ticket.id, catalog_area_id: @ticket.vehicle.catalog_area_id, catalog_branch_id: @ticket.vehicle.catalog_branch_id, estatus: "En captura")
      end
      ultimo_km = MileageIndicator.select('km_actual').where(vehicle_id:@ticket.vehicle_id).last
      #byebug
      if orden.save
        flash[:notice]= "Ticket autorizado con éxito, completa los datos para la orden del servicio."
        redirect_to crear_orden_ticket_path(orden.id)
      else
        flash[:alert]= "Ocurrio un error."
        redirect_to maintenance_tickets_path
      end
    else
        flash[:alert]= "No se encontro el ticket."
        redirect_to maintenance_tickets_path
    end
  end

  def rechazar_ticket
    @ticket= MaintenanceTicket.find_by(id: params[:id])
    if @ticket
      @ticket.update(estatus:"Rechazado")
      flash[:notice]= "Ticket rechazado con éxito."
      redirect_to maintenance_tickets_path
    else
        flash[:alert]= "No se encontro el ticket."
        redirect_to maintenance_tickets_path
    end
  end

  def crear_orden_ticket
    @orden = ServiceOrder.find_by(id: params[:id])
    @ultimo_km = MileageIndicator.select('km_actual').where(vehicle_id:@orden.vehicle_id).last
    #byebug
  end

  def guardar_orden_ticket
    @orden = ServiceOrder.find_by(id: params[:id])
    #byebug
    if @orden
      @orden.update(descripcion: params[:descripcion],catalog_workshop_id:params[:catalog_workshop_id],order_service_type_id: params[:order_service_type_id],tipo_servicio: params[:tipo],fecha_revision_propuesta: params[:fecha_revision_propuesta],estatus:"Pendiente")
      flash[:notice]= "Orden de servicio registrada con éxito."
      redirect_to service_orders_path
    else
      flash[:alert]= "No se encontro la orden."
      redirect_to maintenance_tickets_path
    end
  end

  def ver_fotos_tickets
    @photos = ImgTicketWorkshop.where(maintenance_ticket_id: params[:id]) 
  end
  
  private

    def validacion_menu
      session["menu1"] = "Mantenimiento"
      session["menu2"] = "Tickets"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_ticket
      @maintenance_ticket = MaintenanceTicket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def maintenance_ticket_params
      params.require(:maintenance_ticket).permit(:vehicle_id, :descripcion, :fecha_alta, :estatus)
    end
end
