class ConsumptionsController < ApplicationController
  before_action :set_consumption, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource  
  before_action :validacion_menu
  # GET /consumptions
  # GET /consumptions.json
  def index
    @consumptions = Consumption.all
  end

  def indice_solicitud
    @consumptions = Consumption.joins(:catalog_branch).where(estatus: "Autorizado")
  end

  
  def update_request_consumptions

    session["menu1"]="Combustible"
    session["menu2"]="Autorizacion"
        

    @mensaje_error = ""
    bandera_error = false
    estatus ="Autorizado"
    consumption = Consumption.where(semana:params[:semana],catalog_branch_id:params[:catalog_branch_id], catalog_vendor_id: params[:catalog_vendor_id], estatus: "Por autorizar")
    parametro_nombre = Parameter.find_by(nombre:"Url Poliza JDE")

    puts "****************** consumptions: #{consumption}"
    contador = 0
    if parametro_nombre != nil
        consumption.each do |consumption|
          puts "************ consumption: #{consumption}"
          if consumption.catalog_vendor_id != nil
            if !consumption.fecha_factura.nil? and !consumption.fecha_aplicacion.nil?
                if params[:estatus].to_i == 2  
                  puts "******************* Current_user: #{@current_user}"
                  estatus_json =  consumption.enviar_json(@current_user)
                  puts "************** estatus_json: #{estatus_json}"
                    if estatus_json[1]
                     #if params[:estatus].to_i == 2
                        if consumption.update(estatus: estatus) 
                            @mensaje = "Solicitud Autorizada"
                            @mostrar_json = estatus_json[0]
                            begin
                                contador += 1
                                RolesMailer.autorizacion_combustible(consumption.id).deliver_later(wait: (20 * contador).seconds)
                            rescue StandardError => exception
                                puts exception
                            end
                        else 
                            consumption.errors.full_messages.each do |error|
                                puts "#{error}"
                            end
                            @mensaje_error += "No se pudo autorizar la solicitud, intente nuevamente"
                        end 
                    
                    else
                        @mostrar_json = estatus_json[0]
                        if @mostrar_json[0]["Mensaje"] == nil
                            bandera_error = true
                            @mensaje_error +=" #{@mostrar_json[0]}. Folio: #{consumption.folio}<br><br> "
                        else
                            bandera_error = true
                            @mensaje_error += "Error en JD Edwards: #{@mostrar_json[0]["Mensaje"]}. Folio: #{consumption.folio}  <br><br>"
                            @mensaje=@mensaje_error
                            puts  "estatus_json Error: #{@mensaje_error}"
                        end
                    end 
                elsif  params[:estatus].to_i == 3
                    estatus =  "Rechazado"
                    if consumption.update(estatus: estatus)
                        @mensaje = "Solicitud Rechazada"
                    else
                        bandera_error = true
                        @mensaje_error +="No se pudo rechazar la solicitud, intente nuevamente. Folio:#{consumption.folio} <br><br>"
                    end
                else
                    bandera_error = true
                    @mensaje_error +='Estatus incorrecto'
                end
            else
                bandera_error = true
                @mensaje_error +="Se necesita capturar la fecha factura y la fecha aplicación. Folio:#{consumption.folio} <br><br>"
            end
        else
            bandera_error = true
            @mensaje_error +="Se necesita capturar un proveedor.  Folio:#{consumption.folio} <br><br>"
        end
      end
        #if bandera_error 
        #    @mensaje_error
        #else
        #    @mensaje_error
        #end
    else
        @mensaje="No se encontro la ruta para JDE, por favor verifique sus paramentros"
    end
    puts "Redireccionando *******************************************#{@mensaje} - #{@mensaje_error}"
    
    respond_to do |format|
      if(bandera_error)
        format.html { redirect_to show_vehicle_consumptions_path, alert: @mensaje_error }
      else 
        format.html { redirect_to show_vehicle_consumptions_path, notice: @mensaje }
      end
    end
 
  end



  def show_vehicle_consumptions
    session["menu1"]="Combustible"
    session["menu2"]="Autorizacion"
    puts "********************************************"
    puts "current_user:",current_user
    puts "current_user:",@current_user

    #@encabezado = Consumption.select("catalog_vendor_id, catalog_branch_id, semana, estatus, fecha_inicio, fecha_fin").where("estatus = ?", [1]).where(usuario_autorizante_id:current_user.id).group("catalog_vendor_id, catalog_branch_id,semana, estatus, fecha_inicio, fecha_fin")
    
    
    #@folios = Consumption.select("folio, catalog_vendor_id, catalog_branch_id, semana, estatus, fecha_inicio, fecha_fin").where("estatus = ?", [1]).where(usuario_autorizante_id:current_user.id)
    
    encabezado = Consumption.select("catalog_vendor_id, catalog_branch_id, semana, estatus, fecha_inicio, fecha_fin").where("estatus = ?", [1]).group("catalog_vendor_id, catalog_branch_id,semana, estatus, fecha_inicio, fecha_fin")


    folios = Consumption.select("folio, catalog_vendor_id, catalog_branch_id, semana, estatus, fecha_inicio, fecha_fin").where("estatus = ?", [1])

    @encabezado=[]
    @folios=[]
    encabezado.each do |e|
      hash_encabezado = Hash.new
      hash_encabezado["id"]=e.id
      foliosTodos=''
      folios.each do |f|
        if f.catalog_vendor_id == e.catalog_vendor_id && f.catalog_branch_id == e.catalog_branch_id && f.semana == e.semana && f.estatus == e.estatus && e.fecha_inicio == f.fecha_inicio && e.fecha_fin == f.fecha_fin
            foliosTodos = foliosTodos + f.folio.to_s + " " 
        end
      end
      hash_encabezado["folios"]=foliosTodos
      hash_encabezado["fecha_inicio"]=e.fecha_inicio
      hash_encabezado["fecha_fin"]=e.fecha_fin
      hash_encabezado["cargas"]=Consumption.cargas_semana(e)
      hash_encabezado["cedis"]=e.catalog_branch.decripcion
      hash_encabezado["semana"]=e.semana

      hash_encabezado["monto"]=Consumption.monto_semana(e)
      if  e.estatus == "Por autorizar"
        hash_encabezado["estatus_numero"]=1
      elsif  e.estatus == "Autorizado"   
        hash_encabezado["estatus_numero"]=2
      elsif e.estatus ==  "Rechazado"
        hash_encabezado["estatus_numero"]=3
      end 
      hash_encabezado["estatus"]=e.estatus
      hash_encabezado["catalog_branch_id"]=e.catalog_branch_id
      hash_encabezado["catalog_vendor_id"]=e.catalog_vendor_id
      hash_encabezado["vendor"]=e.catalog_vendor.razonsocial

      @encabezado << hash_encabezado
    end

     

    


  end
  
