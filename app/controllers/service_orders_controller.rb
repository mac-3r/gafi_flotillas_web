class ServiceOrdersController < ApplicationController
  before_action :set_service_order, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /service_orders
  # GET /service_orders.json
  def index
    session["no_orden"] = ""
    session["empresa_se"] = ""
    session["cedis_se"] = ""
    session["user_se"] = ""
    session["tipo_se"] = ""
    session["linea_se"] = ""
    session["area_se"] = ""
    @parametro_garantia = Parameter.find_by(nombre: "id de garantia")
    if session["taller"]
      @service_orders = ServiceOrder.consulta_ordenes_taller(session["no_orden"],session["empresa_se"],  session["cedis_se"], session["user_se"], session["tipo_se"], session["linea_se"], session["area_se"],session["taller"])
    else
      @service_orders = ServiceOrder.consulta_ordenes(session["no_orden"],session["empresa_se"],  session["cedis_se"], session["user_se"], session["tipo_se"], session["linea_se"], session["area_se"])
    end
  end
 
  def filtrado_ordenes_servicio
    session["no_orden"] = params[:keyword]
    session["empresa_se"] = params[:catalog_company_id]
    session["cedis_se"] = params[:catalog_branch_id]
    session["user_se"] = params[:catalog_personal_id]
    session["tipo_se"] = params[:vehicle_type_id]
    session["linea_se"] = params[:catalog_brand_id]
    session["area_se"] = params[:catalog_area_id]
   
    if session["taller"]
      @service_orders = ServiceOrder.consulta_ordenes_taller(session["no_orden"],session["empresa_se"],  session["cedis_se"], session["user_se"], session["tipo_se"], session["linea_se"], session["area_se"],session["taller"])
    else
      @service_orders = ServiceOrder.consulta_ordenes(session["no_orden"],session["empresa_se"],  session["cedis_se"] ,session["user_se"], session["tipo_se"], session["linea_se"], session["area_se"])
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /service_orders/1
  # GET /service_orders/1.json
  def show
    @orden = ServiceOrder.find_by(id: params[:id])
    @km = MileageIndicator.select('km_actual').where(vehicle_id: @orden.vehicle_id).last
    if @orden.tipo_servicio == "Preventivo"
      @precio = ServiceOrder.ver_precio(@orden)
    end
    #ENCUESTA
    if @orden.estatus == "Servicio Finalizado" or @orden.estatus == "Salió de taller"
      @info = UserAnswer.find_by(service_order_id:@orden.id)
      @tiempo = MaintenanceControl.find_by(service_order_id:@orden.id)
      if @info
        @encuesta = AnswerDetail.where(user_answer_id: @info.id)
      end
      @servicios_realizar =  BinnacleOrder.where(service_order_id:@orden.id)
    else
      @servicios_realizar = ServiceOrder.ver_servicios(@orden.vehicle.catalog_brand,@orden.vehicle_id)[2]
    end
  end

  # GET /service_orders/new
  def new
    @service_order = ServiceOrder.new
  end

  # GET /service_orders/1/edit
  def edit
  end

  # POST /service_orders
  # POST /service_orders.json
  def create
    @service_order = ServiceOrder.new(service_order_params)

    respond_to do |format|
      if @service_order.save
        format.html { redirect_to @service_order, notice: 'Service order was successfully created.' }
        format.json { render :show, status: :created, location: @service_order }
      else
        format.html { render :new }
        format.json { render json: @service_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_orders/1
  # PATCH/PUT /service_orders/1.json
  def update
    respond_to do |format|
      if @service_order.update(service_order_params)
        format.html { redirect_to service_orders_path, notice: 'Se añadio la descripcion con exito.' }
        format.json { render :show, status: :ok, location: @service_order }
      else
        format.html { render :edit }
        format.json { render json: @service_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_orders/1
  # DELETE /service_orders/1.json
  def destroy
    @service_order.destroy
    respond_to do |format|
      format.html { redirect_to service_orders_url, notice: 'Service order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def asignar_taller
    @orden = ServiceOrder.find_by(id: params[:id])
  end

  def guardar_taller
    taller = CatalogWorkshop.consulta_x_taller(params[:catalog_workshop_id])
    cita = ServiceOrder.find_by(id: params[:id])
    if cita
      if cita.update(catalog_workshop_id:params[:catalog_workshop_id],estatus: "Pendiente")
        flash[:notice] = "Taller asignado con exito."
        redirect_to service_orders_path
      else
        cita.errors.full_messages.each do |error|
          flash[:alert] = "Ocurrio un error."
          #byebug
        end
        redirect_to service_orders_path
      end
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to service_orders_path
    end
  end

  def consulta_taller
    @taller = CatalogWorkshop.consulta_x_taller(params[:id])
    #byebug
    respond_to do |format|
      format.js
    end
  end
  #autoriza ordenes preventivos
  def autorizar_orden
    begin
      @busqueda = ServiceOrder.find_by(id: params[:id])
      if @busqueda.tipo_servicio == "Preventivo" or @busqueda.tipo_servicio == "Preventivo Agencia"
          arreglo_competencias = Array.new
          #se actualiza el precio segun la bitacora
          precio = ServiceOrder.ver_precio(@busqueda)
           #verifica que el user actual este en el mismo cedis que el vehículo
        if current_user.catalog_branches_user.map{|x| x.catalog_branch_id}.include? @busqueda.vehicle.catalog_branch_id
          tabla_competencias = CompetitionTable.where("catalog_branch_id = #{@busqueda.vehicle.catalog_branch_id} and tipo = 'Mantenimiento y equipo de transporte' and monto >= #{precio}")
          if tabla_competencias.present?
            tabla_competencias.each do |tab|
              rol_user = CatalogRolesUser.where(user_id: current_user.id)
              if rol_user.map{|x| x.catalog_role_id}.include? tab.catalog_role_id
                arreglo_competencias.push(tab)
              end
            end
            if arreglo_competencias.length > 0
                @busqueda.update(estatus:"Cita programada",usuario_autoriza: "#{current_user.name} #{current_user.last_name}",precio:precio)
                Notification.servicio_autorizado(@busqueda)
                Notification.servicio_autorizado_usuario(@busqueda)
                #envio orden y bitacora
                TicketMailer.correo_talleres(@busqueda).deliver_later
                flash[:notice] = "Orden autorizada con exito."
                redirect_to service_orders_path
            else
              TicketMailer.orden_servicio_competencia(current_user,@busqueda).deliver_later
              flash[:alert] = "Tu rol no cumple con la tabla de competencias."
              redirect_to service_orders_path
            end
          else
            flash[:alert] = "No se encontro la competencia, favor de verificar la información."
            redirect_to service_orders_path
          end
        else
          TicketMailer.orden_servicio_competencia(current_user,@busqueda).deliver_later
          flash[:alert] = "El cedis en el que te encuentras no cumple con la tabla de competencias."
          redirect_to service_orders_path
        end
      elsif @busqueda.tipo_servicio == "Correctivo" or @busqueda.tipo_servicio == "Correctivo Agencia"
        if @busqueda.update(estatus:"Cita programada")
          flash[:notice] = "Orden autorizada con exito."
          redirect_to service_orders_path
        else
          flash[:alert] = "Ocurrio un error."
          redirect_to service_orders_path
        end
      end
    rescue => exception
      flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
      redirect_to service_orders_path
    end
  end

  def crear_cotizacion
    begin
      service_order = ServiceOrder.find_by(id: params[:id])
      if service_order
        if service_order.ticket_tire_battery_id
          #compra de llanta y bateria
          cotizacion = Quote.new(vehicle_id:service_order.vehicle_id,service_order_id:service_order.id,catalog_vendor_id:service_order.catalog_vendor_id,numero_economico:service_order.vehicle.numero_economico,cedis:service_order.vehicle.catalog_branch.decripcion,empresa:service_order.vehicle.catalog_company.nombre,usuario:service_order.vehicle.catalog_personal.nombre,responsable:service_order.vehicle.responsable.nombre,fecha:Time.now,estatus:"Pendiente")
        else
          #servicio correctivo
          cotizacion = Quote.new(vehicle_id:service_order.vehicle_id,service_order_id:service_order.id,catalog_workshop_id:service_order.catalog_workshop_id,numero_economico:service_order.vehicle.numero_economico,cedis:service_order.vehicle.catalog_branch.decripcion,empresa:service_order.vehicle.catalog_company.nombre,usuario:service_order.vehicle.catalog_personal.nombre,responsable:service_order.vehicle.responsable.nombre,taller_nombre:service_order.catalog_workshop.nombre_taller,fecha:Time.now,estatus:"Pendiente")
        end
        if cotizacion.save
          flash[:notice] = "Cotización creada con exito favor de completar los datos"
          redirect_to detalle_cotizacion_path(cotizacion.id)
        else
          cotizacion.errors.full_messages.each do |error|
            flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}."
            redirect_to service_orders_path
          end
        end
      end
    rescue => exception
      flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
      redirect_to service_orders_path
    end

  end

  def detalle_cotizacion
    @cotizacion = Quote.find_by(id:params[:quote_id])
    @detalle = QuoteDetail.where(quote_id:params[:quote_id])
    parametro = Parameter.find_by(nombre:"id de garantia")
    if @cotizacion.service_order.order_service_type_id == parametro.valor_extendido.to_i
        @garantia = true
    end
  end

  def guardar_detalle_cotizacion
    begin
      cotizacion = Quote.find_by(id:params[:quote_id])
     if cotizacion 
      registro = QuoteDetail.create(quote_id:cotizacion.id,descripcion:params[:descripcion],precio:params[:precio]) 
      flash[:notice] = "Se registraron los datos con éxito."
      redirect_to detalle_cotizacion_path
     else
       flash[:alert] = "Ocurrio un error"
       redirect_to service_orders_path
     end
    rescue => exception
      flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
      redirect_to service_orders_path
    end
 end

 def solicitar_cotizacion
  begin
    cotizacion = Quote.find_by(id:params[:quote_id])
    if cotizacion
      orden = ServiceOrder.find_by(id:cotizacion.service_order_id)
      if orden.update(cotizacion_servicio:params[:archivo_cotizacion],estatus:"Esperando autorización",cotizacion:true)
        Notification.peticion_adicionales(orden)
        flash[:notice] = "Solicitud enviada con éxito."
        redirect_to service_orders_path
      else
        orden.errors.full_messages.each do |error|
          flash[:alert] = "Ocurrio un error."
          redirect_to service_orders_path
        end
      end
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to service_orders_path
    end
  rescue => exception
    flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
    redirect_to detalle_cotizacion_path
  end
 end

 def ver_cotizacion
    @orden = ServiceOrder.find_by(id: params[:id])
    if @orden.estatus == "Esperando autorización"
      @cotizaciones = Quote.where(service_order_id:params[:id],estatus:"Pendiente").order(id: :asc)
      if @cotizaciones.length > 0
        @cotizacion = @cotizaciones.last
      else
        @cotizacion = nil
      end
    else
      @cotizaciones = Quote.where(service_order_id:params[:id],estatus:"Autorizado").order(id: :asc)
      if @cotizaciones.length > 0
        @cotizacion = @cotizaciones.last
      else
        @cotizacion = nil
      end
    end
    if @cotizacion != nil
      @detalle = QuoteDetail.where(quote_id:@cotizacion.id)
    else
      flash[:alert] = "No se adjuntó la cotización."
      redirect_to service_orders_path
    end
 end

  def autorizar_cotizacion
      begin
        arreglo_competencias = Array.new
        @cotizaciones = Quote.where(id: params[:id]).order(id: :asc)
        if @cotizaciones.length > 0
          cotizacion = @cotizaciones.last
          detalle = QuoteDetail.where(quote_id: params[:id])
          orden = ServiceOrder.find_by(id:cotizacion.service_order_id)
          sumatoria = detalle.sum(:precio)
          if current_user.catalog_branches_user.map{|x| x.catalog_branch_id}.include? orden.vehicle.catalog_branch_id
            tabla_competencias = CompetitionTable.where("catalog_branch_id = #{orden.vehicle.catalog_branch_id} and tipo = 'Mantenimiento y equipo de transporte' and monto >= #{sumatoria}")
            if tabla_competencias.present?
              tabla_competencias.each do |tab|
                rol_user = CatalogRolesUser.where(user_id: current_user.id)
                if rol_user.map{|x| x.catalog_role_id}.include? tab.catalog_role_id
                  arreglo_competencias.push(tab)
                end
              end
              if arreglo_competencias.length > 0
                cotizacion.update(estatus:"Autorizado")
                if orden.ticket_tire_battery_id
                  orden.update(estatus:"Compra autorizada",usuario_autoriza: "#{current_user.name} #{current_user.last_name}",precio: sumatoria)
                else
                  orden.update(estatus:"Entrada a taller",usuario_autoriza: "#{current_user.name} #{current_user.last_name}",precio: sumatoria)
                  Notification.servicio_autorizado(orden)
                  Notification.servicio_autorizado_usuario(orden)
                  #envio orden y bitacora
                  TicketMailer.correo_talleres(orden).deliver_later
                end
                flash[:notice] = "Orden autorizada con exito."
                redirect_to service_orders_path
              else
                TicketMailer.orden_servicio_competencia(current_user,orden).deliver_later
                flash[:alert] = "Tu rol no cumple con la tabla de competencias."
                redirect_to service_orders_path
              end
            else
              flash[:alert] = "No se encontro la competencia, favor de verificar la información."
              redirect_to service_orders_path
            end
          else
            TicketMailer.orden_servicio_competencia(current_user,orden).deliver_later
            flash[:alert] = "El cedis en el que te encuentras no cumple con la tabla de competencias."
            redirect_to service_orders_path
          end
        else
          flash[:alert] = "No se encontraron cotizaciones para la orden de servicio seleccionada."
          redirect_to service_orders_path
        end
      rescue => exception
        flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
        redirect_to service_orders_path
      end
  end

  def rechazar_cotizacion
    cotizacion = Quote.find_by(id:params[:id])
    orden = ServiceOrder.find_by(id:cotizacion.service_order_id)
    if orden.ticket_tire_battery_id
      if cotizacion.update(estatus:"Rechazado") and orden.update(cotizacion:false,precio:nil,estatus: "Cancelado")
        flash[:notice] = "Favor de agregar el motivo de la cancelación."
        redirect_to motivo_cancelacion_path(orden.id)
      else
        flash[:alert] = "Ocurrio un error."
        redirect_to service_orders_path
      end
    else
      if cotizacion.update(estatus:"Rechazado") and orden.update(cotizacion:false,precio:nil)
        flash[:notice] = "Cotización rechazada con exito, favor de asignar un nuevo taller."
        redirect_to asignar_taller_path(cotizacion.service_order_id)
      else
        flash[:alert] = "Ocurrio un error."
        redirect_to service_orders_path
      end
    end
  end

  def cancelar_orden
    @busqueda = ServiceOrder.find_by(id: params[:id])
      if @busqueda.update(estatus: "Cancelado")
        flash[:notice] = "Favor de agregar el motivo de la cancelación."
        redirect_to motivo_cancelacion_path
      else
        flash[:alert] = "Ocurrio un error."
        redirect_to service_orders_path
      end
  end

  def guardar_motivo
    @service_order = ServiceOrder.find_by(id: params[:id])
    if @service_order.update(motivo_rechazo:params[:motivo])
      flash[:notice] = "Orden cancelada con exito."
      redirect_to service_orders_path
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to service_orders_path
    end
  end
  
  def reagendar_orden
    
  end

  def guardar_fecha_propuesta
    @busqueda = ServiceOrder.find_by(id: params[:id])
    if @busqueda.update(fecha_revision_propuesta:params[:fecha_propuesta],estatus: "Nueva fecha sugerida" )
      #Notification.solicitar_encuesta(@busqueda)
      flash[:notice] = "Se registro la fecha con éxito, por favor espere la autorización."
      redirect_to service_orders_path
    else
      flash[:alert] = "Ocurrio un error"
      redirect_to service_orders_path
    end
  end

  def registrar_salida
  end

  def guardar_fecha_salida
    @busqueda = ServiceOrder.find_by(id: params[:id])
    @parametro_garantia = Parameter.find_by(valor_extendido: "id de garantia")

    if @busqueda
      km = MileageIndicator.select('km_actual','fecha').where(vehicle_id:@busqueda.vehicle_id).last
      if @busqueda.tipo_servicio == "Preventivo" or @busqueda.tipo_servicio == "Preventivo Agencia"
        bitacora = ServiceOrder.guardar_bitacora(@busqueda.vehicle.catalog_brand,@busqueda.vehicle_id,@busqueda.id)
      end
      if @busqueda.update(fecha_salida:params[:fecha_salida],km_actual: km.km_actual,estatus:"Salió de taller")
        Notification.solicitar_encuesta(@busqueda)
        flash[:notice] = "La fecha de salida se registro con éxito."
        redirect_to service_orders_path
      else
        mensaje = "------------------------------*****************"
        flash[:alert] = "Ocurrio un error"
        @busqueda.errors.full_messages.each do |error|
          mensaje += "#{error}. "
        end
        puts mensaje
        redirect_to service_orders_path
      end
    else
      flash[:alert] = "Ocurrio un error"
      redirect_to service_orders_path
    end
  end

  def factura_servicio_orden
    @documentos = ServiceOrder.where(id: params[:id])
    @documento = ServiceOrder.new
    @orden_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_factura_servicio
    id_partida = params[:service_order][:id]
    @documento = ServiceOrder.crear_factura(params, id_partida)
    #byebug
    @resultados = @documento
    @documentos = ServiceOrder.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      respond_to do |format|
        format.html {redirect_to service_orders_path, notice: "#{@documento[0]}" }
      end
    else
      flash[:alert] = @documento[0]
      respond_to do |format|
        format.html {redirect_to service_orders_path, alert: "#{@documento[0]}" }
      end
    end
  end

  def pdf_orden
    @documentos = ServiceOrder.where(id: params[:id])
    @documento = ServiceOrder.new
    @orden_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_pdf_orden
    id_partida = params[:service_order][:id]
    @documento = ServiceOrder.crear_pdf(params, id_partida)
    @resultados = @documento
    @documentos = ServiceOrder.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to service_orders_path
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end

  def generar_solicitud
    @encabezado = ServiceOrder.find_by(id: params[:service_order_id])
    @km_actual = MileageIndicator.select('km_actual').where(vehicle_id: @encabezado.vehicle_id).last
    @datos = ServiceOrder.historial_gastos(@encabezado)
    @conceptos_dos = @datos[0]
    @total_dos = @datos[1]
    @conceptos_uno = @datos[2]
    @total_uno = @datos[3]
    @conceptos_actual = @datos[4]
    @total_actual = @datos[5]
    @programa = MaintenanceProgram.find_by(vehicle_id: @encabezado.vehicle.id)
    if @programa
      @gasto_km = @total_actual/@programa.km_recorrido_curso
    else
      @gasto_km = 0  
    end
    #byebug
  end

  def registrar_servicio
    @orden = ServiceOrder.find_by(id: params[:id])
    @servicios = AdditionalService.where(service_order_id:params[:id])
    @servicios_pendientes = AdditionalService.where(service_order_id:params[:id],estatus: "Pendiente de autorizar")
    #byebug
  end

  def guardar_servicio
     @orden = ServiceOrder.find_by(id: params[:id])
    #byebug
    if @orden
      numero_consecutivo = AdditionalService.last
      numero_consecutivo ? nuevo_numero = numero_consecutivo.clave.to_i + 1 : nuevo_numero = 1
      registro = AdditionalService.create(service_order_id:@orden.id,clave:nuevo_numero,descripcion:params[:descripcion],costo:params[:costo],estatus:"Pendiente de autorizar")
      flash[:notice] = "Se registraron los datos con éxito."
      redirect_to registrar_servicio_path
    else
      flash[:alert] = "Ocurrio un error"
      redirect_to service_orders_path
    end
  end

  def solicitar_servicio
    orden = ServiceOrder.find_by(id: params[:id])
    if orden
      orden.update(adicional_archivo:params[:archivo],estatus:"Esperando autorización")
      if orden.save
        Notification.peticion_adicionales(orden)
        flash[:notice] = "Solicitud enviada con éxito."
        redirect_to service_orders_path
      else
        orden.errors.full_messages.each do |error|
          #byebug
          flash[:alert] = "Ocurrio un error."
          redirect_to service_orders_path
        end
      end
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to service_orders_path
    end
  end

  def autorizar_servicio_adicional
    orden = ServiceOrder.find_by(id: params[:id])
    arreglo_competencias = Array.new
    if orden
      adicionales = AdditionalService.where(service_order_id: orden.id,estatus:"Pendiente de autorizar")
      sumatoria = adicionales.sum(:costo)
      if current_user.catalog_branches_user.map{|x| x.catalog_branch_id}.include? orden.vehicle.catalog_branch_id
        tabla_competencias = CompetitionTable.where("catalog_branch_id = #{orden.vehicle.catalog_branch_id} and tipo = 'Mantenimiento y equipo de transporte' and monto >= #{sumatoria}")
        if tabla_competencias.present?
          tabla_competencias.each do |tab|
            rol_user = CatalogRolesUser.where(user_id: current_user.id)
            if rol_user.map{|x| x.catalog_role_id}.include? tab.catalog_role_id
              arreglo_competencias.push(tab)
            end
          end
          if arreglo_competencias.length > 0
            if orden.update(estatus:"Autorizada",precio:sumatoria,usuario_autoriza: "#{current_user.name} #{current_user.last_name}") and adicionales.update(estatus: "Autorizado")
              Notification.adicionales_autorizados(orden)
              flash[:notice] = "Servicios adicionales autorizados con éxito."
              redirect_to service_orders_path
            else
              orden.errors.full_messages.each do |error|
                flash[:alert] = "Ocurrio un error."
                redirect_to service_orders_path
              end
            end
          else
            TicketMailer.orden_servicio_competencia(current_user,orden).deliver_later
            flash[:alert] = "Tu rol no cumple con la tabla de competencias."
            redirect_to service_orders_path
          end
        else
          flash[:alert] = "No se encontro la competencia, favor de verificar la información."
          redirect_to service_orders_path
        end
      else
        TicketMailer.orden_servicio_competencia(current_user,orden).deliver_later
        flash[:alert] = "El cedis en el que te encuentras no cumple con la tabla de competencias."
        redirect_to service_orders_path
      end
    
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to service_orders_path
    end
  end

  def rechazar_servicio_adicional
    orden = ServiceOrder.find_by(id: params[:id])
    if orden
      adicionales = AdditionalService.where(service_order_id: orden.id,estatus:"Pendiente de autorizar")
      if orden.update(estatus:"Rechazada") and adicionales.update(estatus:"Rechazado")
        #byebug
        Notification.adicionales_rechazados(orden)
        flash[:notice] = "Servicios adicionales rechazados con éxito."
        redirect_to motivo_cancelacion_path(orden.id)
      else
        orden.errors.full_messages.each do |error|
          #byebug
          flash[:alert] = "Ocurrio un error."
          redirect_to service_orders_path
        end
      end
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to service_orders_path
    end
  end

  def imprimir_solicitud_mmto
    @encabezado = ServiceOrder.find_by(id: params[:service_order_id])
    @km_actual = MileageIndicator.select('km_actual').where(vehicle_id: @encabezado.vehicle_id).last

    @datos = ServiceOrder.historial_gastos(@encabezado)
    @conceptos_dos = @datos[0]
    @total_dos = @datos[1]
    @conceptos_uno = @datos[2]
    @total_uno = @datos[3]
    @conceptos_actual = @datos[4]
    @total_actual = @datos[5]
    @programa = MaintenanceProgram.find_by(vehicle_id: @encabezado.vehicle.id)
    if @programa
      @gasto_km = @total_actual/@programa.km_recorrido_curso
    else
      @gasto_km = 0  
    end
  
    respond_to do |format|
			format.html
			format.pdf do
			render pdf: "imprimir",
			template: "service_orders/solicitud_autorizacion.html.erb",
			layout: 'solicitud_pago.html',
			orientation: 'Portrait'
			end
		end
  end

  def indicador_costo_mantenimiento
    session["menu2"] = "Indicador costo mantenimiento por km por vehículo"
    #byebug
  end

  def filtrado_costos
    @bandera_error = false
    actual = Date.today.year
    arreglo = []
    arreglo2 = []
    @vehiculos =[]
    @resultados = []
    @numero = []
    @gasto =  []
    
    #byebug
    if !@bandera_error
      if params[:catalog_branch_id] != ""
        if params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_branch_id: params[:catalog_branch_id])
        elsif params[:catalog_area_id] != "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_branch_id: params[:catalog_branch_id],catalog_area_id: params[:catalog_area_id])
        elsif params[:catalog_area_id] = "" and params[:vehicle_id] != "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(id:params[:vehicle_id])
        elsif params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] != "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_branch_id: params[:catalog_branch_id],catalog_personal_id:params[:catalog_personal_id])
        elsif params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] != "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_branch_id: params[:catalog_branch_id],vehicle_type_id:params[:vehicle_type_id])
        elsif  params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] != ""
          vehicles = Vehicle.where(catalog_branch_id: params[:catalog_branch_id],catalog_brand_id:params[:catalog_brand_id])
        end
      elsif params[:catalog_company_id] != ""
        if params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_company_id: params[:catalog_company_id])
        elsif params[:catalog_area_id] != "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_company_id: params[:catalog_company_id],catalog_area_id: params[:catalog_area_id])
        elsif params[:catalog_area_id] = "" and params[:vehicle_id] != "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(id:params[:vehicle_id])
        elsif params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] != "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_company_id: params[:catalog_company_id],catalog_personal_id:params[:catalog_personal_id])
        elsif params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] != "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_company_id: params[:catalog_company_id],vehicle_type_id:params[:vehicle_type_id])
        elsif  params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] != ""
          vehicles = Vehicle.where(catalog_company_id: params[:catalog_company_id],catalog_brand_id:params[:catalog_brand_id])
        end
      else
        if params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.all
        elsif params[:catalog_area_id] != "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_area_id: params[:catalog_area_id])
        elsif params[:catalog_area_id] = "" and params[:vehicle_id] != "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(id:params[:vehicle_id])
        elsif params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] != "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(catalog_personal_id:params[:catalog_personal_id])
        elsif params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] != "" and params[:catalog_brand_id] == ""
          vehicles = Vehicle.where(vehicle_type_id:params[:vehicle_type_id])
        elsif  params[:catalog_area_id] == "" and params[:vehicle_id] == "" and params[:catalog_personal_id] == "" and params[:vehicle_type_id] == "" and params[:catalog_brand_id] != ""
          vehicles = Vehicle.where(catalog_brand_id:params[:catalog_brand_id])
        end
      end

      vehicles.each do |veh|
        sumatoria = MaintenanceControl.joins(:vehicle).select('sum(importe) as suma').where(vehicles:{id: veh.id},año:actual).group(:vehicle_id)
        gastos = MaintenanceProgram.joins(:vehicle).select('km_recorrido_curso').where(vehicles:{id: veh.id})
        if sumatoria[0] != nil and gastos[0] != nil
          gasto_km =  sumatoria[0].suma.to_f/gastos[0].km_recorrido_curso.to_f
          @resultados.push(numero: veh.numero_economico,gasto:gasto_km)
          @numero.push(veh.numero_economico)
          @gasto.push(gasto_km.round(2))
        end
      end
      if @resultados == []
        @mensaje = "No se encontró información de este año en el CEDIS seleccionado."
        @bandera_error = true
      end
    end
  end

  def filtrado_gastos
    @bandera_error = false
    dos_an = I18n.l(Time.now - 2.years,format: '%Y')
    un_an = I18n.l(Time.now - 1.years,format: '%Y')
    actual = I18n.l(Time.now,format: '%Y')
    anio = params[:anio]
    if params[:anio].nil? or params[:anio] == ""
			@bandera_error = true
      @mensaje = "Seleccione el Año."
    end
    servicio = ServiceOrder.find_by(id: params[:id])
    if !@bandera_error
      if anio == "0"
        @resultados = MaintenanceControl.where(vehicle_id:servicio.vehicle_id,año:dos_an)
      elsif anio == "1"
        @resultados = MaintenanceControl.where(vehicle_id:servicio.vehicle_id,año:un_an)
      elsif anio == "2"
        @resultados = MaintenanceControl.where(vehicle_id:servicio.vehicle_id,año:actual)
      end
      if @resultados == []
        @mensaje = "No se encontró información."
        @bandera_error = true
      end
    end
  end
  
  def binnacle
    @resultados = []
    @service_orders = ServiceOrder.find_by(id:params[:id_order])
    @ultimo_km = MileageIndicator.select('km_actual','fecha').where(vehicle_id:@service_orders.vehicle_id).last
    valor = Parameter.find_by(valor: "Valor para bitacora")
    if valor
      if @service_orders.estatus == "Servicio Finalizado" or @service_orders.estatus == "Salió de taller"
        @resultados = BinnacleOrder.where(service_order_id:@service_orders.id)
      else
        @resultados = ServiceOrder.ver_servicios(@service_orders.vehicle.catalog_brand,@service_orders.vehicle_id)[0]
        if @resultados == []
          flash[:alert] = "No se encontró la bitácora para esta línea de vehículo, favor de revisar los catálogos de categorías de conceptos de mantenimiento y conceptos de mantenimiento."
          redirect_to service_orders_path
        end
      end
    else
      flash[:alert] = "No se encontró el parámetro de la bitácora, favor de revisar los parametros."
      redirect_to service_orders_path
    end
  end

  def finalizar_servicio
    @service_order = ServiceOrder.find_by(id: params[:id]) 
  end

  def registrar_control
    begin
      @service_order = ServiceOrder.find_by(id: params[:id])
      if @service_order.catalog_workshop_id
        dias_taller = ((@service_order.fecha_salida - @service_order.fecha_entrada).to_f / 1.day).floor
        control_mmto = MaintenanceControl.new(vehicle_id:@service_order.vehicle_id,mes_pago:I18n.l(Date.today,format: '%B'),catalog_workshop_id:@service_order.catalog_workshop_id,catalog_repair_id:params[:catalog_repair_id],observaciones:params[:observaciones],fecha_factura:Date.today.strftime('%Y-%m-%d'),año:Date.today.year,importe:0,importe_iva:0,ciudad:params[:ciudad],km_actual:params[:km_actual],dias_taller:dias_taller,service_order_id:@service_order.id,estatus:"Completado")
        @service_order.update(estatus:"Servicio Finalizado")
      else
        control_mmto = MaintenanceControl.new(vehicle_id:@service_order.vehicle_id,mes_pago:I18n.l(Date.today,format: '%B'),catalog_vendor_id:@service_order.catalog_vendor_id,catalog_repair_id:params[:catalog_repair_id],observaciones:params[:observaciones],fecha_factura:Date.today.strftime('%Y-%m-%d'),año:Date.today.year,importe:0,importe_iva:0,ciudad:params[:ciudad],km_actual:params[:km_actual],dias_taller:dias_taller,service_order_id:@service_order.id,estatus:"Completado")
        busqueda_tk = TicketTireBattery.find_by(id:@service_order.ticket_tire_battery_id)
        busqueda_tk.update(estatus:"Pendiente de entrega")
        @service_order.update(estatus:"Compra Realizada")
      end
  
      if control_mmto.save 
        flash[:notice] = "Control de mantenimiento creado con exito."
        redirect_to service_orders_path
      else
        flash[:alert] = "Ocurrio un error"
        redirect_to service_orders_path
      end
      
    rescue => exception
      flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
      redirect_to service_orders_path
    end
  end

  private

    def validacion_menu
      session["menu1"] = "Mantenimiento"
      session["menu2"] = "Ordenes de servicio"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_service_order
      @service_order = ServiceOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_order_params
      params.require(:service_order).permit(:n_orden, :estatus, :descripcion, :fecha_entrada, :fecha_salida, :maintenance_program_id, :maintenance_appointment_id,:cotizacion)
    end
end
