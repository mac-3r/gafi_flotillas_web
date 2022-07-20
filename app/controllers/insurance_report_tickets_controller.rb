class InsuranceReportTicketsController < ApplicationController
  before_action :set_insurance_report_ticket, only: [:show, :edit, :update, :destroy, :generar_ticket_siniestrabilidad]
  load_and_authorize_resource
	before_action :validacion_menu

  # GET /insurance_report_tickets
  # GET /insurance_report_tickets.json
  def index
    @tipos_siniestro = TypeSinister.where(status: true).order(nombreSiniestro: :asc)
    @cedis = CatalogBranch.find_by(status: true)
    @contador = InsuranceReportTicket.all.count
    session["tck_aseg_nec"] = ""
    session["tck_aseg_ced"] = ""
    session["tck_aseg_sta"] = "Todos"
    session["tck_aseg_reg"] = "Todos"
    session["tck_aseg_sin"] = ""
    session["tck_aseg_fini"] = Time.zone.now.to_date
    session["tck_aseg_ffin"] = Time.zone.now.to_date

    @insurance_report_tickets = InsuranceReportTicket.consulta_tickets(session["tck_aseg_nec"],session["tck_aseg_ced"],session["tck_aseg_sta"],session["tck_aseg_fini"],session["tck_aseg_ffin"],session["tck_aseg_reg"],session["tck_aseg_sin"] ).order(fecha_ocurrio: :asc)

  end

  def filtrado_tickets_aseguradora
    session["tck_aseg_nec"] = params[:keyword]
    session["tck_aseg_ced"] = params[:catalog_branch_id]
    session["tck_aseg_sta"] = params[:status]
    session["tck_aseg_reg"] = params[:registro]
    session["tck_aseg_sin"] = params[:siniestro]
    
    if params[:start_date] != "" and params[:end_date] != ""
      session["tck_aseg_fini"] = Date.strptime(params[:start_date], "%d/%m/%Y")
      session["tck_aseg_ffin"] = Date.strptime(params[:end_date], "%d/%m/%Y")
    else
      session["tck_aseg_fini"] = ""
      session["tck_aseg_ffin"] = ""
    end

    @insurance_report_tickets = InsuranceReportTicket.consulta_tickets(session["tck_aseg_nec"],session["tck_aseg_ced"],session["tck_aseg_sta"],session["tck_aseg_fini"],session["tck_aseg_ffin"],session["tck_aseg_reg"],session["tck_aseg_sin"] ).order(fecha_ocurrio: :asc)
    respond_to do |format|
      format.js
    end
  end

  # GET /insurance_report_tickets/1
  # GET /insurance_report_tickets/1.json
  def show
    @numero_sig = (InsuranceReportTicket.where.not(folio: nil).count) + 1
  end

  # GET /insurance_report_tickets/new
  def new
    @tipos_siniestro = TypeSinister.where(status: true).order(nombreSiniestro: :asc)
    @vehiculos = Vehicle.listado_vehiculos
    @insurance_report_ticket = InsuranceReportTicket.new
  end

  # GET /insurance_report_tickets/1/edit
  def edit
    @tipos_siniestro = TypeSinister.where(status: true).order(nombreSiniestro: :asc)
    @vehiculos = Vehicle.listado_vehiculos
  end

  # POST /insurance_report_tickets
  # POST /insurance_report_tickets.json
  def create
    begin
      vehiculo = Vehicle.find_by(numero_economico: params[:insurance_report_ticket][:numero_economico])
      siniestro = TypeSinister.find_by(id: params[:insurance_report_ticket][:type_sinisters_id], status: true)
      params[:insurance_report_ticket][:vehicle_id] = vehiculo.id
      #params[:insurance_report_ticket][:numero_economico_veh] = vehiculo.numero_economico
      params[:insurance_report_ticket][:cedis] = vehiculo.catalog_branch.decripcion
      params[:insurance_report_ticket][:numero_serie] = vehiculo.numero_serie
      params[:insurance_report_ticket][:vehiculo] = "#{vehiculo.catalog_brand.descripcion}"
      params[:insurance_report_ticket][:modelo] = vehiculo.catalog_model.descripcion
      params[:insurance_report_ticket][:estatus_vehiculo] = vehiculo.vehicle_status.descripcion
      params[:insurance_report_ticket][:type_sinisters_id] = siniestro.id
      params[:insurance_report_ticket][:tipo_siniestro] = siniestro.nombreSiniestro
      params[:insurance_report_ticket][:responsable] = vehiculo.catalog_personal.nombre
      params[:insurance_report_ticket][:inciso] = vehiculo.inciso
      params[:insurance_report_ticket][:numero_poliza] = vehiculo.numero_poliza
      params[:insurance_report_ticket][:estatus] = "Abierto"
      params[:insurance_report_ticket][:fecha_ocurrio] = params[:insurance_report_ticket][:fecha_ocurrio].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
      params[:insurance_report_ticket][:fecha_reporte] = params[:insurance_report_ticket][:fecha_reporte].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
      consulta_corte = Deadline.where("fecha_inicio <= '#{params[:insurance_report_ticket][:fecha_ocurrio]}' and fecha_fin >= '#{params[:insurance_report_ticket][:fecha_ocurrio]}'")
      if params[:insurance_report_ticket][:estatus_responsabilidad_gafi] == params[:insurance_report_ticket][:estatus_responsabilidad_aseguradora]
        params[:insurance_report_ticket][:coincide] = "Verdadero"
      else
        params[:insurance_report_ticket][:coincide] = "Falso"
      end
      params[:insurance_report_ticket][:catalog_area_id] = vehiculo.catalog_area_id
      @insurance_report_ticket = InsuranceReportTicket.new(insurance_report_ticket_params)
      respond_to do |format|
        #format.js
        if consulta_corte.length > 0
          @mensaje = "Ya se realizó el corte para las fechas seleccionadas"
          format.js
        else
          if @insurance_report_ticket.save
            #@insurance_report_ticket.update(folio: "R#{@insurance_report_ticket.id}")
            format.html { redirect_to @insurance_report_ticket, notice: 'Insurance report ticket was successfully created.' }
            format.json { render :show, status: :created, location: @insurance_report_ticket }
          else
            @tipos_siniestro = TypeSinister.where(status: true).order(nombreSiniestro: :asc)
            @vehiculos = Vehicle.listado_vehiculos
            format.html { render :new }
            format.json { render json: @insurance_report_ticket.errors, status: :unprocessable_entity }
          end
        end
      end
    rescue => exception
      redirect_to insurance_report_tickets_path
      flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /insurance_report_tickets/1
  # PATCH/PUT /insurance_report_tickets/1.json
  def update
    begin
      vehiculo = Vehicle.find_by(numero_economico: params[:insurance_report_ticket][:numero_economico])
      siniestro = TypeSinister.find_by(id: params[:insurance_report_ticket][:type_sinisters_id], status: true)
      params[:insurance_report_ticket][:vehicle_id] = vehiculo.id
      params[:insurance_report_ticket][:cedis] = vehiculo.catalog_branch.decripcion
      params[:insurance_report_ticket][:numero_serie] = vehiculo.numero_serie
      #params[:insurance_report_ticket][:numero_economico_veh] = vehiculo.numero_economico
      params[:insurance_report_ticket][:vehiculo] = "#{vehiculo.catalog_brand.descripcion}"
      params[:insurance_report_ticket][:modelo] = vehiculo.catalog_model.descripcion
      params[:insurance_report_ticket][:estatus_vehiculo] = vehiculo.vehicle_status.descripcion
      params[:insurance_report_ticket][:type_sinisters_id] = siniestro.id
      params[:insurance_report_ticket][:tipo_siniestro] = siniestro.nombreSiniestro
      params[:insurance_report_ticket][:responsable] = vehiculo.catalog_personal.nombre
      #params[:insurance_report_ticket][:estatus] = "Abierto"
      params[:insurance_report_ticket][:inciso] = vehiculo.inciso
      params[:insurance_report_ticket][:numero_poliza] = vehiculo.numero_poliza
      params[:insurance_report_ticket][:fecha_ocurrio] = params[:insurance_report_ticket][:fecha_ocurrio].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
      params[:insurance_report_ticket][:fecha_reporte] = params[:insurance_report_ticket][:fecha_reporte].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
      if params[:insurance_report_ticket][:estatus_responsabilidad_gafi] == params[:insurance_report_ticket][:estatus_responsabilidad_aseguradora]
        params[:insurance_report_ticket][:coincide] = "Verdadero"
      else
        params[:insurance_report_ticket][:coincide] = "Falso"
      end
      params[:insurance_report_ticket][:catalog_area_id] = vehiculo.catalog_area_id
      consulta_corte = Deadline.where("fecha_inicio <= '#{params[:insurance_report_ticket][:fecha_ocurrio]}' and fecha_fin >= '#{params[:insurance_report_ticket][:fecha_ocurrio]}'")
      respond_to do |format|
        if consulta_corte.length > 0
          @mensaje = "Ya se realizó el corte para las fechas seleccionadas"
          format.js
        else
          if @insurance_report_ticket.update(insurance_report_ticket_params)
            format.html { redirect_to @insurance_report_ticket, notice: 'Ticket actualizado con éxito.' }
            format.json { render :show, status: :ok, location: @insurance_report_ticket }
          else
            @tipos_siniestro = TypeSinister.where(status: true).order(nombreSiniestro: :asc)
            @vehiculos = Vehicle.listado_vehiculos
            format.html { render :edit }
            format.json { render json: @insurance_report_ticket.errors, status: :unprocessable_entity }
          end
        end
      end
    rescue => exception
      redirect_to insurance_report_tickets_path
      flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
    end
  end

  def consulta_vehiculo_serie
    #@vehiculo = Vehicle.consulta_x_numeconomico(params[:num_economico])
    @vehiculo = Vehicle.find_by(numero_economico: params[:num_economico])
    respond_to do |format|
      format.js
    end
  end

  # DELETE /insurance_report_tickets/1
  # DELETE /insurance_report_tickets/1.json
  def destroy
    if @insurance_report_ticket.estatus == "Abierto" or @insurance_report_ticket.estatus == "En Captura"
      @insurance_report_ticket.update(estatus: "Cancelado")
      flash[:notice] = "Ticket cancelado con éxito."
    else
      flash[:alert] = "Este ticket ya no se puede cancelar."
    end
    respond_to do |format|
      format.html { redirect_to insurance_report_tickets_url}
      format.json { head :no_content }
    end
  end

  def generar_ticket_siniestrabilidad
    numero_sig = (InsuranceReportTicket.where.not(folio: nil).count) + 1
    if @insurance_report_ticket.update(folio: "R#{numero_sig}", estatus: "Abierto")
      flash[:notice] = "Ticket generado con éxito"
    else
      mensaje = ""
      @insurance_report_ticket.erros.full_messages.each do |error|
        mensaje += "#{error}. "
      end
      flash[:alert] = mensaje
    end
    redirect_to insurance_report_tickets_path
    
  end

  def reporte_tickets_siniestrabilidad_excel
    require 'axlsx'
    if session["tck_aseg_fini"] != "" and session["tck_aseg_ffin"] != ""
      fini = session["tck_aseg_fini"]
      ffin = session["tck_aseg_ffin"]
      fecha_i = ActiveSupport::TimeZone['UTC'].parse(fini)
      fecha_f = ActiveSupport::TimeZone['UTC'].parse(ffin)
      tickets = InsuranceReportTicket.consulta_tickets(session["tck_aseg_nec"],session["tck_aseg_ced"],session["tck_aseg_sta"], fecha_i,fecha_f,session["tck_aseg_reg"],session["tck_aseg_sin"] )
    else
      tickets = InsuranceReportTicket.consulta_tickets(session["tck_aseg_nec"],session["tck_aseg_ced"],session["tck_aseg_sta"], session["tck_aseg_fini"] , session["tck_aseg_ffin"],session["tck_aseg_reg"],session["tck_aseg_sin"] )
    end
    #tickets = InsuranceReportTicket.all
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.styles do |s|
        miles_decimal = s.add_style(:format_code => "$###,###.00")
        celda_1 = s.add_style :b => true, :font_name => 'Arial', :bg_color => "969696", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
        celda_afectado = s.add_style :b => true, :font_name => 'Arial', :bg_color => "ffffff", :fg_color => "00", :sz => 10, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
        celda_responsable = s.add_style :b => true, :font_name => 'Arial', :bg_color => "fff176", :fg_color => "00", :sz => 10, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
        miles_afectado = s.add_style :b => true, :font_name => 'Arial', :bg_color => "ffffff", :fg_color => "00", :sz => 10, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}, :format_code => "$###,###.00"
        miles_responsable = s.add_style :b => true, :font_name => 'Arial', :bg_color => "fff176", :fg_color => "00", :sz => 10, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}, :format_code => "$###,###.00"
        workbook.add_worksheet(name: "BaseDatosGafi") do |sheet|
          sheet.add_row ["Siniestro","Compañia","Póliza","No. Económico","Cedis", "Conductor",  "Modelo", "Tipo Vehículo", "Monto Siniestro", "Fecha Siniestro", "Mes", "Tipo Siniestro","Declaración", "Responsabilidad Determinada x Gafi", "Responsabilidad Determinada Aseguradora", "¿Igual?", "Deducible Gafi", "Deducible empleado", "Status Auto/Camion", "Contacto", "Estatus del Ticket", "Comentarios Adicionales"], style: [celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1, celda_1] #, :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00", :fg_color => "96" }
          tickets.each do |resultado|
            resultado.estatus_responsabilidad_gafi == 0 ? responsabilidad_gafi = "Responsable" : responsabilidad_gafi = "Afectado"
            resultado.estatus_responsabilidad_aseguradora == 0 ? responsabilidad_aseguradora = "Responsable" : responsabilidad_aseguradora = "Afectado"
            if responsabilidad_gafi == "Responsable"
              sheet.add_row ["#{resultado.numero_siniestro}","#{resultado.vehicle.catalog_company.nombre}","#{resultado.numero_poliza}", "#{resultado.numero_economico}", resultado.cedis, resultado.responsable, resultado.modelo, resultado.vehiculo, "#{resultado.monto_siniestro}", resultado.fecha_ocurrio.strftime("%d/%m/%Y"), "#{resultado.fecha_ocurrio.strftime("%B")}", resultado.tipo_siniestro, resultado.declaracion, responsabilidad_gafi, responsabilidad_aseguradora, resultado.coincide, resultado.cargo_deducible_empresa, resultado.cargo_deducible_empleado, resultado.estatus_vehiculo, resultado.contacto, resultado.estatus, resultado.comentarios_adicionales], style: [celda_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable,miles_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable, miles_responsable, miles_responsable, celda_responsable, celda_responsable, celda_responsable, celda_responsable]
            else
              sheet.add_row ["#{resultado.numero_siniestro}","#{resultado.vehicle.catalog_company.nombre}","#{resultado.numero_poliza}", "#{resultado.numero_economico}", resultado.cedis, resultado.responsable, resultado.modelo, resultado.vehiculo, "#{resultado.monto_siniestro}", resultado.fecha_ocurrio.strftime("%d/%m/%Y"), "#{resultado.fecha_ocurrio.strftime("%B")}", resultado.tipo_siniestro, resultado.declaracion, responsabilidad_gafi, responsabilidad_aseguradora, resultado.coincide, resultado.cargo_deducible_empresa, resultado.cargo_deducible_empleado, resultado.estatus_vehiculo, resultado.contacto, resultado.estatus, resultado.comentarios_adicionales], style: [celda_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado,miles_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado, miles_afectado, miles_afectado, celda_afectado, celda_afectado, celda_afectado, celda_afectado]
            end
          end
        end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Tickets de siniestrabilidad.xlsx"
  end

  def corte_ticket_aseguradora
    InsuranceReportTicket.transaction do
      corte = Deadline.create(fecha_inicio: session["tck_aseg_fini"], fecha_fin: session["tck_aseg_ffin"])
      if corte.save
        insurance_report_tickets = InsuranceReportTicket.consulta_tickets(session["tck_aseg_nec"],session["tck_aseg_ced"],session["tck_aseg_sta"],session["tck_aseg_fini"].to_date,session["tck_aseg_ffin"].to_date,session["tck_aseg_reg"],session["tck_aseg_sin"] )
        #actualizar = insurance_report_tickets.update(estatus: "Abierto", deadline_id: corte.id)
        if insurance_report_tickets.where(estatus: "Abierto").update(estatus: "Cerrado", deadline_id: corte.id)
          flash[:notice] = "Corte realizado con éxito."
          redirect_to insurance_report_tickets_path
        else
            mensaje = "Ocurrió un error: "
            insurance_report_tickets.errors.full_messages.each do |error|
              mensaje += "#{error}. "
            end
            flash[:alert] = mensaje
            raise ActiveRecord::Rollback
            redirect_to insurance_report_tickets_path
        end
      else
        mensaje = "Ocurrió un error: "
        corte.errors.full_messages.each do |error|
          mensaje += "#{error}. "
        end
        flash[:alert] = mensaje
        raise ActiveRecord::Rollback
        redirect_to insurance_report_tickets_path
      end
    end
  end

  def corte_ticket
    @ticket = InsuranceReportTicket.find_by(id: params[:id])
    if @ticket
      @ticket.update(estatus:2)
      flash[:notice] = "Ticket cerrado con éxito."
      redirect_to insurance_report_tickets_path
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to insurance_report_tickets_path
    end
  end

  def reabrir_ticket
    @ticket = InsuranceReportTicket.find_by(id: params[:id])
    if @ticket
      if @ticket.update(estatus: 1)
        flash[:notice] = "Ticket reabierto con éxito."
        redirect_to insurance_report_tickets_path
      else
        @ticket.errors.full_messages.each do |error|
        end
        flash[:alert] = "Ocurrió un error."
        redirect_to insurance_report_tickets_path
      end
    else
      flash[:alert] = "No existe el ticket seleccionado."
      redirect_to insurance_report_tickets_path
    end
  end

  def claims_branch_indicator
    session["menu1"] = "Siniestralidad"
    session["menu2"] = "Indicador siniestros por cedis"
  end

  def filtrado_indicadores_cedis
    cedis = params[:catalog_branch_id]
    empresa = params[:catalog_company_id]
    responsabilidad = params[:responsabilidad]
    area = params[:area_id]
    vehiculo = params[:vehicle_id]
    anio = params[:anio]
    @bandera_error = false
    @resultados = InsuranceReportTicket.consulta_siniestros_indicador_fecha(empresa,cedis,responsabilidad,area,vehiculo,anio)
    if @resultados == []
      @mensaje = "No se encontró información."
      @bandera_error = true
    end
  end
  
  private
    def validacion_menu
      session["menu1"] = "Siniestralidad"
      session["menu2"] = "Administración de tickets"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_insurance_report_ticket
      @insurance_report_ticket = InsuranceReportTicket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def insurance_report_ticket_params
      params.require(:insurance_report_ticket).permit(:numero_siniestro, :inciso, :fecha_ocurrio, :fecha_reporte, :vehicle_id, :numero_serie, :numero_poliza, :cedis, :numero_economico, :vehiculo, :modelo, :estatus_vehiculo, :type_sinisters_id, :tipo_siniestro, :ubicacion_siniestro, :responsable, :estatus, :monto_siniestro, :cargo_deducible_empresa, :cargo_deducible_empleado, :declaracion, :estatus_responsabilidad_gafi, :estatus_responsabilidad_aseguradora, :coincide, :comentarios_adicionales, :imagen_antes, :imagen_despues, :folio, :contacto, :registro, :catalog_area_id)
    end
end