#let data = {
#  id: this.encabezado.id,
#  catalog_vendor_id: this.encabezado.catalog_vendor_id,
#  catalog_branch_id: this.encabezado.catalog_branch_id,
#  semana: this.encabezado.semana,
#  estatus: estatus
#}

def solicitud_pago
    session["menu1"]="Combustible"
    session["menu2"]="Autorizacion"
        
    @ventas = []
    @admin = []
    @almacen = []
    #byebug
    @encabezado = Consumption.where(semana:params[:semana],catalog_branch_id:params[:catalog_branch_id], catalog_vendor_id:params[:catalog_vendor_id], estatus: "Por autorizar" )# agrupar por semana y en estatus autorizar      #agruparlo por catalog_vendor, catalog_branch y semana
    @encabezado.each do |encabezado|
       venta = Consumption.litros_consumoDetalle(encabezado.fecha_inicio, encabezado.fecha_fin, encabezado.catalog_branch_id, encabezado.catalog_vendor_id) 
       if venta[0] != nil
        @ventas.push(venta)
        end
       # @ventas =  Consumption.litros_consumo(encabezado.id)
        admin = Consumption.litros_adminDetalle(encabezado.fecha_inicio, encabezado.fecha_fin, encabezado.catalog_branch_id, encabezado.catalog_vendor_id)
        if admin[0] != nil
            @admin.push(admin)
        end
        almacen = Consumption.litros_almacenDetalle(encabezado.fecha_inicio, encabezado.fecha_fin, encabezado.catalog_branch_id, encabezado.catalog_vendor_id) 
        if almacen[0] != nil
            @almacen.push(almacen)
        end
    end

