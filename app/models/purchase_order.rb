class PurchaseOrder < ApplicationRecord
  belongs_to :catalog_vendor
  belongs_to :cost_center
  belongs_to :catalog_company
  belongs_to :catalog_branch
  belongs_to :ticket_tire_battery, optional: true
  has_many :purchase_details
  has_many :vehicles
  has_one_attached :pdf
  has_one_attached :factura

  enum status: {"Pendiente de autorizar": 0, "Autorizado":1, "Rechazado": 2, "Cancelado": 3}
  enum tipo: {"Compra de vehículo":3, "Compra de llantas":4, "Compra de baterías":5, "Compra de extintores":6 } #Se agregó tipo (4,5,6) para la compra de artículos

    def self.consulta_ordenes(status,fecha_ini,fecha_fin,rango)
        cadena_consulta = ""
		if status != "Todos"
			cadena_consulta += " status = #{status} and"
		end

        if rango != "Todos"
            if rango == "0"
                cadena_consulta += " budget_id IS NULL and"
            else
                cadena_consulta += " budget_id IS NOT NULL and"
            end
        end
        
        if fecha_ini != "" and fecha_fin != ""
            cadena_consulta += " fecha between '#{(fecha_ini).strftime("%Y-%m-%d")}' and '#{(fecha_fin).strftime("%Y-%m-%d")}'"
        else
            cadena_consulta += " fecha between '#{Time.now.beginning_of_year.strftime("%Y-%m-%d %H:%M:%M")}' and '#{Time.now.strftime("%Y-%m-%d %H:%M:%M")}'"
        end
		consulta = PurchaseOrder.where(cadena_consulta)
		return consulta  
    end

    def self.crear_pdf(params, encabezado)
      bandera_error = 0
      mensaje = ""
      busqueda_enc = PurchaseOrder.find_by(id: encabezado)
      begin
          if busqueda_enc
              if busqueda_enc.update(pdf: params[:purchase_order][:pdf])
                  bandera_error = 4
                  mensaje = "Documento agregado correctamente."                
              else
                  documento.errors.full_messages.each do |error|
                      mensaje += " #{error}."
                  end
                  bandera_error = 3
              end
          else
              bandera_error = 1
              mensaje = "No se encontró el registro del encabezado."
          end
      rescue Exception => error
          mensaje = error
          bandera_error = 3
      end
      return mensaje,bandera_error
  end

    def self.crear_factura(params, encabezado)
        bandera_error = 0
        mensaje = ""
        id_registro = 0
        busqueda_enc = PurchaseOrder.find_by(id: encabezado)
        begin
            if busqueda_enc
                detalle = PurchaseDetail.find_by(purchase_order_id: busqueda_enc.id)
                
                if detalle.budget_detail_id
                    dato = BudgetItem.find_by(id: detalle.budget_detail_id)
                    if dato
                        cedis = CatalogBranch.find_by(id: dato.catalog_branch_id)
                        empresa = cedis.catalog_company_id
                        area = dato.catalog_area_id
                        linea = dato.catalog_brand_id
                        tipo = dato.vehicle_type_id
                        modelo = dato.catalog_model_id
                        centro = CostCenter.find_by(catalog_company_id: empresa,catalog_branch_id:cedis.id,catalog_area_id:area)
                        if centro
                            c_cst = centro.id
                        end
                    end
                end
                #byebug
                doc = File.open(params[:purchase_order][:factura]) { |f| Nokogiri::XML(f) }
                archivo = Hash.from_xml(doc.to_s)
                hash = archivo["Comprobante"]
                total_factura = hash["Total"].to_f
                fecha_factura = (DateTime.parse(hash["Fecha"])).strftime("%Y-%m-%d")
                folio_factura = hash["Folio"] 
                serie_factura = hash["Serie"]
                identificador_unico = hash["Complemento"]["TimbreFiscalDigital"]["UUID"]
                impuestos_traladados = hash["Impuestos"]["TotalImpuestosTrasladados"].to_f
                if serie_factura == "" or serie_factura.nil?
                    folio_factura_def = "F-#{folio_factura}"
                else
                    folio_factura_def = "#{serie_factura}#{folio_factura}"
                end
                #busca el numero economico mayor de tipo numerico
                numero_consecutivo = Vehicle.where("numero_economico ~* ?", '^\d+$').max
                numero_consecutivo ? nuevo_numero = numero_consecutivo.numero_economico.to_i + 1 : nuevo_numero = 1
                if busqueda_enc.update(factura: params[:purchase_order][:factura],numero_factura: folio_factura_def, fecha_factura: fecha_factura,uuid:identificador_unico,impuestos:impuestos_traladados)
                    #byebug
                    status = VehicleStatus.find_by(descripcion:"Inactivo")
                    if dato
                        compra = Vehicle.new(catalog_company_id:empresa,catalog_branch_id:cedis.id,catalog_area_id:area,catalog_brand_id:linea,vehicle_type_id:tipo,catalog_model_id:modelo,cost_center_id:busqueda_enc.cost_center_id,valor_compra: total_factura, fecha_compra:fecha_factura,numero_factura:folio_factura_def,impuestos:impuestos_traladados,vehicle_status_id:status.id,numero_economico:nuevo_numero,purchase_order_id:busqueda_enc.id,uuid:identificador_unico,cost_center_id: c_cst)
                    else
                        compra = Vehicle.new(catalog_company_id:busqueda_enc.catalog_company_id,catalog_branch_id:busqueda_enc.catalog_branch_id,catalog_brand_id:detalle.catalog_brand_id,vehicle_type_id:detalle.vehicle_type_id,catalog_model_id:detalle.catalog_model_id,cost_center_id:busqueda_enc.cost_center_id,valor_compra: total_factura, fecha_compra:fecha_factura,numero_factura:folio_factura_def,impuestos:impuestos_traladados,vehicle_status_id:status.id,numero_economico:nuevo_numero,purchase_order_id:busqueda_enc.id,uuid:identificador_unico)
                    end
                    if compra.save
                            bandera_error = 4
                            id_registro= compra.id
                            mensaje ="Documento agregado correctamente, complete los datos para la compra de vehículo."
                    else
                        compra.errors.full_messages.each do |error|
                         mensaje += " #{error}."
                        end
                        bandera_error = 3
                    end
                else
                    busqueda_enc.errors.full_messages.each do |error|
                        mensaje += " #{error}."
                    end
                    bandera_error = 3
                end
            else
                bandera_error = 1
                mensaje = "No se encontró el registro del encabezado."
            end
        rescue Exception => error
            mensaje = error
            bandera_error = 3
        end
        return mensaje,bandera_error,id_registro
    end

  def self.crear_ord(params)
        id_registro = 0
        bandera_error = 0
        mensaje = ""
        fecha = (DateTime.parse(params[:purchase_order][:fecha])).strftime("%Y-%m-%d")

        begin
            consulta_corte = Deadline.where("fecha_inicio <= '#{fecha}' and fecha_fin >= '#{fecha}' and estatus = TRUE")
            
            if consulta_corte.length > 0
                bandera_error = 2
                mensaje = "Ya se realizó el corte para la fecha seleccionada"
            else
                numero_consecutivo = PurchaseOrder.where("clave ~* ?", '^\d+$').max
                numero_consecutivo ? nuevo_numero = numero_consecutivo.clave.to_i + 1 : nuevo_numero = 1
                if params[:purchase_order][:catalog_company_id] == "" and params[:purchase_order][:catalog_vendor_id] and params[:purchase_order][:fecha] == "" and params[:purchase_order][:cost_center_id]== "" and params[:purchase_order][:condicion] == ""
                bandera_error =  1
                else
                    orden = PurchaseOrder.new(catalog_company_id:params[:purchase_order][:catalog_company_id],catalog_vendor_id:params[:purchase_order][:catalog_vendor_id],fecha:params[:purchase_order][:fecha],cost_center_id:params[:purchase_order][:cost_center_id],condicion:params[:purchase_order][:condicion],plazo_dias:params[:purchase_order][:plazo_dias] ,status:0,clave:nuevo_numero,catalog_branch_id:params[:purchase_order][:catalog_branch_id],tipo:params[:purchase_order][:tipo],ultima_fecha_pago:params[:purchase_order][:ultima_fecha_pago],usuario_creador: User.current_user.id)
                end 
                if orden.save 
                    bandera_error = 4
                    id_registro= orden.id
                    mensaje = "Orden creada con exito"
                else
                    orden.errors.full_messages.each do |error|
                        bandera_error = 2
                        mensaje = "Ocurrio un error favor de contactar soporte. Error: #{error}"
                    end
                end
            end
        rescue Exception => error 
            bandera_error = 3
            mensaje = "Ocurrio un error favor de contactar soporte. Error: #{error}"
        end
        return  bandera_error, id_registro,mensaje
    end
        
    def self.update_request(vehicle,current_user,cuenta)
        @mensaje_error = ""
        bandera_error = false
        estatus = "Autorizado"
        error = 0
        order = PurchaseOrder.where(id: vehicle.purchase_order_id)
          order.each do |order|
          if order.catalog_vendor_id != nil
              if !order.fecha.nil?
                #byebug
                      estatus_json =  PurchaseOrder.enviar_json(current_user,order,vehicle,cuenta)
                      if estatus_json[1]
                        @mensaje = "Solicitud Autorizada"
                        @mostrar_json = estatus_json[0]
                      else
                          @mostrar_json = estatus_json[0]
                          if @mostrar_json[0]["Mensaje"] == nil
                              bandera_error = true
                              @mensaje_error = " #{@mostrar_json[0]}."
                          else 
                              bandera_error = true
                              @mensaje_error = "Error en JD Edwards: #{@mostrar_json[0]["Mensaje"]}. Folio: #{order.id}"
                          end
                      end 
              else
                  bandera_error = true
                  @mensaje_error ="Se necesita capturar la  fecha factura y la fecha aplicación. Folio:#{order.id} <br><br>"
              end
          else
              bandera_error = true
              @mensaje_error ="Se necesita capturar un proveedor.  Folio:#{order.id} <br><br>"
          end
          #byebug
      end
        if bandera_error 
            @mensaje_error
            @error = 1
            #byebug
            return @mensaje_error,@error
        else
            @mensaje
            @error = 2
            return @mensaje,@error
        end
    end



    def self.enviar_json(current_user,order,vehicle,cuenta)
        @current_user = current_user
        @objeto_principal = []
        @polizaInput = []
        @poliza = []
        @asientoDeDiario = []
        @info_adicional = []
        hash_principal = Hash.new
        hash_polizaInput = Hash.new
        hash_poliza = Hash.new
        hash_info_adicional = Hash.new
        hash_poliza["usuario"] = @current_user.correo_ordenes
       # byebug
        hash_poliza["numeroTransaccion"] = "1"
        hash_poliza["numeroLinea"] = "1000"
        hash_poliza["numeroBatch"] = "0"
        hash_poliza["compañiaDocumento"] = "00001"
        hash_poliza["tipoDocumento"] = "PV"
            #sacar de vendors ------
        hash_poliza["numeroProveedor"] = order.catalog_vendor.clave#"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
        hash_poliza["numeroBeneficiario"] = order.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
            #------------------------------
        hash_poliza["fechaFactura"] = "1#{vehicle.fecha_compra.strftime("%y")}#{(vehicle.fecha_compra).strftime("%j")}"
        hash_poliza["fechaEfectiva"] = "1#{vehicle.created_at.strftime("%y")}#{(vehicle.created_at).strftime("%j")}"

