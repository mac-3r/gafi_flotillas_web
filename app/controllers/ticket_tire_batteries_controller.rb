class TicketTireBatteriesController < ApplicationController
  before_action :set_ticket_tire_battery, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /ticket_tire_batteries
  # GET /ticket_tire_batteries.json
  def index
    keyword = "#{params[:keyword]}"
    estatus = "#{params[:status]}"
    if keyword !=""
      @ticket_tire_batteries = TicketTireBattery.joins(:vehicle).where(vehicles:{numero_economico: keyword})
    elsif estatus !=""
      @ticket_tire_batteries = TicketTireBattery.where(estatus:estatus)
    else
      @ticket_tire_batteries = TicketTireBattery.all.order(fecha: :desc)
    end 
  end

  # GET /ticket_tire_batteries/1
  # GET /ticket_tire_batteries/1.json
  def show
  end

  # GET /ticket_tire_batteries/new
  def new
    @ticket_tire_battery = TicketTireBattery.new
  end

  # GET /ticket_tire_batteries/1/edit
  def edit
  end

  # POST /ticket_tire_batteries
  # POST /ticket_tire_batteries.json
  def create
    @ticket_tire_battery = TicketTireBattery.new(ticket_tire_battery_params)

    respond_to do |format|
      if @ticket_tire_battery.save
        format.html { redirect_to @ticket_tire_battery, notice: 'Ticket tire battery was successfully created.' }
        format.json { render :show, status: :created, location: @ticket_tire_battery }
      else
        format.html { render :new }
        format.json { render json: @ticket_tire_battery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ticket_tire_batteries/1
  # PATCH/PUT /ticket_tire_batteries/1.json
  def update
    respond_to do |format|
      if @ticket_tire_battery.update(ticket_tire_battery_params)
        format.html { redirect_to @ticket_tire_battery, notice: 'Ticket tire battery was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket_tire_battery }
      else
        format.html { render :edit }
        format.json { render json: @ticket_tire_battery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_tire_batteries/1
  # DELETE /ticket_tire_batteries/1.json
  def destroy
    @ticket_tire_battery.destroy
    respond_to do |format|
      format.html { redirect_to ticket_tire_batteries_url, notice: 'Ticket tire battery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autorizar_compra_ticket
    ticket = TicketTireBattery.find_by(id: params[:id])
		if ticket
			begin
				if ticket.update(estatus: "Autorizado")
					flash[:notice] = "Ticket autorizado con éxito"
				else
					mensaje = "Ocurrió un error: "
					ticket.errors.full_messages.each do |error|
						mensaje += "#{error}"
					end
					flash[:alert] = mensaje
				end
			rescue => exception
				flash[:alert] = "Error interno del sistema: #{exception}. Favor de contactar a soporte."
			end
		else
			flash[:alert] = "No se encontró el ticket o no se encuentra disponible para autorizar."
		end
		redirect_to ticket_tire_batteries_path
  end

  def rechazar_compra_ticket
    
  end

  def agregar_motivo_rechazo
    ticket = TicketTireBattery.find_by(id: params[:id])
		if ticket
			begin
				if ticket.update(estatus: "Atendida sin gasto",motivo: params[:motivo])
					flash[:notice] = "Ticket rechazado con éxito"
				else
					mensaje = "Ocurrió un error: "
					ticket.errors.full_messages.each do |error|
						mensaje += "#{error}"
					end
					flash[:alert] = mensaje
				end
			rescue => exception
				flash[:alert] = "Error interno del sistema: #{exception}. Favor de contactar a soporte."
			end
		else
			flash[:alert] = "No se encontró el ticket o no se encuentra disponible para autorizar."
		end
		redirect_to ticket_tire_batteries_path
  end

  def ver_fotos
    @photos = TicketImg.where(ticket_tire_battery_id: params[:id]) 
  end

  def crear_orden_compra
    #busca el ticket
    consulta_corte = Deadline.where("fecha_inicio <= '#{Date.today.strftime("%Y-%m-%d")}' and fecha_fin >= '#{Date.today.strftime("%Y-%m-%d")}' and estatus = TRUE")
    if consulta_corte.length > 0
      flash[:alert] = "Ya se realizó el corte para las fechas seleccionadas"
      redirect_to ticket_tire_batteries_path
    else
      ticket = TicketTireBattery.find_by(id: params[:id])
      numero_consecutivo = ServiceOrder.last
      numero_consecutivo ? nuevo_numero = numero_consecutivo.n_orden.to_i + 1 : nuevo_numero = 1
      service_order = ServiceOrder.new(n_orden:nuevo_numero,vehicle_id: ticket.vehicle_id,descripcion:params[:descripcion],catalog_vendor_id: params[:catalog_vendor_id],ticket_tire_battery_id:ticket.id,estatus:"Pendiente",fecha_revision_propuesta:Date.today,tipo_servicio:"Correctivo",catalog_tires_battery_id:params[:catalog_tires_battery_id],order_service_type_id:params[:order_service_type_id], catalog_area_id: ticket.vehicle.catalog_area_id, catalog_branch_id: ticket.vehicle.catalog_branch_id)
        if service_order.save and ticket.update(estatus:"Proceso de compra")
          TicketMailer.orden_servicio_compra(service_order.id).deliver_later
          flash[:notice] = "se creo la orden de servicio con éxito."
          redirect_to service_orders_path
        else
          mensaje = "Ocurrió un error: "
          service_order.errors.full_messages.each do |error|
            mensaje += "#{error}"
          end
          flash[:alert] = mensaje
          redirect_to ticket_tire_batteries_path
        end
    end
  end

  def generar_orden
    numero_consecutivo = ServiceOrder.last
    numero_consecutivo ? @nuevo_numero = numero_consecutivo.n_orden.to_i + 1 : @nuevo_numero = 1
    @ticket = TicketTireBattery.find_by(id:params[:id])
    #byebug
  end

  private
    def validacion_menu
      session["menu1"] = "Maestro de vehículos"
      session["menu2"] = "Solicitudes de compra"
	  end
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_tire_battery
      @ticket_tire_battery = TicketTireBattery.find(params[:id])
      numero_consecutivo = ServiceOrder.last
      numero_consecutivo ? nuevo_numero = numero_consecutivo.n_orden.to_i + 1 : nuevo_numero = 1
    end

    # Only allow a list of trusted parameters through.
    def ticket_tire_battery_params
      params.require(:ticket_tire_battery).permit(:vehicle_id, :dot, :fecha, :estatus, :tipo, :cantidad)
    end
end