end


  def busqueda_solicitud
    @fecha_inicio = params[:start_date] 
    @fecha_fin = params[:end_date]
    @cedis = params[:cedis]
    session["fecha_inicio"] = params[:start_date]
    session["fecha_fin"] = params[:end_date]
    session["cedis"] = params[:cedis]
    @consumptions = Consumption.busqueda_solicitud(session["fecha_inicio"],session["fecha_fin"],session["cedis"])
    #busqueda_solicitud(session["fecha_inicio"],session["fecha_fin"],session["cedis"])
    #byebug
  end

  def ver_solicitud
    @encabezado = Consumption.find_by(id: params[:consumption_id])
    @ventas =  Consumption.litros_consumo(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id, @encabezado)
    @admin = Consumption.litros_admin(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
    @almacen = Consumption.litros_almacen(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
    @monto = VehicleConsumption.joins(:consumption).where(consumptions: {catalog_branch_id:@encabezado.catalog_branch_id,catalog_vendor_id:@encabezado.catalog_vendor_id},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin).sum(:monto)
    @competencia = CompetitionTable.where("catalog_branch_id = #{@encabezado.catalog_branch_id} and monto >= #{@monto} and tipo = 'Combustible'").order(monto: :asc)
    @monto_competencia = @competencia.first
  end

  # GET /consumptions/1
  # GET /consumptions/1.json
  def show
  end

  def imprimir_solicitud
    @encabezado = Consumption.find_by(id: params[:consumption_id])
    if params[:iva] == "8"
      valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
      @ventas =  Consumption.litros_consumo8(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id, @encabezado)
      @admin = Consumption.litros_admin8(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
      @almacen = Consumption.litros_almacen8(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
      @monto = VehicleConsumption.joins(:consumption).where(consumptions: {catalog_branch_id:@encabezado.catalog_branch_id,catalog_vendor_id:@encabezado.catalog_vendor_id, valuation_id: valuation.id},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin).sum(:monto)
      @competencia = CompetitionTable.where("catalog_branch_id = #{@encabezado.catalog_branch_id} and monto >= #{@monto} and tipo = 'Combustible'").order(monto: :asc)
    else
      valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
      @ventas =  Consumption.litros_consumo16(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id, @encabezado)
      @admin = Consumption.litros_admin16(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
      @almacen = Consumption.litros_almacen16(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
      @monto = VehicleConsumption.joins(:consumption).where(consumptions: {catalog_branch_id:@encabezado.catalog_branch_id,catalog_vendor_id:@encabezado.catalog_vendor_id, valuation_id: valuation.id},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin).sum(:monto)
      @competencia = CompetitionTable.where("catalog_branch_id = #{@encabezado.catalog_branch_id} and monto >= #{@monto} and tipo = 'Combustible'").order(monto: :asc)
    end
    @monto_competencia = @competencia.first
		respond_to do |format|
			format.html
			format.pdf do
			render pdf: "imprimir",
			template: "consumptions/solicitud_pago.html.erb",
			layout: 'solicitud_pago.html',
			orientation: 'Portrait'
			end
		end
  end

  def ver_encabezado 
    @encabezado = Consumption.find_by(id: params[:consumption_id])
  end

  def imprimir_encabezado_excel
    encabezado = Consumption.find_by(id: params[:consumption_id])
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.styles do |s|
      miles_decimal = s.add_style(:format_code => "$###,###.00",:sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true})
      miles = s.add_style(:format_code => "###,###.00",:sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true})
      centered = { alignment: { horizontal: :center } }
      img = File.expand_path("#{Rails.root}/app/assets/images/excel_logo.png", __FILE__)
			col_widths= [3,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30] 
			celda_tabla = s.add_style :bg_color => "BFBFBF", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center, :vertical => :center,:wrap_text => true }
      celda_cabecera2= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right}, :alignment => { :horizontal => :center, :vertical => :center,:wrap_text => true }
			celda_categoria = s.add_style :bg_color => "D9D9D9", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_notas = s.add_style :fg_color => "FF0000" ,:sz => 12
			celda_afi_mayor = s.add_style :bg_color => "808080", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_afi_menor = s.add_style :bg_color => "F2F2F2", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
      workbook.add_worksheet(name: "Detalle de consumo") do |sheet|
        sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 132
					image.start_at 1, 0
				end
        sheet.merge_cells("B1:D7")
				sheet.add_row ["","Detalle de consumo de combustible\n#{encabezado.catalog_branch.decripcion} Folio #{encabezado.folio}","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row [""]
        sheet.add_row ["","#{encabezado.catalog_branch.decripcion} Folio #{encabezado.folio}","","","","","",""], :style => [nil, celda_cabecera2, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "noEconomico", "Tarjeta", "Placas", "Descripción", "Grupo", "Estación", "Fecha", "Hora", "Despacho", "Bomba", "Producto", "Cantidad", "Monto", "Cliente", "Datos", "Responsable", "Odometro", "Rendimiento", "Recorrido"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        encabezado.vehicle_consumptions.each do |enc|
          enc.vehicle.responsable ? respon = enc.vehicle.responsable.nombre : respon = "No se asignó"
          sheet.add_row ["", enc.vehicle.numero_economico, enc.tarjeta, enc.placa, enc.vehicle.catalog_brand.descripcion, enc.vehicle.catalog_area.descripcion, enc.estacion, enc.fecha.strftime("%d/%m/%Y"), enc.hora, enc.despacho, enc.bomba, enc.producto, enc.cantidad, enc.monto, enc.cliente, enc.datos, respon, enc.odometro, enc.rendimiento, enc.recorrido], :style => [nil,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,celda_tabla_td,miles,miles_decimal,celda_tabla_td,celda_tabla_td,celda_tabla_td,miles,miles,miles]
        end
        sheet.column_widths *col_widths
      end
      send_data package.to_stream.read, type: "application/xlsx", filename: "Consumo #{encabezado.catalog_branch.decripcion} Folio #{encabezado.folio}.xlsx"
    end
  end
  
  
  def generar_reporte
    #trae id del encabezado
    @encabezado = Consumption.find_by(id: params[:consumption_id])
    #busca los registros con monto nulos si encuentra no dejara enviar solicitud
    @registros = VehicleConsumption.joins(:consumption).where(consumptions: {catalog_branch_id:@encabezado.catalog_branch_id,catalog_vendor_id:@encabezado.catalog_vendor_id,estatus:0},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin,impuestos:nil)
    
    #reporte
    # @ventas =  Consumption.litros_consumo(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id, @encabezado)
    # @admin = Consumption.litros_admin(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
    # @almacen = Consumption.litros_almacen(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)

    @ventas =  Consumption.litros_consumo8(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id, @encabezado)
    @admin = Consumption.litros_admin8(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
    @almacen = Consumption.litros_almacen8(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)

    @ventas2 =  Consumption.litros_consumo16(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id, @encabezado)
    @admin2 = Consumption.litros_admin16(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
    @almacen2 = Consumption.litros_almacen16(@encabezado.fecha_inicio,@encabezado.fecha_fin,@encabezado.catalog_branch_id,@encabezado.catalog_vendor_id)
    #byebug
    #suma todos los montos
    valuation1 = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
    valuation2 = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
     @monto = VehicleConsumption.joins(:consumption).where(consumptions: {catalog_branch_id:@encabezado.catalog_branch_id,catalog_vendor_id:@encabezado.catalog_vendor_id, valuation_id: valuation1.id},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin).sum(:monto)
     @monto2 = VehicleConsumption.joins(:consumption).where(consumptions: {catalog_branch_id:@encabezado.catalog_branch_id,catalog_vendor_id:@encabezado.catalog_vendor_id, valuation_id: valuation2.id},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin).sum(:monto)
    #@monto = VehicleConsumption.joins(:consumption).where(catalog_branch_id: @encabezado.catalog_branch_id, consumptions: {catalog_branch_id: @encabezado.catalog_branch_id, catalog_vendor_id:@encabezado.catalog_vendor_id, valuation_id: valuation1.id},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin).sum(:monto)
    #@monto2 = VehicleConsumption.joins(:consumption).where(catalog_branch_id: @encabezado.catalog_branch_id, consumptions: {catalog_branch_id: @encabezado.catalog_branch_id, catalog_vendor_id:@encabezado.catalog_vendor_id, valuation_id: valuation2.id},fecha:@encabezado.fecha_inicio..@encabezado.fecha_fin).sum(:monto)
    @competencia = CompetitionTable.where("catalog_branch_id = #{@encabezado.catalog_branch_id} and monto >= #{@monto} and tipo = 'Combustible'").order(monto: :asc)
    @competencia2 = CompetitionTable.where("catalog_branch_id = #{@encabezado.catalog_branch_id} and monto >= #{@monto2} and tipo = 'Combustible'").order(monto: :asc)
    @monto_competencia = @competencia.first
    @monto_competencia2 = @competencia2.first
  end

  def borrar_carga
    @consumption = Consumption.find_by(id: params[:id])
    @limpiar_detalle = VehicleConsumption.where(consumption_id: @consumption.id).destroy_all
    @limpiar_encabezado = @consumption.destroy
    if @limpiar_detalle and @limpiar_encabezado
      flash[:notice] = "Registro eliminado con éxito."
      redirect_to vehicle_consumptions_path
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to vehicle_consumptions_path
    end
  end

  # GET /consumptions/new
  def new
    @consumption = Consumption.new
  end

  # GET /consumptions/1/edit
  def edit
  end

  def documentos_factura
    @documentos = Consumption.where(id: params[:id_consumo])
    @documento = Consumption.new
    @consumo_id = params[:id_consumo]
    respond_to do |format|
      format.js
    end
  end

  def descargar_factura
    @documentos = Consumption.where(id: params[:id_consumo])
    @consumo_id = params[:id_consumo]
    respond_to do |format|
      format.js
    end
  end

  def documentos_pdf
    @documentos = Consumption.where(id: params[:id_consumo])
    @documento = Consumption.new
    @consumo_id = params[:id_consumo]
    respond_to do |format|
      format.js
    end
  end

  def descargar_pdf
    @documentos = Consumption.where(id: params[:id_consumo])
    @consumo_id = params[:id_consumo]
    respond_to do |format|
      format.js
    end
  end

  def cargar_factura
    id_partida = params[:consumption][:id]
    @documento = Consumption.crear_documento(params, id_partida)
    #byebug
    @resultados = @documento
    @documentos = Consumption.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to vehicle_consumptions_path
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end

  def cargar_pdf
    id_partida = params[:consumption][:id]
    @documento = Consumption.crear_pdf(params, id_partida)
    #byebug
    @resultados = @documento
    @documentos = Consumption.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to vehicle_consumptions_path
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end

  def cancelar_encabezado
    @consumption = Consumption.find_by(folio: params[:folio])
    if @consumption
      @consumption.update(estatus: "Rechazado")
      flash[:notice] = "Registro rechazado."
      redirect_to vehicle_consumptions_path
    else
      flash[:alert] = "No se encontró el registro seleccionado."
      redirect_to vehicle_consumptions_path
    end
  end

  def solicitar_autorizacion
    #busca el id del comsumo
    # @consumption = Consumption.find_by(folio: params[:folio])
    # busqueda = Consumption.where(fecha_inicio:@consumption.fecha_inicio,fecha_fin: @consumption.fecha_fin,catalog_branch_id:@consumption.catalog_branch_id,catalog_vendor_id:@consumption.catalog_vendor_id)
    # sumatoria = VehicleConsumption.where(consumption_id:@consumption.id).sum(:impuestos)
    # @competencia = CompetitionTable.where("catalog_branch_id = #{@consumption.catalog_branch_id} and monto >= #{@consumption.monto} and tipo = 'Combustible'").order(monto: :asc)
    # @monto_competencia = @competencia.first
    # fecha = params[:fecha_aplicacion]
    # if fecha == ""
    #   fecha = Time.now.strftime("%d/%m/%Y")
    # end
    # if @monto_competencia
    #   user = User.joins(:catalog_roles).joins(:catalog_branches_users).find_by("catalog_roles.id = '#{@monto_competencia.catalog_role_id}' and catalog_branches_users.catalog_branch_id = #{@consumption.catalog_branch_id}")   
    # end

    # if  @consumption.impuestos.to_f == sumatoria.to_f or !@consumption.es_detallado
    #   if @monto_competencia.nil?
    #     flash[:alert] = "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{@consumption.catalog_branch.decripcion}, favor de revisar información."
    #     redirect_to vehicle_consumptions_path
    #   elsif !user
    #     flash[:alert] = "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{@consumption.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario."
    #     redirect_to vehicle_consumptions_path
    #   else
    #     busqueda.update(estatus: "Por autorizar",fecha_aplicacion: fecha,usuario_autorizante_id:user.id)
    #     VehicleConsumptionsMailer.solicitud_pago(user,@consumption.id).deliver_later
    #     flash[:notice] = "Solicitud enviada con éxito, se envió un correo al autorizante."
    #     redirect_to vehicle_consumptions_path
    #   end
    # else
    #   diferencia = (@consumption.impuestos.to_f - sumatoria.to_f).round(2)
    #   flash[:alert] = "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}"
    #   redirect_to vehicle_consumptions_path 
    # end
    arreglo_errores = Array.new
    #valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
    @consumption = Consumption.find_by(folio: params[:folio])
    busqueda = Consumption.where(fecha_inicio:@consumption.fecha_inicio,fecha_fin: @consumption.fecha_fin,catalog_branch_id:@consumption.catalog_branch_id,catalog_vendor_id:@consumption.catalog_vendor_id, estatus: 0)
    busqueda.each do |busq|
      sumatoria = VehicleConsumption.where(consumption_id:busq.id).sum(:impuestos)
      @competencia = CompetitionTable.where("catalog_branch_id = #{busq.catalog_branch_id} and monto >= #{busq.monto} and tipo = 'Combustible'").order(monto: :asc)
      @monto_competencia = @competencia.first
      fecha = params[:fecha_aplicacion]
      if fecha == ""
        fecha = Time.now.strftime("%d/%m/%Y")
      end
      if @monto_competencia
        user = User.joins(:catalog_roles).joins(:catalog_branches_users).find_by("catalog_roles.id = '#{@monto_competencia.catalog_role_id}' and catalog_branches_users.catalog_branch_id = #{busq.catalog_branch_id}")   
      end
  
      if  busq.impuestos.to_f == sumatoria.to_f or !busq.es_detallado
        if @monto_competencia.nil?
          arreglo_errores.push(folio: busq.folio, error: "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{busq.catalog_branch.decripcion}, favor de revisar información.")
          #flash[:alert] = "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{busq.catalog_branch.decripcion}, favor de revisar información."
          #redirect_to vehicle_consumptions_path
        elsif !user
          arreglo_errores.push(folio: busq.folio, error: "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{busq.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario.")
          #flash[:alert] = "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{busq.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario."
          #redirect_to vehicle_consumptions_path
        else
          busq.update(estatus: "Por autorizar",fecha_aplicacion: fecha,usuario_autorizante_id:user.id)
          #VehicleConsumptionsMailer.solicitud_pago(user,busq.id).deliver_later
          # flash[:notice] = "Solicitud enviada con éxito, se envió un correo al autorizante."
          # redirect_to vehicle_consumptions_path
        end
      else
        diferencia = (busq.impuestos.to_f - sumatoria.to_f).round(2)
        arreglo_errores.push(folio: busq.folio, error: "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}")
        flash[:alert] = "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}"
        #redirect_to vehicle_consumptions_path 
      end
    end
    
    if arreglo_errores.length > 0
      require 'axlsx'
      package = Axlsx::Package.new
      workbook = package.workbook
      workbook.styles do |s|
        celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
        celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
        workbook.add_worksheet(name: "Errores") do |sheet|
          sheet.add_row ["", "Folio consumo", "Error"], :style => [nil,celda_cabecera,celda_cabecera]
          arreglo_errores.each do |vc|
            sheet.add_row ["", vc[:folio], vc[:error]], :style => [nil,celda_tabla_td,celda_tabla_td]
          end
        end
      end
      send_data package.to_stream.read, type: "application/xlsx", filename: "Errores autorización consumo.xlsx"
    else
      flash[:notice] = "Solicitudes enviadas con éxito, se envió un correo al autorizante."
      redirect_to vehicle_consumptions_path
    end
  end

  def solicitar_autorizacion8
    #busca el id del comsumo
    # valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
    # @consumption = Consumption.find_by(folio: params[:folio])
    # busqueda = Consumption.where(fecha_inicio:@consumption.fecha_inicio,fecha_fin: @consumption.fecha_fin,catalog_branch_id:@consumption.catalog_branch_id,catalog_vendor_id:@consumption.catalog_vendor_id)
    # sumatoria = VehicleConsumption.where(consumption_id:@consumption.id).sum(:impuestos)
    # @competencia = CompetitionTable.where("catalog_branch_id = #{@consumption.catalog_branch_id} and monto >= #{@consumption.monto} and tipo = 'Combustible'").order(monto: :asc)
    # @monto_competencia = @competencia.first
    # fecha = params[:fecha_aplicacion]
    # if fecha == ""
    #   fecha = Time.now.strftime("%d/%m/%Y")
    # end
    # if @monto_competencia
    #   user = User.joins(:catalog_roles).joins(:catalog_branches_users).find_by("catalog_roles.id = '#{@monto_competencia.catalog_role_id}' and catalog_branches_users.catalog_branch_id = #{@consumption.catalog_branch_id}")   
    # end

    # if  @consumption.impuestos.to_f == sumatoria.to_f or !@consumption.es_detallado
    #   if @monto_competencia.nil?
    #     flash[:alert] = "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{@consumption.catalog_branch.decripcion}, favor de revisar información."
    #     redirect_to vehicle_consumptions_path
    #   elsif !user
    #     flash[:alert] = "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{@consumption.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario."
    #     redirect_to vehicle_consumptions_path
    #   else
    #     busqueda.update(estatus: "Por autorizar",fecha_aplicacion: fecha,usuario_autorizante_id:user.id)
    #     VehicleConsumptionsMailer.solicitud_pago(user,@consumption.id).deliver_later
    #     flash[:notice] = "Solicitud enviada con éxito, se envió un correo al autorizante."
    #     redirect_to vehicle_consumptions_path
    #   end
    # else
    #   diferencia = (@consumption.impuestos.to_f - sumatoria.to_f).round(2)
    #   flash[:alert] = "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}"
    #   redirect_to vehicle_consumptions_path 
    # end
    arreglo_errores = Array.new
    valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
    @consumption = Consumption.find_by(folio: params[:folio])
    busqueda = Consumption.where(fecha_inicio:@consumption.fecha_inicio,fecha_fin: @consumption.fecha_fin,catalog_branch_id:@consumption.catalog_branch_id,catalog_vendor_id:@consumption.catalog_vendor_id, valuation_id: valuation.id, estatus: 0)
    busqueda.each do |busq|
      sumatoria = VehicleConsumption.where(consumption_id:busq.id).sum(:impuestos)
      @competencia = CompetitionTable.where("catalog_branch_id = #{busq.catalog_branch_id} and monto >= #{busq.monto} and tipo = 'Combustible'").order(monto: :asc)
      @monto_competencia = @competencia.first
      fecha = params[:fecha_aplicacion]
      if fecha == ""
        fecha = Time.now.strftime("%d/%m/%Y")
      end
      if @monto_competencia
        user = User.joins(:catalog_roles).joins(:catalog_branches_users).find_by("catalog_roles.id = '#{@monto_competencia.catalog_role_id}' and catalog_branches_users.catalog_branch_id = #{busq.catalog_branch_id}")   
      end
  
      if  busq.impuestos.to_f == sumatoria.to_f or !busq.es_detallado
        if @monto_competencia.nil?
          arreglo_errores.push(folio: busq.folio, error: "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{busq.catalog_branch.decripcion}, favor de revisar información.")
          #flash[:alert] = "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{busq.catalog_branch.decripcion}, favor de revisar información."
          #redirect_to vehicle_consumptions_path
        elsif !user
          arreglo_errores.push(folio: busq.folio, error: "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{busq.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario.")
          #flash[:alert] = "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{busq.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario."
          #redirect_to vehicle_consumptions_path
        else
          busq.update(estatus: "Por autorizar",fecha_aplicacion: fecha,usuario_autorizante_id:user.id)
          #VehicleConsumptionsMailer.solicitud_pago(user,busq.id).deliver_later
          # flash[:notice] = "Solicitud enviada con éxito, se envió un correo al autorizante."
          # redirect_to vehicle_consumptions_path
        end
      else
        diferencia = (busq.impuestos.to_f - sumatoria.to_f).round(2)
        arreglo_errores.push(folio: busq.folio, error: "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}")
        #diferencia = (busq.impuestos.to_f - sumatoria.to_f).round(2)
        flash[:alert] = "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}"
        #redirect_to vehicle_consumptions_path 
      end
    end
    
    if arreglo_errores.length > 0
      require 'axlsx'
      package = Axlsx::Package.new
      workbook = package.workbook
      workbook.styles do |s|
        celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
        celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
        workbook.add_worksheet(name: "Errores") do |sheet|
          sheet.add_row ["", "Folio consumo", "Error"], :style => [nil,celda_cabecera,celda_cabecera]
          arreglo_errores.each do |vc|
            sheet.add_row ["", vc[:folio], vc[:error]], :style => [nil,celda_tabla_td,celda_tabla_td]
          end
        end
      end
      send_data package.to_stream.read, type: "application/xlsx", filename: "Errores autorización consumo.xlsx"
    else
      flash[:notice] = "Solicitudes enviadas con éxito, se envió un correo al autorizante."
      redirect_to vehicle_consumptions_path
    end
  end

  def solicitar_autorizacion16
    #busca el id del comsumo
    arreglo_errores = Array.new
    valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
    @consumption = Consumption.find_by(folio: params[:folio])
    busqueda = Consumption.where(fecha_inicio:@consumption.fecha_inicio,fecha_fin: @consumption.fecha_fin,catalog_branch_id:@consumption.catalog_branch_id,catalog_vendor_id:@consumption.catalog_vendor_id, valuation_id: valuation.id, estatus: 0)
    busqueda.each do |busq|
      sumatoria = VehicleConsumption.where(consumption_id:busq.id).sum(:impuestos)
      @competencia = CompetitionTable.where("catalog_branch_id = #{busq.catalog_branch_id} and monto >= #{busq.monto} and tipo = 'Combustible'").order(monto: :asc)
      @monto_competencia = @competencia.first
      fecha = params[:fecha_aplicacion]
      if fecha == ""
        fecha = Time.now.strftime("%d/%m/%Y")
      end
      if @monto_competencia
        user = User.joins(:catalog_roles).joins(:catalog_branches_users).find_by("catalog_roles.id = '#{@monto_competencia.catalog_role_id}' and catalog_branches_users.catalog_branch_id = #{busq.catalog_branch_id}")   
      end
  
      if  busq.impuestos.to_f == sumatoria.to_f or !busq.es_detallado
        if @monto_competencia.nil?
          arreglo_errores.push(folio: busq.folio, error: "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{busq.catalog_branch.decripcion}, favor de revisar información.")
          #flash[:alert] = "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{busq.catalog_branch.decripcion}, favor de revisar información."
          #redirect_to vehicle_consumptions_path
        elsif !user
          arreglo_errores.push(folio: busq.folio, error: "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{busq.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario.")
          #flash[:alert] = "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{busq.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario."
          #redirect_to vehicle_consumptions_path
        else
          busq.update(estatus: "Por autorizar",fecha_aplicacion: fecha,usuario_autorizante_id:user.id)
          #VehicleConsumptionsMailer.solicitud_pago(user,busq.id).deliver_later
          # flash[:notice] = "Solicitud enviada con éxito, se envió un correo al autorizante."
          # redirect_to vehicle_consumptions_path
        end
      else
        diferencia = (busq.impuestos.to_f - sumatoria.to_f).round(2)
        arreglo_errores.push(folio: busq.folio, error: "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}")
        flash[:alert] = "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}"
        #redirect_to vehicle_consumptions_path 
      end
    end
    
    if arreglo_errores.length > 0
      require 'axlsx'
      package = Axlsx::Package.new
      workbook = package.workbook
      workbook.styles do |s|
        celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
        celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
        workbook.add_worksheet(name: "Errores") do |sheet|
          sheet.add_row ["", "Folio consumo", "Error"], :style => [nil,celda_cabecera,celda_cabecera]
          arreglo_errores.each do |vc|
            sheet.add_row ["", vc[:folio], vc[:error]], :style => [nil,celda_tabla_td,celda_tabla_td]
          end
        end
      end
      send_data package.to_stream.read, type: "application/xlsx", filename: "Errores autorización consumo.xlsx"
    else
      flash[:notice] = "Solicitudes enviadas con éxito, se envió un correo al autorizante."
      redirect_to vehicle_consumptions_path
    end
    
    # sumatoria = VehicleConsumption.where(consumption_id:@consumption.id).sum(:impuestos)
    # @competencia = CompetitionTable.where("catalog_branch_id = #{@consumption.catalog_branch_id} and monto >= #{@consumption.monto} and tipo = 'Combustible'").order(monto: :asc)
    # @monto_competencia = @competencia.first
    # fecha = params[:fecha_aplicacion]
    # if fecha == ""
    #   fecha = Time.now.strftime("%d/%m/%Y")
    # end
    # if @monto_competencia
    #   user = User.joins(:catalog_roles).joins(:catalog_branches_users).find_by("catalog_roles.id = '#{@monto_competencia.catalog_role_id}' and catalog_branches_users.catalog_branch_id = #{@consumption.catalog_branch_id}")   
    # end

    # if  @consumption.impuestos.to_f == sumatoria.to_f or !@consumption.es_detallado
    #   if @monto_competencia.nil?
    #     flash[:alert] = "No se encontraron datos en la tabla de competencias para el concepto: Combustible y cedis: #{@consumption.catalog_branch.decripcion}, favor de revisar información."
    #     redirect_to vehicle_consumptions_path
    #   elsif !user
    #     flash[:alert] = "No se encontró el autorizante con el rol: #{@monto_competencia.catalog_role.nombre} y cedis: #{@consumption.catalog_branch.decripcion},favor de revisar los roles y cedis de usuario."
    #     redirect_to vehicle_consumptions_path
    #   else
    #     busqueda.update(estatus: "Por autorizar",fecha_aplicacion: fecha,usuario_autorizante_id:user.id)
    #     VehicleConsumptionsMailer.solicitud_pago(user,@consumption.id).deliver_later
    #     flash[:notice] = "Solicitud enviada con éxito, se envió un correo al autorizante."
    #     redirect_to vehicle_consumptions_path
    #   end
    # else
    #   diferencia = (@consumption.impuestos.to_f - sumatoria.to_f).round(2)
    #   flash[:alert] = "Los impuestos no coinciden con el impuesto de la factura, favor de revisar información. Diferencia: #{diferencia}"
    #   redirect_to vehicle_consumptions_path 
    # end
  end
  
  def modal_cambio_usuario
		@consumption = Consumption.find_by(id: params[:id])
		if @consumption
			@metodo = "PATCH"
			@url = "editar_usuario_aut_path(#{@consumption.id})"
		end
	end

  def editar_usuario_aut
		bandera_error = false
		@consumption = Consumption.find_by(id: params[:id])
		begin
			#byebug
			if @consumption
				if @consumption.update(consumption_params)
					flash[:notice] = "Usuario autorizante actualizado con éxito"
					redirect_to vehicle_consumptions_path
				else
					bandera_error = true
					@mensaje = "Ocurrió uno o más errores actualizando: "
					@consumption.errors.full_messages.each do |error|
						@mensaje += "#{error}. "
					end
				end
			else
				bandera_error = true
				@mensaje = "No se encontró la carga seleccionada."
			end
		rescue => exception
			bandera_error = true
			@mensaje = "Error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
  end 

  def modal_cambio_factura
		@consumption = Consumption.find_by(id: params[:id])
		if @consumption
			@metodo = "PATCH"
			@url = "editar_factura_path(#{@consumption.id})"
		end
	end

  def editar_factura
		bandera_error = false
		@consumption = Consumption.find_by(id: params[:id])
		begin
			#byebug
			if @consumption
				if @consumption.update(consumption_params)
					flash[:notice] = "Folio actualizado con éxito"
					redirect_to vehicle_consumptions_path
				else
					bandera_error = true
					@mensaje = "Ocurrió uno o más errores actualizando: "
					@consumption.errors.full_messages.each do |error|
						@mensaje += "#{error}. "
					end
				end
			else
				bandera_error = true
				@mensaje = "No se encontró la carga seleccionada."
			end
		rescue => exception
			bandera_error = true
			@mensaje = "Error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
  end 


  def consumo_excel
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    #@encabezado = Consumption.find_by(id: params[:consumption_id])
    #resultados = Consumption.joins(:vehicle_consumptions)
    resultados = Consumption.find_by(id: params[:consumption_id])
    workbook.styles do |s|
      miles_decimal = s.add_style(:format_code => "$###,###.00")
      centered = { alignment: { horizontal: :center } }
      #img = File.expand_path(Rails.root+'app/assets/images/image001.jpg')
      workbook.add_worksheet(name: "Reporte consumo combustible") do |sheet|
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["","Consumo combustible"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
        sheet.add_row [""]
        sheet.add_row [""]
        #sheet.merge_cells("B3:C3")
        #sheet.merge_cells("C1:C2")
        #sheet.merge_cells("C2:C3")
        #sheet.merge_cells("C3:C4")
        sheet.add_row ["Fecha de carga del ticket","Periodo factura", "No. cheque","No. factura","No. económico","Área","Color", "Tipo","Modelo","Responsable","Lts cargados","Importe total","Base $","Km solo almacén","Rendimiento"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
        resultados.vehicle_consumptions.each do |resultado|
          sheet.add_row [resultado.fecha ? resultado.fecha.strftime("%d/%m/%Y") : "N/A","DEL: #{resultado.consumption.fecha_inicio.strftime("%d/%m/%Y")} AL: #{resultado.consumption.fecha_fin.strftime("%d/%m/%Y")}",
          "",resultado.consumption.n_factura ? resultado.consumption.n_factura : "No se asignó factura",resultado.vehicle ? resultado.vehicle.numero_economico : "No se asignó",
          resultado.vehicle.catalog_area ? resultado.vehicle.catalog_area.descripcion : "No se asignó",resultado.vehicle ? resultado.vehicle.vehicle_color : "No se asignó",
          resultado.vehicle.catalog_brand ? resultado.vehicle.catalog_brand.descripcion : "No se asignó",resultado.vehicle.catalog_model ? resultado.vehicle.catalog_model.descripcion : "No se asignó",resultado.vehicle.responsable ? resultado.vehicle.responsable.nombre : "No se asignó",resultado.cantidad,
          resultado.monto,"",resultado.odometro,resultado.rendimiento]
        end
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Reporte consumo combustible.xlsx"
  end

  # POST /consumptions
  # POST /consumptions.json
  def create
    @consumption = Consumption.new(consumption_params)

    respond_to do |format|
      if @consumption.save
        format.html { redirect_to @consumption, notice: 'Consumption was successfully created.' }
        format.json { render :show, status: :created, location: @consumption }
      else
        format.html { render :new }
        format.json { render json: @consumption.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumptions/1
  # PATCH/PUT /consumptions/1.json
  def update
    respond_to do |format|
      if @consumption.update(consumption_params)
        format.html { redirect_to @consumption, notice: 'Consumption was successfully updated.' }
        format.json { render :show, status: :ok, location: @consumption }
      else
        format.html { render :edit }
        format.json { render json: @consumption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumptions/1
  # DELETE /consumptions/1.json
  def destroy
    @consumption.destroy
    respond_to do |format|
      format.html { redirect_to consumptions_url, notice: 'Consumption was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Combustible"
      session["menu2"] = "Solicitudes Autorizadas"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_consumption
      @consumption = Consumption.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def consumption_params
      params.require(:consumption).permit(:folio, :fecha_inicio, :fecha_fin, :cargas, :factura, :monto, :estatus,:usuario_autorizante_id,:base,:n_factura)
    end
    
end
