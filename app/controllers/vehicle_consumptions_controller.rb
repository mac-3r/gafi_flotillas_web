class VehicleConsumptionsController < ApplicationController
  before_action :set_vehicle_consumption, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :validacion_menu
  # except: [:reporte_acumulado,:detalle,:generar_excel_acumulado,:filtrado_acumulado,:filtrado_km,:indicador_presupuesto,:indicador_km]

  # GET /vehicle_consumptions
  # GET /vehicle_consumptions.json
  def index
    session["fecha_inicio"] = ""
    session["fecha_fin"] = ""
    session["proveedor"] = ""
    session["cedis"] = ""
    session["estatus"] = ""
  
    @encabezado = Consumption.consulta_cargas(session["fecha_inicio"], session["fecha_fin"],session["proveedor"], session["cedis"], session["estatus"])
  end
 

  def show_vehicle_consumptions
    session["menu1"]="Combustible"
    session["menu2"]="Autorizacion"
    puts "********************************************"
    puts "current_user:",current_user
    puts "current_user:",@current_user

    #@encabezado = Consumption.select("catalog_vendor_id, catalog_branch_id, semana, estatus, fecha_inicio, fecha_fin").where("estatus = ?", [1]).where(usuario_autorizante_id:current_user.id).group("catalog_vendor_id, catalog_branch_id,semana, estatus, fecha_inicio, fecha_fin")
    @encabezado = Consumption.select("catalog_vendor_id, catalog_branch_id, semana, estatus, fecha_inicio, fecha_fin").where("estatus = ?", [1]).group("catalog_vendor_id, catalog_branch_id,semana, estatus, fecha_inicio, fecha_fin")


    #@folios = Consumption.select("folio, catalog_vendor_id, catalog_branch_id, semana, estatus, fecha_inicio, fecha_fin").where("estatus = ?", [1]).where(usuario_autorizante_id:current_user.id)
    
    @folios = Consumption.select("folio, catalog_vendor_id, catalog_branch_id, semana, estatus, fecha_inicio, fecha_fin").where("estatus = ?", [1])

  end


  def filtrado_cargas
    session["proveedor"] = params[:catalog_vendor_id]
    session["cedis"] = params[:catalog_branch_id]
    session["estatus"] = "#{params[:estatus]}"
    
    if params[:start_date] != "" and params[:end_date] != ""
      session["fecha_inicio"] = Date.strptime(params[:start_date], "%d/%m/%Y")
      session["fecha_fin"] = Date.strptime(params[:end_date], "%d/%m/%Y")
    else
      session["fecha_inicio"] = ""
      session["fecha_fin"] = ""
    end
    @encabezado = Consumption.consulta_cargas(session["fecha_inicio"], session["fecha_fin"],session["proveedor"], session["cedis"], session["estatus"])
    respond_to do |format|
      format.js
    end
  end

  def indicador_presupuesto
    session["menu2"] = "Indicador vehículos fuera de presupuesto"
  end

  def indicador_km
    session["menu2"] = "Indicador vehículos dentro del objetivo del gasto por km"
  end

  # GET /vehicle_consumptions/1
  # GET /vehicle_consumptions/1.json
  def show
  end

  
  # GET /vehicle_consumptions/new
  def new
    @vehicle_consumption = VehicleConsumption.new
  end

  # GET /vehicle_consumptions/1/edit
  def edit
  end

  def import_consumption
    bandera_error = 0
    mensaje = ""
    fecha_inicio = (DateTime.parse(params[:start_date])).strftime("%Y-%m-%d")
    fecha_final = (DateTime.parse(params[:end_date])).strftime("%Y-%m-%d")
    if !params[:consumption][:base].present?
      bandera_base = false
    else
      bandera_base = true
    end

      
    consulta_corte = Deadline.where("fecha_inicio <= '#{fecha_inicio}' and fecha_fin >= '#{fecha_final}' and estatus = TRUE")
    
    if consulta_corte.length > 0
      flash[:alert] = 'Ya se realizó el corte para las fechas seleccionadas.'
      redirect_to vehicle_consumptions_path
    else
      busqueda = Consumption.where("semana = #{params[:semana]} and fecha_descripcion = '#{params[:descripcion]}' and fecha_inicio = '#{fecha_inicio}' and fecha_fin ='#{fecha_final}' and catalog_vendor_id = #{params[:consumption][:catalog_vendor_id]} and catalog_branch_id = #{params[:consumption][:catalog_branch_id]}")
      #si no tiene nada entonces dejara insertar
      if busqueda[0].nil?
          @vehicle_consumption = VehicleConsumption.import_consumption(params[:file])
          respond_to do |format|
            if @vehicle_consumption[0].length == 0
              #byebug
              folio_consecutivo = Consumption.last
              folio_consecutivo ? nuevo_folio = folio_consecutivo.folio.to_i + 1 : nuevo_folio = 1
              if params[:start_date] != "" and params[:end_date] != "" and @vehicle_consumption[1] > 0 and @vehicle_consumption[2] > 0 
                params[:consumption][:catalog_branch_id] = params[:consumption][:catalog_branch_id]  
                params[:consumption][:catalog_vendor_id] = params[:consumption][:catalog_vendor_id]  
                              
                @consumo = Consumption.create(folio: nuevo_folio, monto: @vehicle_consumption[1], cargas: @vehicle_consumption[2],fecha_inicio: params[:start_date], fecha_fin: params[:end_date], estatus: "Pendiente", catalog_branch_id: params[:consumption][:catalog_branch_id].to_i, valuation_id: params[:consumption][:valuation_id].to_i, catalog_vendor_id: params[:consumption][:catalog_vendor_id].to_i,semana: params[:semana],fecha_descripcion: params[:descripcion],usuario_creador: "#{current_user.name} #{current_user.last_name}",base:bandera_base)
                detalle = VehicleConsumption.where(id: @vehicle_consumption[3]).update(consumption_id: @consumo.id)
                format.html {redirect_to vehicle_consumptions_url, notice: "Importación cargada con éxito."}
              else
                respond_to do |format|
                  flash[:alert] = 'Favor de completar la fecha de inicio y fin.'
                  format.html { redirect_to vehicle_consumptions_url, status: :unprocessable_entity }
                end
              end
            else
              #byebug
              format.html {render :import_consumption_errors}
              format.json {render json: @vehicle_consumption}
            end
          end
        else
          flash[:alert] = 'Ya existe este registro.'
          redirect_to vehicle_consumptions_path
        end
    end
  end

  def template_download_consumption
    send_file "#{Rails.root}/public/packs/Importaciones/Plantilla de Productos.xlsx"
  end 
  #RENDIMIENTOS
  def reporte_mensual
    session["menu2"] = "Reporte de rendimiento mensual de reparto"
    @bandera_inicio = 1
      # año =  Time.zone.now.year - 1
      # año_anterior = Time.zone.now.year - 2
    fecha_inicio = Time.zone.now.beginning_of_year
    fecha_fin = Time.zone.now.end_of_year
    session["fec_ini_rep_mens"] = fecha_inicio.strftime("%m/%Y")
    session["fec_fin_rep_mens"] = fecha_fin.strftime("%m/%Y")
    session["comp_id_rep_mens"] = ""
    session["branch_id_rep_mens"] = ""
    session["area_id_rep_mens"] = ""
    session["veh_id_rep_mens"] = ""
    consulta = VehicleConsumption.consulta_reporte_mensual(fecha_inicio.strftime("%m/%Y"), fecha_fin.strftime("%m/%Y"), "", "", "", "")
    @arreglo_mes_fecha = consulta[0]
    @arreglo_mes_datos = consulta[1]
    #byebug
    #exportar a excel
    respond_to do |format|
      format.html
      format.csv { send_data @vehicle_consumption.to_csv }
      format.xlsx
    end
  end

  def filtrado_reporte_mensual
    @bandera_inicio = 0
    @bandera_renderiza = 0
    if params[:fecha_inicio] == "" and params[:fecha_fin] != ""
      @bandera_renderiza == 2
    else
      session["fec_ini_rep_mens"] = params[:fecha_inicio],
      session["fec_fin_rep_mens"] = params[:fecha_fin]
      session["comp_id_rep_mens"] = params[:catalog_company_id]
      session["branch_id_rep_mens"] = params[:catalog_branch_id]
      session["area_id_rep_mens"] = params[:area_id]
      session["veh_id_rep_mens"] = params[:vehicle_id]
      consulta = VehicleConsumption.consulta_reporte_mensual(params[:fecha_inicio], params[:fecha_fin], params[:catalog_company_id], params[:catalog_branch_id], params[:area_id], params[:vehicle_id])
      @arreglo_mes_fecha = consulta[0]
      @arreglo_mes_datos = consulta[1]
    end
    
  end
  

  def rendimiento_excel
    consulta = VehicleConsumption.consulta_reporte_mensual(session["fec_ini_rep_mens"], session["fec_fin_rep_mens"], session["comp_id_rep_mens"], session["branch_id_rep_mens"], session["area_id_rep_mens"], session["veh_id_rep_mens"])
    arreglo_mes_fecha = consulta[0]
    arreglo_mes_datos = consulta[1]
    # año =  Time.zone.now.year - 1

   require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.styles do |s|
      miles_decimal = s.add_style(:sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}, :format_code => "###,###.00")
			celda_cabecera= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right}
      col_widths= [3,30,30,30,30,30,30] 
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

      arreglo_mes_fecha.each_with_index do |fecha, index|
        workbook.add_worksheet(name: fecha.strftime("%B %Y")) do |sheet|

          sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
            image.width = 105
            image.height = 137
            image.start_at 1, 0
          end
          sheet.merge_cells("B1:D7")
          sheet.add_row ["","Rendimiento mensual de reparto","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
          sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
          sheet.add_row ["","","","","","","",""]
          sheet.add_row ["","","","","","","",""]
          sheet.add_row [""]
          sheet.add_row [""]
          sheet.add_row [""]
          sheet.add_row ["","Unidad","CEDIS","Tipo de vehículo","Modelo", "Cierre #{fecha.strftime("%B")}", "Recorrido #{fecha.strftime("%B")}","Lts #{fecha.strftime("%B")}","Rendimiento #{fecha.strftime("%B")}","Rendimiento ideal"], :style => [nil, celda_cabecera, celda_cabecera,celda_cabecera, celda_cabecera, celda_cabecera, celda_cabecera, celda_cabecera, celda_cabecera, celda_cabecera, celda_cabecera]
          sheet.column_widths *col_widths
  
          arreglo_mes_datos[index].each do |dat|
            sheet.add_row ["",dat.vehicle.numero_economico, dat.vehicle.catalog_branch.decripcion,  dat.vehicle.vehicle_type.descripcion,  dat.vehicle.catalog_model.descripcion , dat.cierre, dat.recorrido,dat.lts,dat.rendimiento,dat.vehicle.vehicle_type.rendimiento_ideal], style: [nil, celda_tabla_td, celda_tabla_td, celda_tabla_td, celda_tabla_td, miles_decimal,miles_decimal,miles_decimal,miles_decimal,miles_decimal]
            end
        end
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Reporte rendimiento mensual.xlsx"
  end
  #indicador rendimiento

  def indicador_rendimiento
    session["menu2"] = "Indicador vehículos dentro de rendimiento"
  end
  
  def filtrado_indicadores
    @indicador = Array.new
    @arreglo = []
    @arreglo_ren = []
    @bandera_error = false
    cedis = params[:catalog_branch_id] 
    compania = params[:catalog_company_id]
    @resultados = []

    #byebug
    if params[:start_date].nil? or params[:start_date] == ""
			@bandera_error = true
      @mensaje = "Seleccione la fecha."
    else
      session["fechaini_dvi"] = params[:start_date]
    end
    if params[:catalog_company_id].nil? or params[:catalog_company_id] == ""
			@bandera_error = true
      @mensaje = "Seleccione la empresa."
    else
      session["compania_s"] = params[:catalog_company_id]
    end

    if params[:end_date].nil? or params[:end_date] == ""
			@bandera_error = true
      @mensaje = "Seleccione la fecha."
    else
      session["fechafinal_dvi"] = params[:end_date]
    end

		session["area_dvi"] = params[:area_id]
		session["vehiculo_dvi"] = params[:vehicle_id]
    
    if !@bandera_error
      fecha_inicio = (DateTime.parse(params[:start_date])).strftime("%Y-%m-%d")
      fecha_final = (DateTime.parse(params[:end_date])).strftime("%Y-%m-%d")
      fecha_inicio_anterior = (DateTime.parse(params[:start_date]) - 1.month)
      fecha_final_anterior = fecha_inicio_anterior.end_of_month
      @total_grafica = 0
      @buen_grafica = 0
      @percentaje_grafica = 0
      if cedis !="" 
        #CUANDO SE SELECCIONA CEDIS
        @cedis = CatalogBranch.where(id: cedis)
        #byebug
        @cedis.each do |ced|
          if session["area_dvi"] == "" and session["vehiculo_dvi"] == ""
            @query = VehicleConsumption.joins(:vehicle).joins(:consumption).select("vehicle_id","vehicle_type_id as tipo","consumptions.catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(vehicles:{catalog_branch_id:ced.id, reparto: true}).where.not(consumptions: {id:nil}).group(:vehicle_id, "consumptions.catalog_branch_id",:vehicle_type_id)
          elsif session["area_dvi"] != "" and session["vehiculo_dvi"] == ""
            @query = VehicleConsumption.joins(:vehicle).joins(:consumption).select("vehicle_id","vehicle_type_id as tipo","consumptions.catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(catalog_area_id: session["area_dvi"] ,vehicles:{catalog_branch_id:ced.id, reparto: true}).where.not(consumptions: {id:nil}).group(:vehicle_id, "consumptions.catalog_branch_id",:vehicle_type_id)
          elsif session["area_dvi"] == "" and session["vehiculo_dvi"] != ""
            @query = VehicleConsumption.joins(:vehicle).joins(:consumption).select("vehicle_id","vehicle_type_id as tipo","consumptions.catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(vehicle_id: session["vehiculo_dvi"] ,vehicles:{catalog_branch_id:ced.id, reparto: true}).where.not(consumptions: {id:nil}).group(:vehicle_id, "consumptions.catalog_branch_id",:vehicle_type_id)
          elsif session["area_dvi"] != "" and session["vehiculo_dvi"] != ""
            @query = VehicleConsumption.joins(:vehicle).joins(:consumption).select("vehicle_id","vehicle_type_id as tipo","consumptions.catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(catalog_area_id: session["area_dvi"], vehicle_id: session["vehiculo_dvi"], vehicles:{catalog_branch_id:ced.id, reparto: true}).where.not(consumptions: {id:nil}).group(:vehicle_id, "consumptions.catalog_branch_id",:vehicle_type_id)
          end
          cumple = 0
          no_cumple = 0
          @query.each do |que|
            rendimiento_i = VehicleType.find_by(id: que.tipo)

            if rendimiento_i.rendimiento_ideal != nil
              if que.rendimiento.to_f >= rendimiento_i.rendimiento_ideal
                cumple += 1
              else
                no_cumple += 1
              end       
            end
          end
          total_vehiculos = cumple + no_cumple
          percentaje =   cumple.to_f/total_vehiculos.to_f * 100.0
          @resultados.push(cedis: ced.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje)
        end
        #datos para grafica
        @resultados.each do |res|
          @total_grafica += res[:total]
          @buen_grafica += res[:buen]
         end
         @percentaje_grafica = @buen_grafica.to_f/@total_grafica.to_f * 100.0
      else
        @cedis = CatalogBranch.where(catalog_company_id: compania)
        @cedis.each do |ced|
          if session["area_dvi"] == "" and session["vehiculo_dvi"] == ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(vehicles:{catalog_branch_id:ced.id, reparto: true}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
          elsif session["area_dvi"] != "" and session["vehiculo_dvi"] == ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(catalog_area_id: session["area_dvi"] ,vehicles:{catalog_branch_id:ced.id, reparto: true}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
          elsif session["area_dvi"] == "" and session["vehiculo_dvi"] != ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(vehicle_id: session["vehiculo_dvi"] ,vehicles:{catalog_branch_id:ced.id, reparto: true}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
          elsif session["area_dvi"] != "" and session["vehiculo_dvi"] != ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(catalog_area_id: session["area_dvi"], vehicle_id: session["vehiculo_dvi"], vehicles:{catalog_branch_id:ced.id, reparto: true}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
          end
          #@query = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio}' and '#{fecha_final}' then cantidad end))) as rendimiento").where(vehicles:{catalog_branch_id:ced.id, reparto: true}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
          cumple = 0
          no_cumple = 0
          @query.each do |que|
            rendimiento_i = VehicleType.find_by(id: que.tipo)
            #byebug
            if rendimiento_i.rendimiento_ideal != nil
              if que.rendimiento.to_f >= rendimiento_i.rendimiento_ideal
                cumple += 1
              else
                no_cumple += 1
              end       
            end
          end
          total_vehiculos = cumple + no_cumple
          if cumple == 0 and no_cumple == 0
            percentaje = 0
          else
            percentaje =   cumple.to_f/total_vehiculos.to_f * 100.0
          end
          @resultados.push(cedis: ced.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje.round(2))
        end
         @resultados.each do |res|
          @total_grafica += res[:total]
          @buen_grafica += res[:buen]
         end
         @percentaje_grafica = @buen_grafica.to_f/@total_grafica.to_f * 100.0
      end
    end
  end




  #muestra los vehiculos para el reporte
  def reporte_acumulado
    session["menu2"] = "Reporte de control de combustible acumulado"
    session["vehiculo_acumulado"] = ""
    session["empresa_acumulado"] = ""
    session["cedis_acumulado"] = ""
    session["area_acumulado"] = ""
    session["fecha_inicio_ac"] = ""
    session["fecha_fin_ac"] = ""

    @listado = VehicleConsumption.consulta_acumulado(session["vehiculo_acumulado"], session["empresa_acumulado"],session["cedis_acumulado"],session["area_acumulado"],session["fecha_inicio_ac"],session["fecha_fin_ac"])
    #@reporte = VehicleConsumption.find_by_sql("select vehicle_id from vehicle_consumptions group by vehicle_id")
  end

  def filtrado_acumulado_combustible
    session["vehiculo_acumulado"] = params[:vehicle_id]
    session["empresa_acumulado"] = params[:catalog_company_id]
    session["cedis_acumulado"] = params[:catalog_branch_id]
    session["area_acumulado"] = params[:area_id]
    if params[:fecha_inicio] != "" and params[:fecha_fin] != ""
      session["fecha_inicio_ac"] = Date.strptime(params[:fecha_inicio], "%d/%m/%Y")
      session["fecha_fin_ac"] =  Date.strptime(params[:fecha_fin], "%d/%m/%Y")
    else
      session["fecha_inicio_ac"] = ""
      session["fecha_fin_ac"] = ""
    end
    
    @listado = VehicleConsumption.consulta_acumulado(session["vehiculo_acumulado"], session["empresa_acumulado"],session["cedis_acumulado"],session["area_acumulado"],session["fecha_inicio_ac"],session["fecha_fin_ac"])
    if @listado == []
      @bandera_error = true
      @mensaje = "No se encontró información."
    end
    
  end
  #muestra el consumo del vehiculo seleccionado
  def detalle
    @encabezado = VehicleConsumption.find_by(id: params[:vehicle_id])
    fecha = "#{params[:start_date]}"
    if fecha != ""
      session["fecha"] = params[:start_date].to_date.strftime("%Y-%m-%d")
      @reporte = VehicleConsumption.joins(:consumption).where("vehicle_consumptions.vehicle_id=#{params[:vehicle_id]} and vehicle_consumptions.fecha='#{session["fecha"]}' and consumptions.estatus != 0")
    else
      @reporte = VehicleConsumption.joins(:consumption).where("consumptions.estatus != 0 and vehicle_consumptions.vehicle_id=#{params[:vehicle_id]}").order(fecha: :asc)
      #byebug
   end
  end
  
  def generar_excel_acumulado
    #byebug
    if session["fecha_inicio_ac"] != "" and session["fecha_fin_ac"] != ""
      fecha_i = Date.strptime(session["fecha_inicio_ac"])
      fecha_f =  Date.strptime(session["fecha_fin_ac"])
    else
      fecha_i = ""
      fecha_f =  ""
    end
    resultados = VehicleConsumption.consulta_acumulado(session["vehiculo_acumulado"], session["empresa_acumulado"],session["cedis_acumulado"],session["area_acumulado"],fecha_i,fecha_f)
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    #@encabezado = Consumption.find_by(id: params[:consumption_id])
    #resultados = Consumption.joins(:vehicle_consumptions)
    workbook.styles do |s|
      miles_decimal = s.add_style(:format_code => "$###,###.00")
      centered = { alignment: { horizontal: :center } }
      #img = File.expand_path(Rails.root+'app/assets/images/image001.jpg')
      workbook.add_worksheet(name: "Combustible acumulado") do |sheet|
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["","Reporte de control de combustible acumulado"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["No. Económico","CEDIS","Tipo vehículo","Línea","Modelo","Responsable","Área","Fecha carga de ticket","Periodo Factura", "No. Factura","Litros","Importe"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
        resultados.all.each do |resultado|
          sheet.add_row [resultado.vehicle.numero_economico,resultado.vehicle.catalog_branch.decripcion ,resultado.vehicle.vehicle_type.descripcion,resultado.vehicle.catalog_brand.descripcion,resultado.vehicle.catalog_model.descripcion,resultado.vehicle.responsable.nombre,
            resultado.vehicle.catalog_area.descripcion, resultado.fecha,"Del: #{resultado.consumption.fecha_inicio.strftime("%d/%m/%Y")} al: #{resultado.consumption.fecha_fin.strftime("%d/%m/%Y")}",resultado.consumption.n_factura,resultado.cantidad,resultado.monto]
        end
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Reporte acumulado.xlsx"
  end
  #indicador vehículos fuera de presupuesto
  def filtrado_acumulado
    @indicador = Array.new
    @arreglo = []
    @arreglo_ren = []
    @bandera_error = false
    cedis = params[:catalog_branch_id]
    compania = params[:catalog_company_id]
    @resultados = []
      if params[:start_date].nil? or params[:start_date] == ""
        @bandera_error = true
        @mensaje = "Seleccione el año."
      else
        session["fechaini_dvi"] = params[:start_date]
      end
      if params[:catalog_company_id].nil? or params[:catalog_company_id] == ""
        @bandera_error = true
        @mensaje = "Seleccione la empresa."
      else
        session["compania_s"] = params[:catalog_company_id]
      end

      session["area_dvi"] = params[:area_id]
		  session["vehiculo_dvi"] = params[:vehicle_id]

      if !@bandera_error
        anio = (params[:start_date].to_i)
        anio_anterior = (anio - 1).to_s
        @total_grafica = 0
        @buen_grafica = 0
        @percentaje_grafica = 0
        if cedis !="" 
          #CUANDO SE SELECCIONA CEDIS
          @cedis = CatalogBranch.where(id: cedis)
          #byebug
          @cedis.each do |ced|
            #busca los gastos del año anterior y actual y litros del actual 
            if session["area_dvi"] == "" and session["vehiculo_dvi"] == ""
              @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id)
            elsif session["area_dvi"] != "" and session["vehiculo_dvi"] == ""
              @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(catalog_area_id: session["area_dvi"], vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id)
            elsif session["area_dvi"] == "" and session["vehiculo_dvi"] != ""
              @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(vehicle_id: session["vehiculo_dvi"] ,vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id)
            elsif session["area_dvi"] != "" and session["vehiculo_dvi"] != ""
              @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(catalog_area_id: session["area_dvi"], vehicle_id: session["vehiculo_dvi"], vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id)
            end
            
            #byebug
            cumple = 0
            no_cumple = 0
            @query.each do |que|
                #compara el gasto año actual contra el gasto anterior
              if que.presupuesto_actual.to_f >= que.presupuesto_anterior.to_f 
                  #si cumple buscara los litros segun el id del vehiculos
                  combustible = FuelBudget.find_by(vehicle_id: que.vehicle_id)
                  #byebug
                  if combustible
                    #si encuentra registros comparara contra los litro del año actual
                    if que.litros_actual.to_f >= combustible.litros.to_f
                      cumple += 1
                    else
                      no_cumple += 1
                    end
                  end
              #si no cumple
              else
                no_cumple += 1
              end       
            end
            total_vehiculos = cumple + no_cumple
            if cumple == 0 and no_cumple == 0
              percentaje = 0
            else
              percentaje =   cumple.to_f/total_vehiculos.to_f * 100.0
            end
            @resultados.push(cedis: ced.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje)
          end
         #byebug
          #datos para grafica
          @resultados.each do |res|
            @total_grafica += res[:total]
            @buen_grafica += res[:buen]
          end
          @percentaje_grafica = @buen_grafica.to_f/@total_grafica.to_f * 100.0     
       else
          @cedis = CatalogBranch.where(catalog_company_id: compania)
          #byebug
          @cedis.each do |ced|
            #busca los gastos del año anterior y actual y litros del actual 
            if session["area_dvi"] == "" and session["vehiculo_dvi"] == ""
              @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id)
            elsif session["area_dvi"] != "" and session["vehiculo_dvi"] == ""
              @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(catalog_area_id: session["area_dvi"] ,vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id)
            elsif session["area_dvi"] == "" and session["vehiculo_dvi"] != ""
              @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(vehicle_id: session["vehiculo_dvi"] ,vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id)
            elsif session["area_dvi"] != "" and session["vehiculo_dvi"] != ""
              @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(catalog_area_id: session["area_dvi"], vehicle_id: session["vehiculo_dvi"], vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id)
            end
            
            #byebug
            cumple = 0
            no_cumple = 0
            @query.each do |que|
                #compara el gasto año actual contra el gasto anterior
              if que.presupuesto_actual.to_f >= que.presupuesto_anterior.to_f 
                  #si cumple buscara los litros segun el id del vehiculos
                  combustible = FuelBudget.find_by(vehicle_id: que.vehicle_id)
                  #byebug
                  if combustible
                    #si encuentra registros comparara contra los litro del año actual
                    if que.litros_actual.to_f >= combustible.litros.to_f
                      cumple += 1
                    else
                      no_cumple += 1
                    end
                  end
              #si no cumple
              else
                no_cumple += 1
              end       
            end
            total_vehiculos = cumple + no_cumple
            if cumple == 0 and no_cumple == 0
              percentaje = 0
            else
              percentaje =   cumple.to_f/total_vehiculos.to_f * 100.0
            end
            @resultados.push(cedis: ced.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje)
          end
         #byebug
          #datos para grafica
          @resultados.each do |res|
            @total_grafica += res[:total]
            @buen_grafica += res[:buen]
          end
          @percentaje_grafica = @buen_grafica.to_f/@total_grafica.to_f * 100.0    
        end
      end
    end
  #indicador gasto km
  def filtrado_km
    @indicador = Array.new
    @resultados = []
    @bandera_error = false
    cedis = params[:catalog_branch_id]
    compania = params[:catalog_company_id]
      if params[:start_date].nil? or params[:start_date] == ""
        @bandera_error = true
        @mensaje = "Seleccione el año."
      else
        session["fechaini_dvi"] = params[:start_date]
      end
      if params[:catalog_company_id].nil? or params[:catalog_company_id] == ""
        @bandera_error = true
        @mensaje = "Seleccione la empresa."
      else
        session["compania_s"] = params[:catalog_company_id]
      end

    session["area_dvi"] = params[:area_id]
		session["vehiculo_dvi"] = params[:vehicle_id]

    if !@bandera_error
      ano_inicio = params[:start_date]
      @total_grafica = 0
      @buen_grafica = 0
      @percentaje_grafica = 0
      #byebug
  
      if cedis !=""
        #por cedis
        @cedis = CatalogBranch.where(id: cedis)
        #byebug
        @cedis.each do |ced|
          if session["area_dvi"] == "" and session["vehiculo_dvi"] == ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then odometro end) as gasto").where(vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
          elsif session["area_dvi"] != "" and session["vehiculo_dvi"] == ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then odometro end) as gasto").where(catalog_area_id: session["area_dvi"] ,vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
          elsif session["area_dvi"] == "" and session["vehiculo_dvi"] != ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then odometro end) as gasto").where(vehicle_id: session["vehiculo_dvi"] ,vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
          elsif session["area_dvi"] != "" and session["vehiculo_dvi"] != ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then odometro end) as gasto").where(catalog_area_id: session["area_dvi"], vehicle_id: session["vehiculo_dvi"], vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
          end


          #byebug
          cumple = 0
          no_cumple = 0
          @query.each do |que|
            objetivo_gasto = ExpenseVehicleType.find_by(catalog_branch_id: que.cedis,catalog_brand_id:que.linea)
            #byebug
            if objetivo_gasto
              if que.gasto.to_f >= objetivo_gasto.gasto
                cumple += 1
              else
                no_cumple += 1
              end       
            end
          end
          total_vehiculos = cumple + no_cumple
          if cumple == 0 and no_cumple == 0
            percentaje = 0
          else
            percentaje =   cumple.to_f/total_vehiculos.to_f * 100.0
          end
          @resultados.push(cedis: ced.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje)

          @resultados.each do |res|
            @total_grafica += res[:total]
            @buen_grafica += res[:buen]
           end
           @percentaje_grafica = @buen_grafica.to_f/@total_grafica.to_f * 100.0
        end
      else
        @cedis = CatalogBranch.where(catalog_company_id: compania)
        @cedis.each do |ced|
          
          if session["area_dvi"] == "" and session["vehiculo_dvi"] == ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then odometro end) as gasto").where(vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
          elsif session["area_dvi"] != "" and session["vehiculo_dvi"] == ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then odometro end) as gasto").where(catalog_area_id: session["area_dvi"] ,vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
          elsif session["area_dvi"] == "" and session["vehiculo_dvi"] != ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then odometro end) as gasto").where(vehicle_id: session["vehiculo_dvi"] ,vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
          elsif session["area_dvi"] != "" and session["vehiculo_dvi"] != ""
            @query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{ano_inicio}-01-01' and '#{ano_inicio}-12-31' then odometro end) as gasto").where(catalog_area_id: session["area_dvi"], vehicle_id: session["vehiculo_dvi"], vehicles:{catalog_branch_id:ced.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
          end
          cumple = 0
          no_cumple = 0
          @query.each do |que|
            objetivo_gasto = ExpenseVehicleType.find_by(catalog_branch_id: que.cedis,catalog_brand_id:que.linea)
            #byebug
            if objetivo_gasto
              if que.gasto.to_f >= objetivo_gasto.gasto
                cumple += 1
              else
                no_cumple += 1
              end       
            end
          end
          total_vehiculos = cumple + no_cumple
          if cumple == 0 and no_cumple == 0
            percentaje = 0
          else
            percentaje =   cumple.to_f/total_vehiculos.to_f * 100.0
          end
          @resultados.push(cedis: ced.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje)
          @resultados.each do |res|
            @total_grafica += res[:total]
            @buen_grafica += res[:buen]
           end
           @percentaje_grafica = @buen_grafica.to_f/@total_grafica.to_f * 100.0
        end
      end
    end
  end
  # POST /vehicle_consumptions
  # POST /vehicle_consumptions.json
  def create
    @vehicle_consumption = VehicleConsumption.new(vehicle_consumption_params)

    respond_to do |format|
      if @vehicle_consumption.save
        format.html { redirect_to @vehicle_consumption, notice: 'Vehicle consumption was successfully created.' }
        format.json { render :show, status: :created, location: @vehicle_consumption }
      else
        format.html { render :new }
        format.json { render json: @vehicle_consumption.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicle_consumptions/1
  # PATCH/PUT /vehicle_consumptions/1.json
  def update
    respond_to do |format|
      if @vehicle_consumption.update(vehicle_consumption_params)
        format.html { redirect_to generar_reporte_path(@vehicle_consumption.consumption_id), notice: 'Se actualizo el impuesto con exito.' }
        format.json { render :show, status: :ok, location: @vehicle_consumption }
      else
        format.html { render :edit }
        format.json { render json: @vehicle_consumption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_consumptions/1
  # DELETE /vehicle_consumptions/1.json
  def destroy
    @vehicle_consumption.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_consumptions_url, notice: 'Vehicle consumption was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Combustible"
      session["menu2"] = "Consumo por vehículos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_consumption
      @vehicle_consumption = VehicleConsumption.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_consumption_params
      params.require(:vehicle_consumption).permit(:vehicle_id, :tarjeta, :placa, :catalog_brand_id, :catalog_area_id, :estacion, :fecha, :hora, :despacho, :bomba, :producto, :cantidad, :monto, :customer_id, :datos, :responsable_id, :odometro, :rendimiento, :recorrido,:impuestos)
    end
end
