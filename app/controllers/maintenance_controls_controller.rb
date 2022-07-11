class MaintenanceControlsController < ApplicationController
  before_action :set_maintenance_control, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /maintenance_controls
  # GET /maintenance_controls.json
  def index
    session["vehiculo_hi"] = ""
    session["empresa_hi"] = ""
    session["cedis_hi"] = ""
    session["user_hi"] = ""
    session["tipo_hi"] = ""
    session["linea_hi"] = ""
    session["area_hi"] = ""
    session["reparacion_hi"] = ""
    session["fecha_hi"] = ""
    session["folio_hi"] = ""
    @maintenance_controls = MaintenanceControl.consulta_historico(session["vehiculo_hi"],session["empresa_hi"],session["cedis_hi"], session["user_hi"], session["tipo_hi"], session["linea_hi"], session["area_hi"],session["reparacion_hi"], session["fecha_hi"],session["folio_hi"])
  end
 
  def filtrado_historico
    session["vehiculo_hi"] = params[:vehicle_id]
    session["empresa_hi"] = params[:catalog_company_id]
    session["cedis_hi"] = params[:catalog_branch_id]
    session["user_hi"] = params[:catalog_personal_id]
    session["tipo_hi"] = params[:vehicle_type_id]
    session["linea_hi"] = params[:catalog_brand_id]
    session["area_hi"] = params[:catalog_area_id]
    session["reparacion_hi"] = params[:catalog_repair_id]
    session["folio_hi"] = params[:folio]
    if params[:start_date] != ""
      session["fecha_hi"] = params[:start_date]
    else
      session["fecha_hi"] = ""
    end
    @maintenance_controls = MaintenanceControl.consulta_historico(session["vehiculo_hi"],session["empresa_hi"],session["cedis_hi"], session["user_hi"], session["tipo_hi"], session["linea_hi"], session["area_hi"],session["reparacion_hi"], session["fecha_hi"],session["folio_hi"])
    respond_to do |format|
      format.js
    end
  end

  def control_mantenimiento_excel
    maintenance_controls = MaintenanceControl.all.order(fecha_factura: :desc)
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.styles do |s|
    miles_decimal = s.add_style(:format_code => "###,###.00")
    workbook.add_worksheet(name: "Mantenimiento") do |sheet|
      sheet.add_row [""]
      sheet.add_row [""]
      sheet.add_row ["CONTROL DE MANTENIMIENTO"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
      sheet.add_row [""]
      sheet.add_row [""]
      sheet.add_row ["No. Económico","CEDIS","Línea","Modelo","Tipo de vehículo", "Usuario", "Área","Km actual","Días taller","Fecha factura","# Taller","Taller","# Reparación","Detalle","Reparación","Observaciones"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
      maintenance_controls.each do |mmto|
        sheet.add_row [mmto.vehicle.numero_economico, mmto.vehicle.catalog_branch.decripcion,mmto.vehicle.catalog_brand.descripcion,mmto.vehicle.catalog_model.descripcion,mmto.vehicle.vehicle_type.descripcion,mmto.vehicle.catalog_personal.nombre,mmto.vehicle.catalog_area.descripcion,mmto.km_actual,mmto.dias_taller,mmto.fecha_factura,mmto.catalog_workshop_id ? mmto.catalog_workshop.clave : "N/A",mmto.catalog_workshop_id ? mmto.catalog_workshop.nombre_taller : "N/A",mmto.catalog_repair_id ? mmto.catalog_repair.clave : "N/A",mmto.catalog_repair_id ? mmto.catalog_repair.categoria : "N/A",mmto.catalog_repair_id ? mmto.catalog_repair.subcategoria : "N/A",mmto.observaciones]
        end
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Control de mantenimiento.xlsx"
  end
  # GET /maintenance_controls/1
  # GET /maintenance_controls/1.json
  def show
  end

  # GET /maintenance_controls/new
  def new
    @maintenance_control = MaintenanceControl.new
  end

  # GET /maintenance_controls/1/edit
  def edit
  end

  def cargar_xml
    @documento = MaintenanceControl.crear_documento(params)
    redirect_to edit_maintenance_control_path(@documento[2])
  end
  # POST /maintenance_controls
  # POST /maintenance_controls.json
  def create
    @maintenance_control = MaintenanceControl.new(maintenance_control_params)
    params[:maintenance_control][:vehicle_id] = params[:maintenance_control][:vehicle_id]
    params[:maintenance_control][:catalog_branch_id] = params[:maintenance_control][:catalog_branch_id]
    params[:maintenance_control][:catalog_workshop_id] = params[:maintenance_control][:catalog_workshop_id]
    params[:maintenance_control][:catalog_repair_id] = params[:maintenance_control][:catalog_repair_id]
    respond_to do |format|
      if @maintenance_control.save
        format.html { redirect_to maintenance_controls_path, notice: 'El mantenimiento se creó con exito.' }
        format.json { render :show, status: :created, location: @maintenance_control }
      else
        format.html { render :new }
        format.json { render json: @maintenance_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_controls/1
  # PATCH/PUT /maintenance_controls/1.json
  def update
    begin
      if !params[:maintenance_control][:base].present?
        params[:maintenance_control][:base] = false
      else
        params[:maintenance_control][:base] = true
      end
  
      respond_to do |format|
        if @maintenance_control.update(maintenance_control_params)
          servicio = ServiceOrder.find_by(id:@maintenance_control.service_order_id)
          if @maintenance_control.tipo == "Compra"
            jde = TicketTireBattery.update_request(@maintenance_control.id,current_user)
            if jde[1] == 1
              format.html { redirect_to edit_maintenance_control_path, alert: jde[0] }
            else
                @maintenance_control.update(estatus:"Completado")
                servicio.update(estatus:"Compra Realizada")
                format.html { redirect_to maintenance_controls_path, notice: 'Póliza generada con éxito.' }
            end
          elsif @maintenance_control.tipo == "Preventivo" or @maintenance_control.tipo == "Correctivo"
              jde = MaintenanceControl.update_request(@maintenance_control.id,current_user)
              if jde[1] == 1
                format.html { redirect_to edit_maintenance_control_path, alert: jde[0] }
              else
                  @maintenance_control.update(estatus:"Completado")
                  servicio.update(estatus:"Servicio Finalizado")
                  format.html { redirect_to maintenance_controls_path, notice: 'Póliza generada con éxito.' }
              end
          else
              format.html { redirect_to maintenance_controls_path, notice: 'El mantenimiento se actualizó con exito.' }
              format.json { render :show, status: :ok, location: @maintenance_control }
          end
        else
          format.html { render :edit }
          format.json { render json: @maintenance_control.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to maintenance_controls_path
      flash[:alert] = "Ocurrió un error favor contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /maintenance_controls/1
  # DELETE /maintenance_controls/1.json
  def destroy
    @maintenance_control.destroy
    respond_to do |format|
      format.html { redirect_to maintenance_controls_url, notice: 'El mantenimiento se eliminó con exito.' }
      format.json { head :no_content }
    end
  end
  def indicador_horas_taller
    session["menu2"] = "Indicador horas taller"
  end

  def filtrado_horas
    @indicador = Array.new
    @taller = []
    @arreglo = []
    @resultados = []
    @numero = []
    @dias = []
    @bandera_error = false
  
    fecha_i = (DateTime.parse(params[:start_date])).strftime("%Y-%m-%d")
    fecha_f = (DateTime.parse(params[:end_date])).strftime("%Y-%m-%d")
    cedis = params[:catalog_branch_id]
    if params[:catalog_branch_id].nil? or params[:catalog_branch_id] == ""
			@bandera_error = true
      @mensaje = "Seleccione el CEDIS."
    end
    if params[:start_date].nil? or params[:start_date] == ""
			@bandera_error = true
      @mensaje = "Seleccione la fecha."
    end
    if params[:end_date].nil? or params[:end_date] == ""
			@bandera_error = true
      @mensaje = "Seleccione la fecha."
    end
    #byebug
      if !@bandera_error
        session["cedis_horas"] = params[:catalog_branch_id]
        session["fecha_inicio_horas"] = params[:start_date]
        session["fecha_fin_horas"] = params[:end_date]

        @vehiculos = Vehicle.where(catalog_branch_id: cedis)
        @vehiculos.each do |veh|
          @query = MaintenanceControl.joins(:catalog_workshop).select('sum(dias_taller) as sumatoria','catalog_workshops.nombre_taller as nombre').where(vehicle_id: veh.id,fecha_factura:fecha_i..fecha_f).group('catalog_workshops.nombre_taller')
          if !@query[0].nil?
            @resultados.push(numero_economico: veh.numero_economico,dias: @query[0].sumatoria,taller: @query[0].nombre)
          end 
        end 
        @resultados.each do |res|
          @numero.push(res[:numero_economico])
          @dias.push(res[:dias])
        end 
        #byebug
        if @resultados == []
          @mensaje = "No se encontró información en el CEDIS o fecha seleccionado(a)."
          @bandera_error = true
        end
      # @indicador = MaintenanceControl.find_by_sql("SELECT sum(dias_taller) as sumatoria,catalog_workshops.nombre_taller as nombre FROM maintenance_controls INNER JOIN catalog_workshops
      # ON catalog_workshops.id = maintenance_controls.catalog_workshop_id WHERE maintenance_controls.catalog_workshop_id
      # IN (SELECT catalog_workshops.id FROM catalog_workshops
      # WHERE catalog_workshops.catalog_branch_id = #{cedis}) and maintenance_controls.fecha_factura BETWEEN '#{fecha_i}' AND '#{fecha_f}'
      # group by catalog_workshops.nombre_taller")
        # @indicador.each do |ind|
        #   hash = {:x => ind.nombre , :y => ind.sumatoria }
        #   @arreglo.push(hash)
        #   @taller.push(ind.nombre)
        # end
        #byebug
      end
  end

  def generar_excel_horas
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    col_widths= [3,30,3] 
    resultados = Array.new
    vehiculos = Vehicle.where(catalog_branch_id: session["cedis_horas"])
      vehiculos.each do |veh|
        query = MaintenanceControl.joins(:catalog_workshop).select('sum(dias_taller) as sumatoria','catalog_workshops.nombre_taller as nombre').where(vehicle_id: veh.id,fecha_factura:session["fecha_inicio_horas"]..session["fecha_fin_horas"]).group('catalog_workshops.nombre_taller')
        if !query[0].nil?
          resultados.push(numero_economico: veh.numero_economico,dias: query[0].sumatoria,taller: query[0].nombre)
        end 
      end 
    workbook.styles do |s|
      miles_decimal = s.add_style(:format_code => "$###,###.00")
      centered = { alignment: { horizontal: :center } }
      workbook.add_worksheet(name: "Horas taller") do |sheet|
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["","Horas taller"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["No. Económico","Taller","Días"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
        sheet.column_widths *col_widths
        
        resultados.each do |resultado|
          sheet.add_row [resultado[:numero_economico],resultado[:taller],resultado[:dias]]
        end
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Horas taller.xlsx"
  end

  def reporte_presupuesto_mantenimiento
    session["menu2"] = "Reporte de presupuesto mantenimiento"
  end

  def filtrado_pres_mant
    @resultados = []
    @bandera_error = false
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
      
      vehicles.each do |vehicle|
        historico = MaintenanceControl.historial(vehicle.id)   
        programa = MaintenanceProgram.find_by(vehicle_id: vehicle.id)
        if programa
          gasto_km = historico[0]/programa.km_recorrido_curso
          @resultados.push(vehiculo:vehicle.numero_economico,cedis:vehicle.catalog_branch.decripcion,tipo:vehicle.vehicle_type.descripcion,linea:vehicle.catalog_brand.descripcion,usuario:vehicle.catalog_personal.nombre,km_inicio_ano:programa.km_inicio_ano,km_recorrido_curso:programa.km_recorrido_curso,km:historico[0],km2:historico[1],gasto_km:gasto_km)
        end
      end
      
      if @resultados == []
        @mensaje = "No se encontró información."
        @bandera_error = true
      end
    end
  end

  def filtrado_respuestas
    @indicador = Array.new
    @nombres_taller = []
    respuestas_taller = []

    @bandera_error = false
    contador = 0
   
    if params[:answer_id].nil? or params[:answer_id] == ""
			@bandera_error = true
      @mensaje = "Seleccione el tipo de resultado."
    end

    if !@bandera_error
      session["resultado_respuesta"] = params[:answer_id]
      if params[:catalog_workshop_id] != ""
          session["taller_respuestas"] = params[:catalog_workshop_id]
          taller = CatalogWorkshop.find_by(id:params[:catalog_workshop_id])
          if params[:start_date] != "" and params[:end_date] != ""
            session["fecha_i_respuestas"] = params[:start_date]
            session["fecha_f_respuestas"] = params[:end_date]
            encuestas = UserAnswer.where(catalog_workshop_id: params[:catalog_workshop_id],fecha_captura: params[:start_date]..params[:end_date])
          else
            session["fecha_i_respuestas"] = ""
            session["fecha_f_respuestas"] = ""
            encuestas = UserAnswer.where(catalog_workshop_id: params[:catalog_workshop_id])
          end
          respuestas = Answer.find_by(id:params[:answer_id])
          encuestas.each do |encuesta|
            detalle_res = AnswerDetail.where(user_answer_id:encuesta.id,answer_id:respuestas.id)
            if detalle_res != []
              contador += 1
            end
          end
          @nombres_taller.push(taller.nombre_taller)
          respuestas_taller.push(contador)
          @indicador.push(nombre:taller.nombre_taller,respuesta:contador)
          @resultados =  @nombres_taller.zip(respuestas_taller)
      else
        session["taller_respuestas"] = ""
        talleres = CatalogWorkshop.where(vigente:true)
        talleres.each do |taller|
          if params[:start_date] != "" and params[:end_date] != ""
            session["fecha_i_respuestas"] = params[:start_date]
            session["fecha_f_respuestas"] = params[:end_date]
            encuestas = UserAnswer.where(catalog_workshop_id:taller.id,fecha_captura: params[:start_date]..params[:end_date])        
          else
            session["fecha_i_respuestas"] = ""
            session["fecha_f_respuestas"] = ""
            encuestas = UserAnswer.where(catalog_workshop_id:taller.id)        
          end
          respuestas = Answer.find_by(id:params[:answer_id])
          encuestas.each do |encuesta|
            detalle_res = AnswerDetail.where(user_answer_id:encuesta.id,answer_id:respuestas.id)
            if detalle_res !=[]
              contador += 1
            end
          end
          @nombres_taller.push(taller.nombre_taller)
          respuestas_taller.push(contador)
          @indicador.push(nombre:taller.nombre_taller,respuesta:contador)   
          @resultados =  @nombres_taller.zip(respuestas_taller)
        end
      end
      if @indicador == []
        @mensaje = "No se encontró información."
        @bandera_error = true
      end
    end
  end

  def generar_excel_respuestas
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    col_widths= [3,30,3] 
    resultados = Array.new
    contador = 0
    if session["taller_respuestas"] != ""
      taller = CatalogWorkshop.find_by(id:session["taller_respuestas"])
      if session["fecha_i_respuestas"] != "" and  session["fecha_f_respuestas"] != ""
        encuestas = UserAnswer.where(catalog_workshop_id: session["taller_respuestas"],fecha_captura: session["fecha_i_respuestas"]..session["fecha_f_respuestas"])
      else
        encuestas = UserAnswer.where(catalog_workshop_id:session["taller_respuestas"])
      end
      respuestas = Answer.find_by(id: session["resultado_respuesta"])
      encuestas.each do |encuesta|
        detalle_res = AnswerDetail.where(user_answer_id:encuesta.id,answer_id:respuestas.id)
        if detalle_res != []
          contador += 1
        end
      end
      resultados.push(nombre:taller.nombre_taller,respuesta:contador)
  else
    talleres = CatalogWorkshop.where(vigente:true)
    talleres.each do |taller|
      if session["fecha_i_respuestas"] != "" and  session["fecha_f_respuestas"] != ""
        encuestas = UserAnswer.where(catalog_workshop_id:taller.id,fecha_captura: session["fecha_i_respuestas"]..session["fecha_f_respuestas"])        
      else
        encuestas = UserAnswer.where(catalog_workshop_id:taller.id)        
      end
      respuestas = Answer.find_by(id: session["resultado_respuesta"])
      encuestas.each do |encuesta|
        detalle_res = AnswerDetail.where(user_answer_id:encuesta.id,answer_id:respuestas.id)
        if detalle_res !=[]
          contador += 1
        end
      end
      resultados.push(nombre:taller.nombre_taller,respuesta:contador)   
    end
  end

    workbook.styles do |s|
      miles_decimal = s.add_style(:format_code => "$###,###.00")
      centered = { alignment: { horizontal: :center } }
      workbook.add_worksheet(name: "Respuestas taller") do |sheet|
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["","Respuestas taller"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["Taller","No. respuestas"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
        sheet.column_widths *col_widths
        
        resultados.each do |resultado|
          sheet.add_row [resultado[:nombre],resultado[:respuesta]]
        end
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Respuestas taller.xlsx"
  end

  def importar_gastos_mantenimiento
    require 'axlsx'
    
    spreadsheet = Roo::Spreadsheet.open(params[:file].path)
    arreglo = Array.new()
    header = spreadsheet.row(1)
    #byebug
        (2..spreadsheet.last_row).each do |i|
            #if i == 0
            #    byebug
            #end
            row = Hash[[header, spreadsheet.row(i)].transpose]
            vehicle = Vehicle.find_by(numero_economico: row["vehicle_id"])
            if !vehicle
                arreglo.push(fila: row, error: "No se encontró el vehículo ingresado #{row["vehicle_id"]}")
                next
            end
            proveedor = CatalogVendor.find_by(clave:row["clave taller"])
            if !proveedor
                arreglo.push(fila: row, error: "No se encontró el proveedor ingresado")
                next
            else
                taller = CatalogWorkshop.find_by(catalog_vendor_id: proveedor.id)
                if !taller
                    arreglo.push(fila: row, error: "No se encontró el taller ingresado")
                    next
                end
            end
            reparacion = CatalogRepair.find_by(clave:row["clave repair"])
            if !reparacion
                arreglo.push(fila: row, error: "No se encontró la reparación ingresada")
                next
            end
            begin
                busqueda = MaintenanceControl.find_by(vehicle_id:vehicle.id,catalog_workshop_id:taller.id,catalog_repair_id:reparacion.id,mes_pago:row["mes_pago"],observaciones:row["observaciones"],fecha_factura:row["fecha_factura"],año:row["año"],importe:row["importe"],importe_iva:row["importe_iva"],ciudad:row["ciudad"],km_actual:row["km_actual"],dias_taller:row["dias_taller"])
                if !busqueda
                    registro = MaintenanceControl.create(vehicle_id:vehicle.id,catalog_workshop_id:taller.id,catalog_repair_id:reparacion.id,mes_pago:row["mes_pago"],observaciones:row["observaciones"],fecha_factura:row["fecha_factura"],año:row["año"],importe:row["importe"],importe_iva:row["importe_iva"],ciudad:row["ciudad"],km_actual:row["km_actual"],dias_taller:row["dias_taller"])         
                end
            rescue => exception
                arreglo.push(fila: row, error: exception)
                next
            end
        end
    if arreglo.length > 0
        package = Axlsx::Package.new
        workbook = package.workbook
        workbook.styles do |s|
            workbook.add_worksheet(name: "registros") do |sheet|
                sheet.add_row ["vehicle_id","clave taller","clave repair","error"]
                 arreglo.each do |dato|
                    sheet.add_row [dato[:fila]["vehicle_id"],dato[:fila]["clave taller"],dato[:fila]["clave repair"], dato[:error]]
                end
            end
        end
        send_data package.to_stream.read, type: "application/xlsx", filename: "Errores carga.xlsx"
    else
        redirect_to maintenance_programs_path, notice: "Finalizo el proceso de importacion"
    end
  end
  

  private
    def validacion_menu
      session["menu1"] = "Mantenimiento"
      session["menu2"] = "Control de mantenimiento"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_control
      @maintenance_control = MaintenanceControl.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def maintenance_control_params
      params.require(:maintenance_control).permit(:vehicle_id, :mes_pago, :catalog_workshop_id, :catalog_repair_id, :observaciones, :fecha_factura, :año, :importe, :importe_iva, :ciudad, :km_actual,:base)
    end
end
