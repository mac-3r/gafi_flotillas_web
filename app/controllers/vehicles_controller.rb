class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy, :vehicle_expenses, :gastos_vehiculo_x_fecha]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  load_and_authorize_resource except: [:index,:generar_excel,:filtrado_maestro, :reasignacion_vehiculos, :checklist_asignacion, :importar_maestro_vehiculos, :imprimir_adaptacion]
  after_action :validacion_menu
  skip_forgery_protection only: [:upload_document] 
  # GET /vehicles
  # GET /vehicles.json
  def index
    if current_user.catalog_workshops.length > 0
      redirect_to service_orders_path
    else
      session["vehiculo"] = "" if session["vehiculo"] == "" or session["vehiculo"] == nil
      session["cedis"] = "" if session["cedis"] == "" or session["cedis"] == nil
      session["area"] = "" if session["area"] == "" or session["area"] == nil
      session["tipovehiculo"] = "" if session["tipovehiculo"] == "" or session["tipovehiculo"] == nil
      session["empresa"] = "" if session["empresa"] == "" or session["empresa"] == nil
      session["fecha_inicio_maestro"] = ""  if session["fecha_inicio_maestro"] == "" or session["fecha_inicio_maestro"] == nil
      session["fecha_fin_maestro"] = "" if session["fecha_fin_maestro"] == "" or session["fecha_fin_maestro"] == nil
      session["vendidos"] = "" if session["vendidos"] == "" or session["vendidos"] == nil
      validacion_menu()
      @vehicles = VehiclesMaster.consulta_maestro( session["vehiculo"],session["cedis"], session["area"], session["tipovehiculo"], session["empresa"], session["fecha_inicio_maestro"],session["fecha_fin_maestro"], session["vendidos"] = "", params[:page])
      #@vehicles = @vehicles.page(params[:page]).per(30)
      #byebug
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
 
  def filtrado_maestro
    session["vehiculo"] = "#{params[:keyword]}"
    session["cedis"] = params[:catalog_branch_id]
    session["area"] = params[:catalog_area_id]
    session["tipovehiculo"] = params[:vehicle_type_id]
    session["empresa"] = params[:catalog_company_id]
    session["vendidos"] = params[:vendidos]
    if  params[:start_date] !="" and params[:end_date] !=""
      session["fecha_inicio_maestro"] = Date.strptime(params[:start_date], "%d/%m/%Y")
      session["fecha_fin_maestro"] = Date.strptime(params[:end_date], "%d/%m/%Y")
    else
      session["fecha_inicio_maestro"] = "" 
      session["fecha_fin_maestro"] = ""
    end
    validacion_menu()
    @vehicles = VehiclesMaster.consulta_maestro( session["vehiculo"],session["cedis"], session["area"], session["tipovehiculo"], session["empresa"], session["fecha_inicio_maestro"],session["fecha_fin_maestro"], session["vendidos"], params[:page])
    respond_to do |format|
      format.js
    end
  end

  def generar_excel
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    #@encabezado = Consumption.find_by(id: params[:consumption_id])
    #resultados = Consumption.joins(:vehicle_consumptions)
    resultados = Vehicle.all.order(numero_economico: :asc)
    workbook.styles do |s|
			img = File.expand_path("#{Rails.root}/app/assets/images/excel_logo.png", __FILE__)
			col_widths= [3,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30] 
			celda_tabla = s.add_style :bg_color => "BFBFBF", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
      celda_cabecera2= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right, :vertical => :center}
			celda_categoria = s.add_style :bg_color => "D9D9D9", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_notas = s.add_style :fg_color => "FF0000" ,:sz => 12
			celda_afi_mayor = s.add_style :bg_color => "808080", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_afi_menor = s.add_style :bg_color => "F2F2F2", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
      miles_decimal = s.add_style(:format_code => "$###,###.00")
      centered = { alignment: { horizontal: :center } }
      #img = File.expand_path(Rails.root+'app/assets/images/image001.jpg')
      workbook.add_worksheet(name: "Maestro de veh??culos") do |sheet|
        sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
				sheet.merge_cells("B1:D7")
				sheet.add_row ["","Maestro de veh??culos","","","","", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["","N??mero Econ??mico","Empresa", "Centro de distribuci??n","Centro de costos","Responsable","Estatus", "Tipo de veh??culo","L??nea","Modelo","No.Serie","No.Motor","Tipo transmisi??n","Empresa facturable","No. Fact veh??culo","Fecha de compra","Valor de compra","No. Fact adopt","No. Serie adopt","Valor adaptaci??n","Ruta","No. P??liza","Inciso","Cobertura","Beneficiario","No. Placa","Estado plaqueo","No. Permiso federal de carga","No. Permiso fisico de mecanico","No. Permiso ambiental","Litros autorizados","Usuario","??rea", "Reparto"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        resultados.all.each do |resultado|
          sheet.add_row ["",resultado.numero_economico,resultado.catalog_company ? resultado.catalog_company.nombre : "No se asign??",resultado.catalog_branch ? resultado.catalog_branch.decripcion : "No se asign??",resultado.cost_center ? resultado.cost_center.descripcion : "No se asign??",resultado.responsable ? resultado.responsable.nombre : "No se asign??",resultado.vehicle_status.descripcion,resultado.vehicle_type_id ? resultado.vehicle_type.descripcion : "No se asign??",resultado.catalog_brand_id ? resultado.catalog_brand.descripcion : "No se asign??",resultado.catalog_model_id ? resultado.catalog_model.descripcion : "No se asign??",resultado.numero_serie,resultado.numero_motor,resultado.transmision,resultado.billed_company_id ? resultado.billed_company.nombre : "No se asign??",resultado.numero_factura,resultado.fecha_compra,resultado.valor_compra,resultado.numero_factura_adapt,resultado.numero_serie_adapt,resultado.valor_adapt,resultado.catalog_route ? resultado.catalog_route.descripcion : "No se asign??",resultado.numero_poliza,resultado.inciso,resultado.policy_coverage ? resultado.policy_coverage.descripcion : "No se asign??",resultado.insurance_beneficiary ? resultado.insurance_beneficiary.descripcion : "No se asign??",resultado.numero_placa,resultado.plate_state ? resultado.plate_state.descripcion : "No se asign??",resultado.permiso_federal_carga,resultado.permiso_fisico_mecanico,resultado.permiso_ambiental,resultado.litros_autorizados,resultado.catalog_personal ? resultado.catalog_personal.nombre : "No se asign??",resultado.catalog_area ? resultado.catalog_area.descripcion : "No se asign??", resultado.reparto], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Maestro de veh??culos.xlsx"
  end

  def venta
    @vehicle = Vehicle.find(params[:id])
    #resta 2 a??os
    fecha = Time.now - 2.years
    @maintenance_controls = MaintenanceControl.where("vehicle_id =#{params[:id]} and importe < 5000 and fecha_factura >= '#{fecha}'").order(:a??o)
    @maintenance_controls_sum = MaintenanceControl.where("vehicle_id =#{params[:id]} and importe < 5000 and fecha_factura >= '#{fecha}'").sum(:importe)
    @maintenances = MaintenanceControl.where("vehicle_id =#{params[:id]} and importe > 5000 and fecha_factura >= '#{fecha}'").order(:a??o)#agrega la tabla de costos segun el id del vehiculo
    @maintenances_sum = MaintenanceControl.where("vehicle_id =#{params[:id]} and importe > 5000 and fecha_factura >= '#{fecha}'").sum(:importe)#agrega la tabla de costos segun el id del vehiculo

    #tabla de gastos
    @fechas= MaintenanceControl.find_by_sql("select a??o from maintenance_controls where vehicle_id = #{params[:id]} and fecha_factura >= '#{fecha}' group by a??o;")
    @kilometros = MaintenanceControl.find_by_sql("select sum(km_actual) from maintenance_controls  where vehicle_id = #{params[:id]} and fecha_factura >= '#{fecha}'group by a??o;")
    @gastos = MaintenanceControl.find_by_sql("select sum(importe) from maintenance_controls where vehicle_id = #{params[:id]} and fecha_factura >= '#{fecha}' group by a??o;")
    @calculos = MaintenanceControl.find_by_sql("select sum(importe)/sum(km_actual) as calculo from maintenance_controls where vehicle_id = #{params[:id]} and fecha_factura >= '#{fecha}' group by a??o;")
    @encabezado = Sale.where(vehicle_id: params[:id])
    @costos = ApproximateCost.where(vehicle_id: params[:id])
    @matenimiento_rehabilitar = MaintenanceRehabilitate.where(vehicle_id:params[:id])
    @mantenimiento_sum = MaintenanceRehabilitate.where(vehicle_id:params[:id]).sum(:costo)
    #byebug
    #byebug
  end

  def registrar_encabezado

  end 

  def guardar_encabezado
    @busqueda = Vehicle.find_by(id: params[:id])
    #byebug
    if @busqueda
      registro = Sale.create(vehicle_id:@busqueda.id,fecha_inicial:params[:fecha_inicial],fecha_venta:params[:fecha_venta],precio_inicial:params[:precio_inicial],precio_final:params[:precio_final])
      flash[:notice] = "Se registraron los datos con exito."
      redirect_to venta_vehiculo_path(@busqueda.id)
    else
      flash[:alert] = "Ocurrio un error"
      redirect_to vehicles_path
    end
  end

  def registrar_costos

  end 

  def guardar_costos
    @busqueda = Vehicle.find_by(id: params[:id])
    #byebug
    if @busqueda
      registro = ApproximateCost.create(vehicle_id:@busqueda.id,mercado_libre:params[:mercado_libre],libro_azul:params[:libro_azul])
      flash[:notice] = "Se registraron los datos con ??xito."
      redirect_to venta_vehiculo_path(@busqueda.id)
    else
      flash[:alert] = "Ocurrio un error"
      redirect_to vehicles_path
    end
  end

  def registrar_mantenimiento
    
  end

  def guardar_mantenimiento
    @busqueda = Vehicle.find_by(id: params[:id])
    #byebug
    if @busqueda
      registro = MaintenanceRehabilitate.create(vehicle_id:@busqueda.id,reparacion:params[:reparacion],costo:params[:costo])
      flash[:notice] = "Se registraron los datos con ??xito."
      redirect_to registrar_mantenimiento_path
    else
      flash[:alert] = "Ocurrio un error"
      redirect_to vehicles_path
    end
  end

  def solicitar_venta
    @vehiculo = Vehicle.find_by(id: params[:id])
    @status = VehicleStatus.find_by(descripcion: "Proceso de venta")
    if @vehicle and @status
      @vehicle.update(vehicle_status_id:@status.id )
        flash[:notice] = "Solicitud enviada con ??xito"
        redirect_to vehicles_path
      else
        flash[:alert] = "No se encontr?? el registro."
        redirect_to vehicles_path
    end
  end

  def cancelar_venta
     @busqueda = Vehicle.find_by(id: params[:id])
     @status = VehicleStatus.find_by(descripcion: "Activo")
    if @busqueda and @status
      @busqueda.update(vehicle_status_id: @status.id)
      flash[:notice] = "Venta cancelada con ??xito."
      redirect_to vehicles_path
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to vehicles_path
    end
  end

  def imprimir_formato_venta
      @vehicle = Vehicle.find(params[:vehicle_id])
      #resta 2 a??os
      fecha = Time.now - 2.years
      @maintenance_controls = MaintenanceControl.where("vehicle_id =#{params[:vehicle_id]} and importe < 5000 and fecha_factura >= '#{fecha}'").order(:a??o)
      @maintenance_controls_sum = MaintenanceControl.where("vehicle_id =#{params[:vehicle_id]} and importe < 5000 and fecha_factura >= '#{fecha}'").sum(:importe)
      @maintenances = MaintenanceControl.where("vehicle_id =#{params[:vehicle_id]} and importe > 5000 and fecha_factura >= '#{fecha}'").order(:a??o)#agrega la tabla de costos segun el id del vehiculo
      @maintenances_sum = MaintenanceControl.where("vehicle_id =#{params[:vehicle_id]} and importe > 5000 and fecha_factura >= '#{fecha}'").sum(:importe)#agrega la tabla de costos segun el id del vehiculo

      #tabla de gastos
      @fechas= MaintenanceControl.find_by_sql("select a??o from maintenance_controls where vehicle_id = #{params[:vehicle_id]} and fecha_factura >= '#{fecha}' group by a??o;")
      @kilometros = MaintenanceControl.find_by_sql("select sum(km_actual) from maintenance_controls  where vehicle_id = #{params[:vehicle_id]} and fecha_factura >= '#{fecha}'group by a??o;")
      @gastos = MaintenanceControl.find_by_sql("select sum(importe) from maintenance_controls where vehicle_id = #{params[:vehicle_id]} and fecha_factura >= '#{fecha}' group by a??o;")
      @calculos = MaintenanceControl.find_by_sql("select sum(importe)/sum(km_actual) as calculo from maintenance_controls where vehicle_id = #{params[:vehicle_id]} and fecha_factura >= '#{fecha}' group by a??o;")
      @encabezado = Sale.where(vehicle_id: params[:vehicle_id])
      @costos = ApproximateCost.where(vehicle_id: params[:vehicle_id])
      @matenimiento_rehabilitar = MaintenanceRehabilitate.where(vehicle_id:params[:vehicle_id])
      @mantenimiento_sum = MaintenanceRehabilitate.where(vehicle_id:params[:vehicle_id]).sum(:costo)
    respond_to do |format|
			format.html
			format.pdf do
			render pdf: "imprimir",
			template: "vehicles/formato_venta.html.erb",
			layout: 'formato_venta.html',
			orientation: 'Portrait'
			end
		end
  end
  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
    file_data = params[:file]
    @maintenance_controls = @vehicle.maintenance_controls
    @vehicle = Vehicle.find_by(id: params[:id])
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    if !params[:vehicle][:reparto].present?
      params[:vehicle][:reparto] = false
    end
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      params[:vehicle][:catalog_company_id] = params[:vehicle][:catalog_company_id]
      params[:vehicle][:catalog_branch_id] = params[:vehicle][:catalog_branch_id]
      params[:vehicle][:cost_center_id] = params[:vehicle][:cost_center_id]
      params[:vehicle][:responsable_id] = params[:vehicle][:responsable_id]
      params[:vehicle][:vehicle_status_id] = params[:vehicle][:vehicle_status_id]
      params[:vehicle][:vehicle_type_id] = params[:vehicle][:vehicle_type_id]
      params[:vehicle][:catalog_brand_id] = params[:vehicle][:catalog_brand_id]
      params[:vehicle][:catalog_model_id] = params[:vehicle][:catalog_model_id]
      params[:vehicle][:billed_company_id] = params[:vehicle][:billed_company_id]
      params[:vehicle][:catalog_route_id] = params[:vehicle][:catalog_route_id]
      params[:vehicle][:policy_coverage_id] = params[:vehicle][:policy_coverage_id]
      params[:vehicle][:insurance_beneficiary_id] = params[:vehicle][:insurance_beneficiary_id]
      params[:vehicle][:plate_state_id] = params[:vehicle][:plate_state_id]
      params[:vehicle][:catalog_area_id] = params[:vehicle][:catalog_area_id]
      params[:vehicle][:vehicle_permit_id] = params[:vehicle][:vehicle_permit_id] 
      params[:vehicle][:catalog_personal_id] = params[:vehicle][:catalog_personal_id]
      params[:vehicle][:fecha_compra] = params[:vehicle][:fecha_compra].to_datetime.strftime("%Y-%m-%d")
      if params[:vehicle][:vehicle_type_id] == "10"
        params[:vehicle][:permission_type_id] = nil
        params[:vehicle][:vehicle_configuration_id] = nil
      else
        params[:vehicle][:trailer_subtype_id] = nil
      end
      
      if @vehicle.save
        format.html { redirect_to vehicles_path, notice: 'El veh??culo se creo con ??xito.' }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    if !params[:vehicle][:reparto].present?
			params[:vehicle][:reparto] = false
		else
			params[:vehicle][:reparto] = true
		end

    if !params[:vehicle][:base].present?
			params[:vehicle][:base] = false
		else
			params[:vehicle][:base] = true
		end
    if params[:vehicle][:vehicle_type_id] == "10"
      params[:vehicle][:permission_type_id] = nil
      params[:vehicle][:vehicle_configuration_id] = nil
    else
      params[:vehicle][:trailer_subtype_id] = nil
    end
    #byebug
    emple = CatalogPersonal.find_by(id: params[:vehicle][:catalog_personal_id])
    if emple
      if emple.user
        lice = CatalogLicence.find_by(user_id: emple.user_id)
        if lice
          params[:vehicle][:numero_licencia] = lice.numero_licencia
        else
          params[:vehicle][:numero_licencia] = params[:vehicle][:numero_licencia] 
        end
      else
        params[:vehicle][:numero_licencia] = params[:vehicle][:numero_licencia] 
      end
    end
    
    respond_to do |format|
      Vehicle.transaction do
        if @vehicle.update(vehicle_params)
          if @vehicle.vehicle_status.descripcion == "Inactivo"
            #busca el cedis si lo encuentra lo guarda en correo
            if @vehicle.catalog_branch_id
              user = User.joins(:catalog_roles).joins(:catalog_branches_users).find_by("catalog_roles.nombre = 'ADMINISTRADOR DE FLOTILLA' and catalog_branches_users.catalog_branch_id = #{@vehicle.catalog_branch_id}")
              #byebug
              if user
                personal = CatalogPersonal.find_by(user_id: user.id)
                if user.email != ""
                  correo = user.email
                end
              end
              if personal
                responsable = Responsable.find_by(catalog_personal_id: personal.id)
              end
            end
            #busca el estatus pendiente de entrega
            busqueda = VehicleStatus.find_by(descripcion: "Pendiente de entrega")
            frec = MaintenanceFrecuency.find_by(vehicle_type_id: @vehicle.vehicle_type_id,catalog_model_id:@vehicle.catalog_model_id)
            valor = Parameter.find_by(valor:"frecuencia de verificacion")
            if user and correo and personal and responsable and frec and valor
              jde = PurchaseOrder.update_request(@vehicle,current_user,params[:vehicle][:cuenta_contable])
              #si cumple iniciara el asiento contable
              if jde[1] == 1
                format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: jde[0] }
                raise ActiveRecord::Rollback
              else
                VehiclesMailer.correo_reporte(correo,@vehicle.id).deliver_later
                fecha_actual = Date.today
                #registrar el programa
                bitacora = MaintenanceProgram.create(vehicle_id: @vehicle.id, km_inicio_ano:0,km_recorrido_curso:0,promedio_mensual:0,frecuencia_mantenimiento:frec.frecuencia,fecha_ultima_afinacion:fecha_actual,kms_ultima_afinacion:0,kms_proximo_servicio:frec.frecuencia,km_actual:0,fecha_proximo:fecha_actual + 6.months ,maintenance_frecuency_id:frec.id)
                if @vehicle.update(vehicle_status_id:busqueda.id,catalog_personal_id:personal.id,responsable_id:responsable.id,proxima_verificacion:fecha_actual + valor.valor_extendido.to_i.day)
                  format.html { redirect_to vehicles_path, notice: 'Solicitud enviada con ??xito, por favor complete el proceso de compra.' }
                else
                  mensaje = "Ocurri?? uno o m??s errores: "
                  @vehicle.errors.full_messages.each do |error|
                    mensaje += "#{error}. "
                  end
                  format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: mensaje }
                  raise ActiveRecord::Rollback
                end
              end
            else
              if user.nil?
                format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: "No se encontr?? un usuario con el rol de administrador de flotillas o el cedis indicado, favor de revisar informaci??n." }
                raise ActiveRecord::Rollback
              end
              if correo.nil?
                format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: "No se encontr?? el correo del administrador de flotillas, favor de revisar informaci??n." }
                raise ActiveRecord::Rollback
              end
              if personal.nil?
                format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: "No se encontr?? el administrador de flotillas: #{user.name} #{user.last_name} en el cat??logo de personal, favor de revisar informaci??n." }
                raise ActiveRecord::Rollback
              end
              if responsable.nil?
                format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: "No se encontr?? el administrador de flotillas: #{personal.nombre} en el cat??logo de responsables, favor de asingar el personal al responsable." }
                raise ActiveRecord::Rollback
              end
              if frec.nil?
                format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: "No se encontr?? la frecuencia de mantenimiento para este tipo y modelo de veh??culo, favor de revisar el cat??logo de frecuencias de mantenimiento." }
                raise ActiveRecord::Rollback
              end
              if valor.nil?
                format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: "No se encontr?? la frecuencia de verificaci??n, favor de revisar los par??metros." }
                raise ActiveRecord::Rollback
              end
            end
            #Vehicle.actualizar_vehiculo_jde(@vehicle.id)
          #si no es inactivo
          else
            if @vehicle.reparto
              envio_jde = Vehicle.actualizar_vehiculo_jde(@vehicle.id)
              if envio_jde[0] == true
                format.html { redirect_to vehicles_path, notice: 'El veh??culo se actualiz?? con exito.' }
                format.json { render :show, status: :ok, location: @vehicle }
              else
                mensaje = "Error en la solicitud a JD Edwards: "
                envio_jde[1].map{|x| x["Mensaje"]}.each do |error|
                  mensaje += "#{error}. "
                end
                format.html { redirect_to edit_vehicle_path(@vehicle.id), alert: mensaje }
                raise ActiveRecord::Rollback
              end
            else
              format.html { redirect_to vehicles_path, notice: 'El veh??culo se actualiz?? con exito.' }
              format.json { render :show, status: :ok, location: @vehicle }
            end
          end
        else
          format.html { render :edit }
          format.json { render json: @vehicle.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def cancelar_compra
    #borra el vehiculo
    vehiculo = Vehicle.find_by(id: params[:id])
    limpiar_historial = VehicleLog.where(vehicle_id: vehiculo.id).destroy_all
    #byebug
    if vehiculo.delete 
      flash[:notice] = "Compra cancelada con ??xito."
      redirect_to vehicles_path
    else
      vehiculo.errors.full_messages.each do |error|
        flash[:false] = error
        redirect_to vehicles_path          
      end
    end
  end

  def uploads
    vehicle = Vehicle.find_by(id:params[:id])
    uploaded_file = params[:file]
    numero_consecutivo = VehicleFile.where(vehicle_id:vehicle.id,tipo_archivo:params[:tipo]).last
    numero_consecutivo ? nuevo_numero = numero_consecutivo.clave + 1 : nuevo_numero = 1
    File.open(Rails.root.join('public', 'uploads', "#{vehicle.numero_economico}~#{params[:tipo]}~#{nuevo_numero}#{File.extname(uploaded_file)}"), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    registro = VehicleFile.new(vehicle_id:vehicle.id,clave:nuevo_numero,nombre_archivo:"#{vehicle.numero_economico}~#{params[:tipo]}~#{nuevo_numero}#{File.extname(uploaded_file)}",tipo_archivo:params[:tipo],fecha_vencimiento:params[:fecha_vencimiento])
    if registro.save
      flash[:notice] = "Archivo insertado con exito."
      redirect_to vehicle_path
    else
      flash[:alert] = "Ocurri?? un error."
      redirect_to vehicles_path
    end  
    #send_file "#{Rails.root}/public/uploads/100~001~2.pdf"
  end

  def reporte_documentos
    session["vehiculo_documento"] = ""
    session["fecha_documento"] = ""
    @documents = VehicleFile.consulta_documentos(session["vehiculo_documento"],session["fecha_documento"])
  end

  def filtrado_documentos
    session["vehiculo_documento"] = params[:vehicle_id]
    if params[:start_date] != ""
      session["fecha_documento"] =  Date.strptime(params[:start_date], "%d/%m/%Y")
    else
      session["fecha_documento"] =  ""
    end
  
    @documents = VehicleFile.consulta_documentos(session["vehiculo_documento"],session["fecha_documento"])
    respond_to do |format|
      format.js
    end
  end

  def ver_documentos
    @documents = VehicleFile.where(vehicle_id:params[:id])
  end

  def document_detail
    file = VehicleFile.find_by(id: params[:file_id])
    send_file "#{Rails.root}/public/uploads/#{file.nombre_archivo}"
  end

  def destroy_vehicle_file
    file = VehicleFile.find_by(id: params[:file_id])
    if file
      if file.destroy
        @bandera_error = false
        @mensaje = "Archivo eliminado exitosamente."
      else
        errores = ""
        file.errors.full_messages.each do |error|
          errores += "#{error}. "
        end
        @bandera_error = true
        @mensaje = "No se pudo eliminar el archivo. Int??ntelo de nuevo m??s tarde."
      end
    else
      @bandera_error = true
      @mensaje = "No se encontr?? el archivo seleccionado."
    end
  end
  

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to vehicles_url, notice: 'Se elimin?? el veh??culo con exito.' }
      format.json { head :no_content }
    end
  end

  #importar archivos
  def import_vehicles
    @vehicle = Vehicle.import_vehicles(params[:file])
    respond_to do |format|
      if @vehicle.count == 0
        format.html { redirect_to vehicles_url, notice: "Plantilla cargada con ??xito." }
      else
        format.html { render :import_vehicles_errors }
        format.json { render json: @vehicles }
      end
    end
  end

  #descargar plantilla de vehiculos
  def template_download_vehicles
    send_file "#{Rails.root}/public/packs/Importaciones/PLANTILLA.xlsx"
  end

  def reporte_responsivas
    session["menu1"] = "Maestro de veh??culos"
    session["menu2"] = "Responsivas"
    busqueda = "#{params[:catalog_branch_id]}"
    compania ="#{params[:catalog_company_id]}"
    area = "#{params[:catalog_area_id]}"
    responsable = "#{params[:responsable_id]}"

    @cedis_usuario = CatalogBranch.joins(:catalog_branches_users).where(catalog_branches_users: {user_id: current_user.id})
    if compania != "" && busqueda == ""
      @seleccionado = ""
      @cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where catalog_company_id = #{compania} group by catalog_branch_id, catalog_area_id,responsable_id")
    elsif busqueda != ""
      @seleccionado = busqueda
      @cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where catalog_branch_id = #{busqueda} group by catalog_branch_id, catalog_area_id,responsable_id")
    elsif area != ""
      @seleccionado = ""
      @cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where catalog_area_id = #{area} group by catalog_branch_id, catalog_area_id,responsable_id")
    elsif responsable != ""
      @seleccionado = ""
      @cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where responsable_id = #{responsable} group by catalog_branch_id, catalog_area_id,responsable_id")
    else
      @seleccionado = ""
      cadena = ""
      @cedis_usuario.each_with_index do |ced, index|
        if (index + 1) == @cedis_usuario.length
          cadena += "#{ced.id}"
        else
          cadena += "#{ced.id}, "
        end
      end
      if cadena == ""
        @cedis = Vehicle.none
      else
        @cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where catalog_branch_id IN (#{cadena}) group by catalog_branch_id, catalog_area_id,responsable_id")
      end
     
    end
  end

  def reporte_responsivas_detalle
    @index = Vehicle.where(catalog_branch_id:params[:catalog_branch_id], responsable_id: params[:responsable_id],catalog_area_id:params[:catalog_area_id]).order(:numero_economico)
  end
  
  def reporte
    @index =  Vehicle.where(catalog_branch_id:params[:catalog_branch_id], responsable_id: params[:responsable_id],catalog_area_id:params[:catalog_area_id]).order(:numero_economico)
    @cedis = CatalogBranch.find_by(id: params[:catalog_branch_id])
    @responsable = Responsable.find_by(id: params[:responsable_id])
    parametro_director = Parameter.find_by(valor: "id_usuario_director_responsiva")
    if parametro_director
      usuario = User.find_by(id: parametro_director.valor_extendido)
      if usuario
        @director = "#{usuario.name} #{usuario.last_name}"
      else
        @director = "No se encontr?? el director seleccionado"
      end
    else
      @director = "Director no seleccionado"
    end
    respond_to do |format|
			format.html
			format.pdf do
			render pdf: "imprimir",
			template: "vehicles/reporte.html.erb",
			layout: 'reporte_pdf.html',
			orientation: 'Portrait'
			end
		end
  end

  def generar_excel_responsivas
    busqueda = "#{params[:catalog_branch_id]}"
    compania ="#{params[:catalog_company_id]}"
    area = "#{params[:catalog_area_id]}"
    responsable = "#{params[:responsable_id]}"

    cedis_usuario = CatalogBranch.joins(:catalog_branches_users).where(catalog_branches_users: {user_id: current_user.id})
    if compania != "" && busqueda == ""
      seleccionado = ""
      cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where catalog_company_id = #{compania} group by catalog_branch_id, catalog_area_id,responsable_id")
    elsif busqueda != ""
      seleccionado = busqueda
      cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where catalog_branch_id = #{busqueda} group by catalog_branch_id, catalog_area_id,responsable_id")
    elsif area != ""
      seleccionado = ""
      cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where catalog_area_id = #{area} group by catalog_branch_id, catalog_area_id,responsable_id")
    elsif responsable != ""
      seleccionado = ""
      cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where responsable_id = #{responsable} group by catalog_branch_id, catalog_area_id,responsable_id")
    else
      seleccionado = ""
      cadena = ""
      cedis_usuario.each_with_index do |ced, index|
        if (index + 1) == cedis_usuario.length
          cadena += "#{ced.id}"
        else
          cadena += "#{ced.id}, "
        end
      end
      if cadena == ""
        cedis = Vehicle.none
      else
        cedis = Vehicle.find_by_sql("select catalog_branch_id,catalog_area_id,count(id) as total, responsable_id from vehicles where catalog_branch_id IN (#{cadena}) group by catalog_branch_id,catalog_area_id,responsable_id")
      end
    end
    total_vehiculos = 0
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    #@encabezado = Consumption.find_by(id: params[:consumption_id])
    #resultados = Consumption.joins(:vehicle_consumptions)
    workbook.styles do |s|
      celda_cabecera= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right}
      col_widths= [30,20,30] 
      centered = s.add_style :alignment => { :horizontal => :center }
      formato =  s.add_style :b => true, :font_name => 'Arial'
      workbook.add_worksheet(name: "Reporte de responsivas") do |sheet|
        sheet.merge_cells("A1:D1")
        sheet.add_row ["Reporte anual acumulado de responsivas",""], :style => [celda_cabecera,nil]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["CEDIS","??rea","No. veh??culos asignados", "Responsable"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
        sheet.column_widths *col_widths

        cedis.each do |ced|
          sheet.add_row [ced.catalog_branch ? ced.catalog_branch.decripcion : "No se asign??",ced.catalog_area ? ced.catalog_area.descripcion : "No se asign??",ced.total,ced.responsable ? ced.responsable.nombre : "No se asign??"], :style => [nil,nil,centered,nil]
         total_vehiculos += ced.total
        end
        sheet.add_row ["Total de veh??culos","",total_vehiculos], :style => [formato,centered]
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Reporte de responsivas.xlsx"
  end
  
  def numero_x_cedis
    @numero_economico = Vehicle.where(catalog_branch_id: params[:cedis]).order(numero_economico: :asc)
    if params[:comparativo].present?
      @comparacion = true
    else
      @comparacion = false
    end
    respond_to do |format|
      format.js
    end
  end

  def agregar_adaptaciones
    @adaptations = VehicleAdaptation.where(vehicle_id: params[:id])
  end

  def guardar_adaptaciones
    begin
      fecha = (DateTime.parse(params[:fecha])).strftime("%Y-%m-%d")
      consulta_corte = Deadline.where("fecha_inicio <= '#{fecha}' and fecha_fin >= '#{fecha}' and estatus = TRUE")
      if consulta_corte.length > 0
        flash[:alert] ="Ya se realiz?? el corte para la fecha seleccionada"
        redirect_to agregar_adaptaciones_path
      else
        if !params[:base].present?
          bandera_base = false
        else
          bandera_base = true
        end

        if !params[:impuestos].present?
          params[:impuestos] = false
          params[:importe_iva] = 0
        else
          params[:impuestos] = true
        end

        @vehicle = Vehicle.find_by(id: params[:id])
        if @vehicle
          registro = VehicleAdaptation.create(vehicle_id: @vehicle.id, catalog_area_id: @vehicle.catalog_area_id, catalog_branch_id: @vehicle.catalog_branch_id, monto: params[:monto],catalogo_adaptation_id: params[:catalogo_adaptation_id],catalog_vendor_id: params[:catalog_vendor_id],importe_iva: params[:importe_iva],estatus:"En captura",impuestos:params[:impuestos],fecha:params[:fecha],base:bandera_base)
          flash[:notice] = "Se registro la adaptaci??n con ??xito."
          redirect_to agregar_adaptaciones_path
        else
          flash[:alert] = "Ocurrio un error"
          redirect_to vehicles_path
        end
      end
    rescue => exception
      flash[:alert] = "Ocurrio un error favor de contactar soporte. Error: #{exception}"
      redirect_to agregar_adaptaciones_path
    end
  end

  def imprimir_adaptacion
    usuario = User.find_by(user: 'oorozco')
    @firma = UserSignature.find_by(user_id: usuario.id)
    @adaptacion = VehicleAdaptation.find_by(id: params[:vehicle_adaptation_id])
  end
  # numero economico
  # empresa
  # cedis

  def listado_checklist
    if params[:start_date] != "" and params[:end_date] != ""
      @checklist_responses = ChecklistResponse.where(vehicle_id: params[:id],fecha_captura: params[:start_date]..params[:end_date]).order(fecha_captura: :desc)
    else
      @checklist_responses = ChecklistResponse.where(vehicle_id: params[:id]).order(fecha_captura: :desc)
    end
  end

  def detalle_checklist
        @checklist = ChecklistResponse.find_by(id: params[:checklist_id])
        @vehicle = @checklist.vehicle
        #ChecklistResponseDetail.joins(:checklist).joins(:vehicle_checklist).where(checklist: {id: 1}).order(vehicle_checklist: {clasificacionvehiculo: :asc})
        @respuestas = ChecklistResponseDetail.joins(:checklist_response).joins(:vehicle_checklist).where(checklist_responses: {id: @checklist.id}).order("vehicle_checklists.clasificacionvehiculo asc")
        #@respuestas = @checklist.checklist_response_detail.order(vehicle_checklist_id: :asc)
        @cantidad_mitad = ((@respuestas.length / 2) - 1).to_i
        @respuestas.each do |respuesta|
            valor = instance_variable_get("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id")
            if valor.nil?
                instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id", 1)
                instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_texto", respuesta.vehicle_checklist.clasificacionvehiculo)
            else
                anterior = instance_variable_get("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id")
                instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id", anterior + 1)
            end
        end
  end
  
  
  def reasignar_responsables_modal
    @responsable_id = params[:responsable_id]
    if params[:responsable_id] == "0"
      @responsables = Responsable.where(status: true).order(nombre: :asc)
      @vehiculo_responsable = Vehicle.find_by(catalog_branch_id: params[:catalog_branch_id], responsable_id: nil,catalog_area_id: params[:catalog_area_id])
    else
      @responsables = Responsable.where(status: true).where.not(id: params[:responsable_id]).order(nombre: :asc)
      @vehiculo_responsable = Vehicle.find_by(responsable_id: params[:responsable_id], catalog_branch_id: params[:catalog_branch_id],catalog_area_id: params[:catalog_area_id])
    end
  end

  def reasignar_responsable
    @bandera_error = false
    @mensaje = ""
    @responsable_branch = params[:responsable_ant]
    @cedis = params[:cedis]
    if params[:responsable_ant] == "0"
      @vehiculos = Vehicle.where(catalog_branch_id: params[:cedis], responsable_id: nil,catalog_area_id: params[:catalog_area_id])
    else
      @vehiculos = Vehicle.where(catalog_branch_id: params[:cedis], responsable_id: params[:responsable_ant],catalog_area_id: params[:catalog_area_id])
    end
    copia_vehiculos = @vehiculos
    begin
      if @vehiculos.update_all(responsable_id: params[:responsable_nvo])
        @mensaje = "Reasignaci??n realizada con ??xito."
        copia_vehiculos.each do |vehiculo|
          VehicleLog.create(texto: "El veh??culo con n??mero econ??mico fue reasignado al responsable #{vehiculo.nombre}.", vehicle_id: vehiculo.id, user_id: current_user.id)
        end
        @responsablenuevo = Responsable.find_by(id: params[:responsable_nvo])
      else
        @bandera_error = true
        @vehiclulos.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    rescue => exception
      @bandera_error = true
      @mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
    end
    respond_to do |format|
      format.js
    end
  end


  # Asignaci??n, reaignaci??n y aceptaci??n
  
  def reasignacion_vehiculos
    if current_user.catalog_personal
      @personal = current_user.catalog_personal
      if  @personal.responsable != nil
        @responsable = @personal.responsable
        @vehicle_pendientes_recibir = Vehicle.where(vehicle_status_id: [1,5,6,7], catalog_personal_id: @personal.id, recibido:false )
      else
        flash[:alert] = "El usuario no es reponsable."
      end
    else
      flash[:alert] = "El usuario no tiene empleado asignado."
    end
  end

  def checklist_asignacion
    @vehiculo = Vehicle.find_by(id: params[:id_vehiculo], numero_economico: params[:numero_economico], vehicle_status_id: [1,5,6,7])
    if @vehiculo
      @id_vehiculo = params[:id_vehiculo]
      @num_economico = params[:numero_economico]
      @tipo_vehiculo = params[:vehicle_type_id]
      bandera_parametro = false
        bandera_bateria = false    
        bandera_llantas = false
        bandera_extintor = false
        tipo = ""
        @vehicle_checklists = []
        @vehicle_checklist = []
        @params = Parameter.where(nombre:"Checklist")
        vehicle_checklists = VehicleChecklist.select(:clasificacionvehiculo).distinct.where(vehicle_type_id:params[:vehicle_type_id])
        vehicle_checklists.each do |vcs| 
            hash_checklists = Hash.new
            vehicle_checklist = VehicleChecklist.where(clasificacionvehiculo: vcs.clasificacionvehiculo,vehicle_type_id:params[:vehicle_type_id])
            vehicle_checklist.each do |vc|
                hash_checklist = Hash.new
                tipo = ""
                bandera_bateria = false    
                bandera_llantas = false
                bandera_extintor = false
                bandera_parametro = false
                if  @params != []
                    @params.each do |param|
                        if param.valor == vc.conceptovehiculo
                            bandera_parametro = true    
                            if bandera_parametro
                                if param.valor == "BATERIA"
                                    bandera_bateria = true
                                elsif param.valor == "LLANTAS"
                                    bandera_llantas = true
                                elsif param.valor == "EXTINGUIDOR"
                                    bandera_extintor = true
                                end
                            end
                            tipo = param.valor_extendido
                        end
                    end
                end 
                if bandera_parametro
                    hash_checklist["bandera_ticket"] = bandera_parametro
                    hash_checklist["tipo"] = vc.conceptovehiculo
                else
                    hash_checklist["bandera_ticket"] = bandera_parametro
                    hash_checklist["tipo"] = ""
                end
                hash_checklist["bandera_bateria"] =bandera_bateria
                hash_checklist["bandera_llantas"] =bandera_llantas
                hash_checklist["bandera_extintor"] =bandera_extintor
            # @encabezado = vc.clasificacionvehiculo
                hash_checklist["id"] = vc.id
                hash_checklist["conceptovehiculo"] = vc.conceptovehiculo
                hash_checklist["vehicle_type_id"] = vc.vehicle_type_id
                hash_checklist["vehicle_type_name"] = vc.vehicle_type.descripcion
                hash_checklist["valor"] = nil
                @vehicle_checklist << hash_checklist
            end
            
            hash_checklists["encabezado"] = vcs.clasificacionvehiculo
            hash_checklists["descripcion"] = @vehicle_checklist
            @vehicle_checklists << hash_checklists 
            @vehicle_checklist = []
        end     
    else
      flash[:alert] = "No se encontr?? el veh??culo o no se puede asignar."
      redirect_to asignacion_vehiculos_path
    end
  end

  def registrar_checklist_vehiculo
    # bandera_list_error = false
    # mensaje = ""
    # vehicle = Vehicle.find_by(id:vehicle_check_list[0][:vehicle_id])
    # if vehicle.recibido == false

    # ChecklistResponse.transaction do
    #     vehicle_check_list.each do |vl|
    #       imagenes =vl[:recibir][:imagenes]
    #     checklist_response =   ChecklistResponse.new(
    #           vehicle_id: vl[:vehicle_id],
    #           catalog_personal_id:vl[:catalog_personal_id],
    #           fecha_captura: Date.today,
    #           motivo: vl[:recibir][:motivo]
    #       )
    #       if  checklist_response.save 
    #             vh = Vehicle.find(vl[:vehicle_id])
    #             vh.update(vehicle_status_id: 1)
    #               body_send.push(imagenes: imagenes, checklist_response_id: checklist_response.id, vehicle_id: vl[:vehicle_id])
    #           vl[:detalle].each do |det|
    #               checklis_response_detail = ChecklistResponseDetail.new(
    #                   checklist_response_id: checklist_response.id,
    #                   vehicle_checklist_id:det[:vehicle_checklist],
    #                   estatus:det[:estatus]
    #               )
    #               if !checklis_response_detail.save 
                      
    #                   mensaje = "#{checklis_response_detail.errors.full_messages}" 
    #                   bandera_list_error = true
    #               end
    #           end
    #       else
    #           bandera_list_error = true
    #       end
    #   end

    # end
  end
  def reporte_auditorias
    session["menu2"] = "Reporte de auditor??as"
    session["vehiculo_verificacion"] = ""
    session["empresa_verificacion"] = ""
    session["cedis_verificacion"] = ""
    session["usuario_verificacion"] = ""
    session["tipo_verificacion"] = ""
    session["area_verificacion"] = ""
    @resultados = BimonthlyVerification.consulta_auditorias(session["vehiculo_verificacion"],session["empresa_verificacion"], session["cedis_verificacion"], session["usuario_verificacion"],session["tipo_verificacion"], session["area_verificacion"])
  end

  def filtrado_auditorias
    session["vehiculo_verificacion"] = params[:vehicle_id]
    session["empresa_verificacion"] = params[:catalog_company_id]
    session["cedis_verificacion"] = params[:catalog_branch_id]
    session["usuario_verificacion"] = params[:catalog_personal_id]
    session["tipo_verificacion"] = params[:vehicle_type_id]
    session["area_verificacion"] = params[:catalog_area_id]
    @resultados = BimonthlyVerification.consulta_auditorias(session["vehiculo_verificacion"],session["empresa_verificacion"], session["cedis_verificacion"], session["usuario_verificacion"],session["tipo_verificacion"], session["area_verificacion"])
    respond_to do |format|
      format.js
    end
  end 
  
  def detalle_auditoria
    @checklist = BimonthlyVerification.find_by(id: params[:auditoria_id])
    @vehicle = @checklist.vehicle
    #ChecklistResponseDetail.joins(:checklist).joins(:vehicle_checklist).where(checklist: {id: 1}).order(vehicle_checklist: {clasificacionvehiculo: :asc})
    @respuestas = BimonthlyDetail.joins(:bimonthly_verification).joins(:vehicle_checklist).where(bimonthly_verifications: {id: @checklist.id}).order("vehicle_checklists.clasificacionvehiculo asc")
    #@respuestas = @checklist.checklist_response_detail.order(vehicle_checklist_id: :asc)
    @cantidad_mitad = ((@respuestas.length / 2) - 1).to_i
    @respuestas.each do |respuesta|
        valor = instance_variable_get("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id")
        if valor.nil?
            instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id", 1)
            instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_texto", respuesta.vehicle_checklist.clasificacionvehiculo)
        else
            anterior = instance_variable_get("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id")
            instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id", anterior + 1)
        end
    end
  end

  def plantilla_maestro_vehiculo_completa
    require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		workbook.styles do |s|
			img = File.expand_path("#{Rails.root}/app/assets/images/excel_logo.png", __FILE__)
			col_widths= [3,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30] 
			celda_tabla = s.add_style :bg_color => "BFBFBF", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
      celda_cabecera2= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right, :vertical => :center}
			celda_categoria = s.add_style :bg_color => "D9D9D9", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_notas = s.add_style :fg_color => "FF0000" ,:sz => 12
			celda_afi_mayor = s.add_style :bg_color => "808080", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_afi_menor = s.add_style :bg_color => "F2F2F2", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}

			workbook.add_worksheet(name: "Importaci??n") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        vehiculos = Vehicle.all.order(numero_economico: :asc)
				sheet.merge_cells("B1:D7")
				sheet.add_row ["","Importaci??n de datos de maestro de veh??culos","","","","", "", "Notas:"], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,celda_notas]
        sheet.add_row ["","","","","","","","Los campos con * deben de ser completados con los identificadores de las hojas correspondientes"], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","","El campo 'Identificador' no debe ser modificado. El ser modificado puede causar que el veh??culo no se encuentre o se modifique el veh??culo incorrecto."]
        sheet.add_row ["","","","","","","","En caso de ser remolque llenar el campo 'Subtipo de remolque', en caso contrario llenar los campos 'Tipo de permiso' y 'Configuraci??n de veh??culo'."]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador", "N??mero econ??mico", "Empresa *", "Centro de costo *", "Responsable *", "Usuario *", "Celular responsable", "Celular usuario", "Estatus del veh??culo *", "Tipo de veh??culo *", "N??mero de serie", "N??mero de motor", "Transimisi??n (Std/Aut)", "Empresa facturable *", "N??mero de factura", "Fecha de compra", "Valor de compra", "N??mero de factura de adaptaci??n", "N??mero de serie de adaptaci??n", "Valor de adaptaci??n", "Ruta *", "N??mero de p??liza", "Inciso", "Cobertura de p??liza *", "Beneficiario *", "N??mero de placa", "Estado de plaqueo *", "Permiso federal de carga", "Permiso fisicomec??nico", "Permiso ambiental", "Litros autorizados", "Modelo *", "A??o *", "Cedis *", "??rea *", "Almac??n *", "Color", "Impuestos", "Fecha de licencia", "N??mero de licencia", "Fecha de vigencia de placas", "Fecha de vigencia de p??liza", "Fecha de vigencia fisicomec??nica", "Fecha de vigencia ambiental", "Permiso SCT", "N??mero de permiso", "Nombre de aseguradora", "Tipo de permiso * (opcional)", "Configuraci??n del veh??culo * (opcional)", "Subtipo de remolque * (opcional)", "Reparto"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera, celda_cabecera]
        vehiculos.each do |vehicle|
          sheet.add_row ["", vehicle.id, vehicle.numero_economico, vehicle.catalog_company_id, vehicle.cost_center_id, vehicle.responsable_id, vehicle.catalog_personal_id, vehicle.celular_responsable, vehicle.celular, vehicle.vehicle_status_id, vehicle.vehicle_type_id, vehicle.numero_serie, vehicle.numero_motor, vehicle.transmision, vehicle.billed_company_id, vehicle.numero_factura, vehicle.fecha_compra, vehicle.valor_compra, vehicle.numero_factura_adapt, vehicle.numero_serie_adapt, vehicle.valor_adapt, vehicle.catalog_route_id, vehicle.numero_poliza, vehicle.inciso, vehicle.policy_coverage_id, vehicle.insurance_beneficiary_id, vehicle.numero_placa, vehicle.plate_state_id, vehicle.permiso_federal_carga, vehicle.permiso_fisico_mecanico, vehicle.permiso_ambiental, vehicle.litros_autorizados, vehicle.catalog_brand_id, vehicle.catalog_model_id, vehicle.catalog_branch_id, vehicle.catalog_area_id, vehicle.warehouse_id, vehicle.vehicle_color, vehicle.impuestos, vehicle.fecha_licencia, vehicle.numero_licencia, vehicle.fecha_vigencia_placas, vehicle.fecha_vigencia_poliza, vehicle.fecha_vigencia_fisico, vehicle.fecha_vigencia_ambiental, vehicle.permiso_sat, vehicle.numero_permiso, vehicle.numero_aseguradora, vehicle.permission_type_id, vehicle.vehicle_configuration_id, vehicle.trailer_subtype_id, vehicle.reparto], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td, celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Responsables") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        responsables = Responsable.where(status: true).order(nombre: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Responsables","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador", "Nombre"], :style => [nil,celda_cabecera,celda_cabecera]
        responsables.each do |responsable|
          sheet.add_row ["", responsable.id, responsable.nombre], :style => [nil,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Usuarios") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        usuarios = CatalogPersonal.where(estatus: 1).order(nombre: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Usuarios","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Nombre", "RFC", "Celular", "Direcci??n", "Correo"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        usuarios.each do |usr|
          sheet.add_row ["", usr.id, usr.clave, usr.nombre,usr.rfc, usr.celular, usr.direccion, usr.correo], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Centros de costo") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        centros_costo = CostCenter.where(status: true).order(catalog_company_id: :asc, catalog_branch_id: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Centros de costo","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador", "Clave", "Descripci??n", "Empresa", "Cedis", "Unidad de negocio"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        centros_costo.each do |cc|
          sheet.add_row ["", cc.id, cc.clave, cc.descripcion, cc.catalog_company.nombre, cc.catalog_branch.decripcion, cc.unidad_negocio], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Estatus del veh??culo") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        estatus = VehicleStatus.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Estatus del veh??culo","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador", "Descripci??n"], :style => [nil,celda_cabecera,celda_cabecera]
        estatus.each do |status|
          sheet.add_row ["", status.id, status.descripcion], :style => [nil,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Tipos de veh??culo") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        tipos = VehicleType.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Tipos de veh??culo","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera]
        tipos.each do |tipo|
          sheet.add_row ["", tipo.id, tipo.clave, tipo.descripcion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Empresa facturable") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        empresas = BilledCompany.where(status: true).order(nombre: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Empresa facturable","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Nombre", "Domicilio", "RFC", "Tel??fono"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        empresas.each do |emp|
          sheet.add_row ["", emp.id, emp.clave_jd, emp.nombre, emp.domicilio, emp.rfc, emp.telefono], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Rutas") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        rutas = CatalogRoute.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Rutas","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera]
        rutas.each do |ruta|
          sheet.add_row ["", ruta.id, ruta.clave, ruta.descripcion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Cobertura de p??liza") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        coberturas = PolicyCoverage.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Cobertura de p??liza","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera]
        coberturas.each do |cobertura|
          sheet.add_row ["", cobertura.id, cobertura.clave, cobertura.descripcion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Beneficiarios") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        beneficiarios = InsuranceBeneficiary.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Beneficiarios","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera]
        beneficiarios.each do |beneficiario|
          sheet.add_row ["", beneficiario.id, beneficiario.clave, beneficiario.descripcion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Estados de plaqueo") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        estados = PlateState.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Estados de plaqueo","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera]
        estados.each do |estado|
          sheet.add_row ["", estado.id, estado.clave, estado.descripcion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Modelos") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        modelos = CatalogBrand.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Modelos","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera]
        modelos.each do |modelo|
          sheet.add_row ["", modelo.id, modelo.clave, modelo.descripcion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "A??os") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        anios = CatalogModel.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","A??os","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera]
        anios.each do |anio|
          sheet.add_row ["", anio.id, anio.clave, anio.descripcion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Empresas") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        empresas = CatalogCompany.where(status: true).order(nombre: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Empresas","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Nombre", "Abreviatura", "C??digo Postal", "Tel??fono", "RFC"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        empresas.each do |emp|
          sheet.add_row ["", emp.id, emp.clave, emp.nombre,emp.abreviatura, emp.codigo_postal, emp.telefono, emp.rfc], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Cedis") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        cedis = CatalogBranch.where(status: true).order(decripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Cedis","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Clave JDE", "Descripci??n", "Empresa", "Unidad de negocio", "Abreviaci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        cedis.each do |ced|
          sheet.add_row ["", ced.id, ced.clave, ced.clave_jd,ced.decripcion, ced.catalog_company.nombre, ced.unidad_negocio, ced.abreviacion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Areas") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        areas = CatalogArea.where(status: true).order(descripcion: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","??reas","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n", "Tipo", "Abreviaci??n"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        areas.each do |area|
          sheet.add_row ["", area.id, area.clave,area.descripcion, area.tipo, area.abreviacion], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Tipos de permiso") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        tipos_permiso = PermissionType.all.order(clave: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Tipos de permiso","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n", "Clave transporte", "Fecha de inicio de vigencia", "Fecha de fin de vigencia"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        tipos_permiso.each do |perm|
          sheet.add_row ["", perm.id, perm.clave, perm.descripcion, perm.clave_transporte, perm.fecha_inicio_vigencia, perm.fecha_fin_vigencia], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Configuraci??n del veh??culo") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        configuraciones = VehicleConfiguration.all.order(clave: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Configuraci??n del veh??culo","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n", "N??mero de ejes", "N??mero de llantas", "Fecha de inicio de vigencia", "Fecha de fin de vigencia"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        configuraciones.each do |config|
          sheet.add_row ["", config.id, config.clave, config.descripcion, config.numero_ejes, config.numero_llantas, config.fecha_inicio_vigencia, config.fecha_fin_vigencia], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Subtipos de remolque") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        subtipos = TrailerSubtype.all.order(clave: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Subtipos de remolque","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "nombre", "Fecha de inicio de vigencia", "Fecha de fin de vigencia"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        subtipos.each do |subtipo|
          sheet.add_row ["", subtipo.id, subtipo.clave, subtipo.nombre, subtipo.fecha_inicio_vigencia, subtipo.fecha_fin_vigencia], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
      workbook.add_worksheet(name: "Almacenes") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        almacenes = Warehouse.where(estatus: true).order(clave: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Almacenes","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Identificador","Clave", "Descripci??n", "Empresa"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        almacenes.each do |almacen|
          sheet.add_row ["", almacen.id, almacen.clave, almacen.descripcion, almacen.catalog_company.nombre], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td]
        end
        sheet.column_widths *col_widths
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Layout maestro de veh??culos.xlsx"
  end

  def plantilla_carta_porte
    require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		workbook.styles do |s|
			img = File.expand_path("#{Rails.root}/app/assets/images/excel_logo.png", __FILE__)
			col_widths= [3,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30] 
			celda_tabla = s.add_style :bg_color => "BFBFBF", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
      celda_cabecera2= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right}
			celda_categoria = s.add_style :bg_color => "D9D9D9", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_notas = s.add_style :fg_color => "FF0000" ,:sz => 12
			celda_afi_mayor = s.add_style :bg_color => "808080", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_afi_menor = s.add_style :bg_color => "F2F2F2", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}

			workbook.add_worksheet(name: "Importaci??n") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        vehiculos = Vehicle.where(vehicle_status_id: 1).order(numero_economico: :asc)
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Importaci??n de datos de maestro de veh??culos","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,celda_notas]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "noEconomico", "Compania", "TipoUnidad", "placaVehicular", "anoModelo", "noPoliza", "licencia", "permisoSCT", "configVehicular", "subtipoRemolque", "numeroPermisoSCT", "nombreAseguradora", "cedis", "area", "responsable", "cobertura", "unidadRemolque", "estatus", "noEconomicoRem", "reparto"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        vehiculos.each do |vehicle|
          vehicle.permission_type ? tipopermiso = vehicle.permission_type.clave : tipopermiso = "NA"
          vehicle.vehicle_configuration ? configvehiculo = vehicle.vehicle_configuration.clave : configvehiculo = "NA"
          #vehicle.trailer_subtype ? subtiporem = vehicle.trailer_subtype.clave : subtiporem = "NA"
          vehicle.trailer_subtype ? subtiporem = vehicle.trailer_subtype.clave : subtiporem = ""
          #subtiporem = ""
          vehicle.vehicle_type.clave == "010" ? tipovehiculo = 1 : tipovehiculo = 0
          if vehicle.reparto == true 
            repartoveh = 1
          elsif vehicle.reparto == false 
            repartoveh = 0
          else
            repartoveh = "NA"
          end
          (vehicle.permiso_sat != nil and vehicle.permiso_sat.gsub(" ", "") == "") or vehicle.permiso_sat == nil ? permiso_sct = "NA" : permiso_sct = vehicle.permiso_sat
          if permiso_sct == nil
            permiso_sct = "NA"
          end
          
          vehicle.vehicle_status.nombre == "Inac" ? estatusveh = 0 : estatusveh = 1
          sheet.add_row ["",
          vehicle.numero_economico,
          vehicle.catalog_company.clave,
          vehicle.vehicle_type.clave,
          vehicle.numero_placa,
          vehicle.catalog_model.descripcion,
          vehicle.numero_poliza,
          vehicle.numero_licencia,
          tipopermiso,
          configvehiculo,
          subtiporem,
          permiso_sct,
          vehicle.numero_aseguradora,
          vehicle.catalog_branch.clave_jd,
          vehicle.catalog_area.abreviacion,
          vehicle.catalog_personal.clave,
          vehicle.policy_coverage.clave,
          tipovehiculo,
          estatusveh,
          "NA",
          repartoveh], :style => [nil,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td], :types => [nil,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string]
        end
        sheet.column_widths *col_widths
      end
      send_data package.to_stream.read, type: "application/xlsx", filename: "Layout carta porte.xlsx"
    end
  end
  
  
  def importar_maestro_vehiculos
    @vehicle = Vehicle.importar_actualizacion_maestro_vehiculos(params[:file])
    #byebug
    respond_to do |format|
      if @vehicle.count == 0
        format.html { redirect_to vehicles_url, notice: "Plantilla cargada con ??xito." }
      else
        format.html { render :update_master_errors }
        format.json { render json: @vehicles }
      end
    end
  end

  def vehicle_expenses
    
  end

  def gastos_vehiculo_x_fecha
    fecha_inicio = params[:start_date]
    fecha_fin = params[:end_date]
    if (fecha_inicio == nil or fecha_inicio == "") and (fecha_fin == nil or fecha_fin == "")
      @resultados = MaintenanceControl.where("vehicle_id = ?", @vehicle.id)
    elsif (fecha_inicio != nil and fecha_inicio != "") and (fecha_fin == nil or fecha_fin == "")
      @resultados = MaintenanceControl.where("vehicle_id = ? and fecha_factura >= ?", @vehicle.id, Date.strptime(fecha_inicio, "%d/%m/%Y"))
    elsif (fecha_inicio == nil or fecha_inicio == "") and (fecha_fin != nil and fecha_fin != "")
      @resultados = MaintenanceControl.where("vehicle_id = ? and fecha_factura <= ?", @vehicle.id, Date.strptime(fecha_fin, "%d/%m/%Y"))
    elsif  (fecha_inicio != nil and fecha_inicio != "") and (fecha_fin != nil and fecha_fin != "")
      @resultados = MaintenanceControl.where("vehicle_id = ? and fecha_factura between ? and ?", @vehicle.id, Date.strptime(fecha_inicio, "%d/%m/%Y"), Date.strptime(fecha_fin, "%d/%m/%Y"))
    end
    
  end

  def vehicle_files
    @vehicle = Vehicle.find_by(id: params[:id])
    @documents = VehicleFile.where(vehicle_id:params[:id]) + GeneralVehicleFile.all
    session["vehicle_id_arch"] = params[:id]
  end
  
  def upload_document
    @vehicle = Vehicle.find_by(id: params[:id_vehicle])
    separacion = params[:file].original_filename.split(" ")
    if separacion[1].nil?
      tipo_documento = nil
    else
      tipo_documento = separacion[1]
    end
    
    if separacion[2].nil?
      fecha_vigencia = nil
    else
      begin
        fecha_vigencia = Date.strptime(separacion[2], "%d_%m_%Y")
      rescue Exception => e
        fecha_vigencia = nil
      end
    end
    if @vehicle
      archivo = VehicleFile.new(documento: params[:file], vehicle_id: @vehicle.id, nombre_archivo: params[:file].original_filename, tipo_archivo: VehicleFile.cambio_tipo(tipo_documento), fecha_vencimiento: fecha_vigencia)
    else
      archivo = GeneralVehicleFile.new(documento: params[:file], nombre_archivo: params[:file].original_filename, tipo_archivo: VehicleFile.cambio_tipo(tipo_documento), fecha_vencimiento: fecha_vigencia)
    end
    if archivo.save
      if @vehicle
        @documents = VehicleFile.where(vehicle_id: params[:id_vehicle])
      else
        @documents = GeneralVehicleFile.all
      end
      @bandera_error = false
    else
      @mensaje = ""
      archivo.errors.full_messages.each do |error|
        @mensaje += "#{error}. "
      end
      @bandera_error = true
    end
    respond_to do |format|
      format.js
      format.json
    end
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def validacion_menu
      session["menu1"] = "Maestro de veh??culos"
      session["menu2"] = "Maestro"
    end

    # Only allow a list of tvehicle_brand_idrusted parameters through.
    def vehicle_params
      params.require(:vehicle).permit(:numero_economico, :catalog_company_id, :catalog_branch_id, :cost_center_id, :responsable_id, :vehicle_status_id, :vehicle_type_id, :catalog_brand_id, :catalog_model_id, :numero_serie, :numero_motor, :transmision, :billed_company_id, :numero_factura, :fecha_compra, :valor_compra, :numero_factura_adapt, :numero_serie_adapt, :valor_adapt, :catalog_route_id, :numero_poliza, :inciso, :policy_coverage_id, :insurance_beneficiary_id, :numero_placa, :plate_state_id, :permiso_federal_carga, :permiso_fisico_mecanico, :permiso_ambiental, :litros_autorizados,:catalog_area_id,:vehicle_color,:file,:foto,:siniestrado,:factura,:aseguradora,:federal,:mecanico,:ambiental,:catalog_personal_id,:fecha_licencia,:numero_licencia,:purchase_detail_id,:reparto,:proxima_verificacion,:base, :permiso_sat, :numero_permiso, :numero_aseguradora, :celular, :permission_type_id, :vehicle_configuration_id, :trailer_subtype_id, :warehouse_id, :fecha_vigencia_fisico, :fecha_vigencia_ambiental, :fecha_vigencia_poliza)
    end
    def invalid_foreign_key
      
      redirect_to vehicles_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