#aun no esta esta capturado a mano
        hash_poliza["fechaVencimiento"] = "" #"120252" 
        hash_poliza["fechaDescuento"] = "1#{vehicle.fecha_compra.strftime("%y")}#{(vehicle.fecha_compra).strftime("%j")}" #"120252"
#---------------------------------------------------
        #byebug

        hash_poliza["fechaLM"] = "1#{Date.today.strftime("%y")}#{(Date.today).strftime("%j")}"
        hash_poliza["añoFiscal"] = "0"
        #hash_poliza["sigloFiscal"] = "21"
        hash_poliza["sigloFiscal"] = "20"
        hash_poliza["periodoFiscal"] = "0"
        hash_poliza["compañia"] = order.vehicle.catalog_company.clave#"DYENCALADA"
        hash_poliza["tipoBatch"] = "V"
        hash_poliza["transaccionBalanceada"] = "Y"
        hash_poliza["estatusDePago"] = "H"
        hash_poliza["importe"] = (( vehicle.valor_compra*100)).to_i
        hash_poliza["importePendiente"] = ((vehicle.valor_compra*100).to_i).to_s
        imponible = vehicle.valor_compra.to_f - vehicle.impuestos.to_f #(self.monto/1.16).round(2)
        hash_poliza["importeImponible"] = (imponible.round(2)*100).round
        hash_poliza["importeImpuesto"] = (vehicle.impuestos.to_f.floor(2)* 100).round# ((imponible * 0.16).round(2) *100).to_i


        hash_poliza["tasaFiscal"] = "IVA15GAS"
        hash_poliza["explicacionFiscal"] = "V"
        hash_poliza["tipoMoneda"] = "D"
        hash_poliza["moneda"] = "MXP"
        hash_poliza["glClass"] = order.catalog_vendor.compenlm

        #hash_poliza["cuentaBancaria"] = "00003021" #sacar de vendors -------------------------------------- la agarre de vendors
        #hash_poliza["cuentaBancaria"] = ""

        hash_poliza["modoDeCuenta"] = "2"
        hash_poliza["unidadDeNegocio"] = "#{order.vehicle.catalog_branch.unidad_negocio}#{order.vehicle.catalog_area.clave}"

        hash_poliza["plazo"] = order.catalog_vendor.plazo #sacar de vendors -----------------------------------------

        hash_poliza["factura"] = vehicle.numero_factura # "145525"#self.n_factura
        linea = vehicle.catalog_brand.descripcion.upcase      
        hash_poliza["nameRemark"] = "#{vehicle.catalog_branch.abreviacion} #{linea.first(5)} #{vehicle.fecha_compra.strftime("%y")} V#{vehicle.numero_economico} #{vehicle.fecha_compra.strftime("%d")} #{I18n.l(vehicle.fecha_compra, format: '%^b')}"
        hash_poliza["instrumentoDePago"] = order.catalog_vendor.instrumentopago
        hash_poliza["originador"] = @current_user.correo_ordenes
        hash_poliza["usuarioActualizacion"] = @current_user.correo_ordenes
        hash_poliza["idPrograma"] = order.id
        hash_poliza["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}" #"1#{self.updated_at.strftime("%y")}#{(self.updated_at).strftime("%j")}"
        hash_poliza["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
        hash_poliza["estacionDeTrabajo"] = "WEB91a"
         @poliza << hash_poliza
        hash_polizaInput["poliza"] = @poliza
        #byebug

                hash_asientoDeDiario = Hash.new 
                hash_asientoDeDiario["numeroLinea"] = "1000"
                hash_asientoDeDiario["numeroBatch"] = "0"
                hash_asientoDeDiario["fechaLM"] = "1#{vehicle.fecha_compra.strftime("%y")}#{(vehicle.fecha_compra).strftime("%j")}"
                hash_asientoDeDiario["tipoBatch"] = "V"
                hash_asientoDeDiario["compañia"] = vehicle.catalog_company.clave
                
                if cuenta == "Compras"
                    account_impact = AccountingImpact.find_by(catalog_branch_id: order.catalog_branch_id,  cuenta_contable: "Compras",catalog_area_id: order.catalog_area_id)
                else 
                    account_impact = AccountingImpact.find_by(catalog_branch_id: order.catalog_branch_id,  cuenta_contable: "Maquinaria y equipo",catalog_area_id: order.catalog_area_id)
                end 

                if account_impact == nil
                    @mensaje_error  = ["No se encontró el número de cuenta en el catálogo de afectación contable, por favor revise la información. Folio: #{order.id}"]
                    return [@mensaje_error,false] 
                end
                #aun no esta
                if account_impact.present?
                    hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                else
                    account_impact = AccountingImpact.find_by(catalog_branch_id: order.catalog_branch_id,  cuenta_contable: "Otros gastos",catalog_area_id: order.catalog_area_id)#.select(:nombre)#    "01060102.6103.0101"
                    if account_impact == nil
                      hash_asientoDeDiario["numeroCuenta"] = ""
                      #@mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible otros gastos, por favor revise la información. Folio: #{self.folio}"]
                      #return [@mensaje_error,false] 
                    else
                      hash_asientoDeDiario["numeroCuenta"] =  account_impact.nombre
                    end
                end
                #if account_impact.present?
                #        hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                #else
                #    hash_asientoDeDiario["numeroCuenta"] = ""
                #end
            #------------------------------------------------------------------------------------
        #no se si esta bien estos campos
                hash_asientoDeDiario["modoDeCuenta"] = "2"
                hash_asientoDeDiario["subledger"] =  order.catalog_vendor.clave 
                hash_asientoDeDiario["subledgerType"] = "A"
        #---------------------------------------------------------------------------------------
                hash_asientoDeDiario["tipoLibro"] = "AA"
                hash_asientoDeDiario["periodoFiscal"] = "0"
                #hash_asientoDeDiario["sigloFiscal"] = "21"
                hash_asientoDeDiario["sigloFiscal"] = "20"
                hash_asientoDeDiario["añoFiscal"] = "0"
                hash_asientoDeDiario["moneda"] = "MXP"
                monto_total = vehicle.valor_compra
                impuestos_total = vehicle.impuestos
                imponible = (monto_total.to_f - impuestos_total.to_f)
            # imponible = (self.monto/1.16).round(2)
            #     if index == 0
            #byebug
                 hash_asientoDeDiario["monto"] = (imponible.round(2)*100).round#  (imponible * 100).to_i #((self.monto * 0.8654)*100).to_i
            #     else
            #     hash_asientoDeDiario["monto"] = ((imponible * 0.16).round(2) *100).to_i#((self.monto - (self.monto * 0.8654))*100).to_i
            #     end
        
                hash_asientoDeDiario["explicacion"] = order.catalog_vendor.razonsocial.first(30) #"Servicios Gasolineros de Mexic"# //eeee
                hash_asientoDeDiario["observaciones"] =  "#{vehicle.catalog_branch.abreviacion} #{linea.first(5)} #{vehicle.fecha_compra.strftime("%y")} V#{vehicle.numero_economico} #{vehicle.fecha_compra.strftime("%d")} #{I18n.l(vehicle.fecha_compra, format: '%^b')}"
                hash_asientoDeDiario["numeroBeneficiario"] = order.catalog_vendor.clave# self.vehicle_consumptions[0].vehicle.catalog_company.clave
        #aun no esta
                hash_asientoDeDiario["factura"] = vehicle.numero_factura #""#"145525"
    #----------------------------------
    
                hash_asientoDeDiario["fechaFactura"] = "1#{vehicle.fecha_compra.strftime("%y")}#{(vehicle.fecha_compra).strftime("%j")}"
                hash_asientoDeDiario["fechaEfectiva"] = "1#{vehicle.created_at.strftime("%y")}#{(vehicle.created_at).strftime("%j")}"
                hash_asientoDeDiario["codigoMoneda"] = "D"
                hash_asientoDeDiario["originador"] = @current_user.correo_ordenes #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["usuarioActualizacion"] = @current_user.correo_ordenes #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["idPrograma"] = order.id
                hash_asientoDeDiario["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
                hash_asientoDeDiario["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
                hash_asientoDeDiario["estacionDeTrabajo"]  = "WEB91a"
                @asientoDeDiario <<hash_asientoDeDiario
            #byebug

            hash_info_adicional["UUID"] = vehicle.uuid
            @info_adicional << hash_info_adicional
            hash_polizaInput["asientoDeDiario"] = @asientoDeDiario
            hash_polizaInput["infoAdicional"] = @info_adicional
            @polizaInput << hash_polizaInput
            hash_principal["polizaInput"] = @polizaInput[0]
            @objeto_principal << hash_principal
            #byebug
    # comentar de aquí a...
            paremetro_nombre = Parameter.find_by(nombre:"Url Poliza JDE")
            url = URI(paremetro_nombre.valor_extendido)
            #url = URI("http://gafinet.gafi.com.mx:9200/api/v1/poliza")
            https = Net::HTTP.new(url.host, url.port);
            request = Net::HTTP::Put.new(url)
             request["Content-Type"] = "application/json"
             request["Accept"] = "application/json"
             request.body = @objeto_principal[0].to_json
             response = https.request(request)
             @json_parciado = []
             respuesta = JSON.parse response.body
             #byebug
             if respuesta[0].nil?
             @json_parciado.push(respuesta)
             else
                @json_parciado = respuesta
             end

             JdeLog.create(
                 fecha: Time.zone.now.to_date,
                 hora: Time.zone.now,
                 json_enviado: @objeto_principal,
                 respuesta: @json_parciado
              )

            if @json_parciado.map{|x| x['Exitoso']}.include?(false) 
                return [@json_parciado,false]
            else
                return [@json_parciado,true]
            end
        # aquí, para no  enviar  el json a JDE
        # return[@objeto_principal,true]   #descomentar este return para que ver el json que se esta mandando a JDE
    end

end
