class VehicleAdaptation < ApplicationRecord
  belongs_to :vehicle
  belongs_to :catalogo_adaptation
  belongs_to :catalog_vendor
  has_one_attached :pdf
  has_one_attached :factura
  enum estatus: ["En captura","Pendiente autorización", "Autorizado", "Rechazado","Póliza generada"]
    after_create :adaptation_create

  def self.crear_factura(params, encabezado)
    bandera_error = 0
    mensaje = ""
    busqueda_enc = VehicleAdaptation.find_by(id: encabezado)
    begin
        if busqueda_enc
            doc = File.open(params[:vehicle_adaptation][:factura]) { |f| Nokogiri::XML(f) }
            archivo = Hash.from_xml(doc.to_s)
            hash = archivo["Comprobante"]
            folio_factura = hash["Folio"] 
            serie_factura = hash["Serie"]
            fecha_factura = hash["Fecha"]
            if serie_factura == "" or serie_factura.nil?
                folio_factura_def = "F-#{folio_factura}"
            else
                folio_factura_def = "#{serie_factura}#{folio_factura}"
            end
            #byebug
            identificador_unico = hash["Complemento"]["TimbreFiscalDigital"]["UUID"]
            if busqueda_enc.update(factura: params[:vehicle_adaptation][:factura],n_factura: folio_factura_def, fecha_factura: fecha_factura,uuid:identificador_unico)
                VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} autorizó la adaptación #{busqueda_enc.catalogo_adaptation.descripcion} al vehículo con número económico #{busqueda_enc.vehicle.numero_economico}.", vehicle_id: busqueda_enc.vehicle_id, user_id: User.current_user.id)
                    bandera_error = 4
                    mensaje ="Documento agregado correctamente."
                  else
                    documento.errors.full_messages.each do |error|
                        mensaje += " #{error}."
                        #byebug
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

  def self.crear_pdf(params, encabezado)
    bandera_error = 0
    mensaje = ""
    busqueda_enc = VehicleAdaptation.find_by(id: encabezado)
    begin
        if busqueda_enc
            if busqueda_enc.update(pdf: params[:vehicle_adaptation][:pdf])
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


    def self.update_request(adaptation,current_user)
        @mensaje_error = ""
        bandera_error = false
        estatus ="Autorizado"
        error = 0
        adapt = VehicleAdaptation.where(id: adaptation.id)
        #byebug
        adapt.each do |adapt|
        if adapt.catalog_vendor_id != nil
                    if !adapt.fecha_factura.nil?
                        #byebug
                            estatus_json =  VehicleAdaptation.enviar_json(current_user,adaptation)
                            if estatus_json[1]
                                @mensaje = "Solicitud Autorizada"
                                @mostrar_json = estatus_json[0]
                            else
                                @mostrar_json = estatus_json[0]
                                if @mostrar_json[0]["Mensaje"] == nil
                                    bandera_error = true
                                    @mensaje_error =" #{@mostrar_json[0]}. Folio: #{adapt.id}"
                                else
                                    
                                    bandera_error = true
                                    
                                    @mensaje_error = "Error en JD Edwards: #{@mostrar_json[0]["Mensaje"]}. Folio: #{adapt.id}"
                                end
                            end 
                    else
                        bandera_error = true
                        @mensaje_error ="Se necesita capturar la  fecha factura y la fecha aplicación. Folio:#{adapt.id} <br><br>"
                    end
                else
                    bandera_error = true
                    @mensaje_error ="Se necesita capturar un proveedor.  Folio:#{adapt.id} <br><br>"
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

    def self.enviar_json(current_user,adaptation)
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
       #byebug
        hash_poliza["numeroTransaccion"] = "1"
        hash_poliza["numeroLinea"] = "1000"
        hash_poliza["numeroBatch"] = "0"
        hash_poliza["compañiaDocumento"] = "00001"
        hash_poliza["tipoDocumento"] = "PV"
            #sacar de vendors ------
        hash_poliza["numeroProveedor"] = adaptation.catalog_vendor.clave#"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
        hash_poliza["numeroBeneficiario"] = adaptation.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
            #------------------------------
        hash_poliza["fechaFactura"] = "1#{adaptation.fecha_factura.strftime("%y")}#{(adaptation.fecha_factura).strftime("%j")}"
        hash_poliza["fechaEfectiva"] = "1#{adaptation.created_at.strftime("%y")}#{(adaptation.created_at).strftime("%j")}"

#aun no esta esta capturado a mano
        hash_poliza["fechaVencimiento"] = "" #"120252" 
        hash_poliza["fechaDescuento"] = "1#{adaptation.fecha_factura.strftime("%y")}#{(adaptation.fecha_factura).strftime("%j")}" #"120252"
#---------------------------------------------------
        #byebug

        hash_poliza["fechaLM"] = "1#{Date.today.strftime("%y")}#{(Date.today).strftime("%j")}"
        hash_poliza["añoFiscal"] = "0"
        #hash_poliza["sigloFiscal"] = "21"
        hash_poliza["sigloFiscal"] = "20"
        hash_poliza["periodoFiscal"] = "0"
        hash_poliza["compañia"] = adaptation.vehicle.catalog_company.clave#"DYENCALADA"
        hash_poliza["tipoBatch"] = "V"
        hash_poliza["transaccionBalanceada"] = "Y"
        hash_poliza["estatusDePago"] = "H"
        hash_poliza["importe"] = ((adaptation.monto * 100)).to_i
        hash_poliza["importePendiente"] = ((adaptation.monto*100).to_i).to_s
        imponible = adaptation.monto.to_f - adaptation.importe_iva.to_f #(self.monto/1.16).round(2)
        hash_poliza["importeImponible"] = (imponible.round(2)*100).round
        hash_poliza["importeImpuesto"] = (adaptation.importe_iva.to_f.floor(2)* 100).round# ((imponible * 0.16).round(2) *100).to_i
        
        #byebug
        hash_poliza["tasaFiscal"] = "IVA15GAS"
        hash_poliza["explicacionFiscal"] = "V"
        hash_poliza["tipoMoneda"] = "D"
        hash_poliza["moneda"] = "MXP"
        hash_poliza["glClass"] = adaptation.catalog_vendor.compenlm

        #hash_poliza["cuentaBancaria"] = "00003021" #sacar de vendors -------------------------------------- la agarre de vendors
        #hash_poliza["cuentaBancaria"] = ""

        hash_poliza["modoDeCuenta"] = "2"
        hash_poliza["unidadDeNegocio"] = "#{adaptation.vehicle.catalog_branch.unidad_negocio}#{adaptation.vehicle.catalog_area.clave}"

        hash_poliza["plazo"] = "01" #sacar de vendors -----------------------------------------

        hash_poliza["factura"] = adaptation.n_factura # "145525"#self.n_factura

        articulo = adaptation.catalogo_adaptation.descripcion.upcase
        hash_poliza["nameRemark"] = "#{adaptation.vehicle.catalog_branch.abreviacion} #{articulo} V#{adaptation.vehicle.numero_economico} #{adaptation.fecha_factura.strftime("%d")} #{I18n.l(adaptation.fecha_factura, format: '%^b')}"
        hash_poliza["instrumentoDePago"] = adaptation.catalog_vendor.instrumentopago
        hash_poliza["originador"] = @current_user.correo_ordenes
        hash_poliza["usuarioActualizacion"] = @current_user.correo_ordenes
        hash_poliza["idPrograma"] = adaptation.id
        hash_poliza["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}" #"1#{self.updated_at.strftime("%y")}#{(self.updated_at).strftime("%j")}"
        hash_poliza["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
        hash_poliza["estacionDeTrabajo"] = "WEB91a"
         @poliza << hash_poliza
        hash_polizaInput["poliza"] = @poliza
        #byebug
                hash_asientoDeDiario = Hash.new 
                hash_asientoDeDiario["numeroLinea"] = "1000"
                hash_asientoDeDiario["numeroBatch"] = "0"
                hash_asientoDeDiario["fechaLM"] = "1#{adaptation.fecha_factura.strftime("%y")}#{(adaptation.fecha_factura).strftime("%j")}"
                hash_asientoDeDiario["tipoBatch"] = "V"
                hash_asientoDeDiario["compañia"] = adaptation.vehicle.catalog_company.clave

                account_impact = AccountingImpact.find_by(catalog_branch_id: adaptation.catalog_branch_id,  cuenta_contable: "Adaptaciones",catalog_area_id: adaptation.catalog_area_id)#.select(:nombre)#    "01060102.6103.0101"
                if account_impact == nil
                    @mensaje_error  = ["No se encontró el número de cuenta en el catálogo de afectación contable, por favor revise la información. Folio: #{adaptation.id}"]
                    return [@mensaje_error,false] 
                end
                #aun no esta
                #if account_impact.present?
                #        hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                #else
                #    hash_asientoDeDiario["numeroCuenta"] = ""
                #end
                if account_impact.present?
                    hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                else
                    account_impact = AccountingImpact.find_by(catalog_branch_id: adaptation.catalog_branch_id,  cuenta_contable: "Otros gastos",catalog_area_id: adaptation.catalog_area_id)#.select(:nombre)#    "01060102.6103.0101"
                    if account_impact == nil
                      hash_asientoDeDiario["numeroCuenta"] = ""
                      #@mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible otros gastos, por favor revise la información. Folio: #{self.folio}"]
                      #return [@mensaje_error,false] 
                    else
                      hash_asientoDeDiario["numeroCuenta"] =  account_impact.nombre
                    end
                end
            #------------------------------------------------------------------------------------
        #no se si esta bien estos campos
                hash_asientoDeDiario["modoDeCuenta"] = "2"
                hash_asientoDeDiario["subledger"] = adaptation.catalog_vendor.clave
                hash_asientoDeDiario["subledgerType"] = "A"
        #---------------------------------------------------------------------------------------
                hash_asientoDeDiario["tipoLibro"] = "AA"
                hash_asientoDeDiario["periodoFiscal"] = "0"
                #hash_asientoDeDiario["sigloFiscal"] = "21"
                hash_asientoDeDiario["sigloFiscal"] = "20"
                hash_asientoDeDiario["añoFiscal"] = "0"
                hash_asientoDeDiario["moneda"] = "MXP"
                monto_total = adaptation.monto
                impuestos_total = adaptation.importe_iva
                imponible = (monto_total.to_f - impuestos_total.to_f)
            # imponible = (self.monto/1.16).round(2)
            #     if index == 0
            #byebug
                 hash_asientoDeDiario["monto"] = (imponible.round(2)*100).round#  (imponible * 100).to_i #((self.monto * 0.8654)*100).to_i
            #     else
            #     hash_asientoDeDiario["monto"] = ((imponible * 0.16).round(2) *100).to_i#((self.monto - (self.monto * 0.8654))*100).to_i
            #     end
        
                hash_asientoDeDiario["explicacion"] = adaptation.catalog_vendor.razonsocial.first(30) #"Servicios Gasolineros de Mexic"# //eeee
                hash_asientoDeDiario["observaciones"] = "#{adaptation.vehicle.catalog_branch.abreviacion} CARROCERIA V#{adaptation.vehicle.numero_economico} #{adaptation.fecha_factura.strftime("%d")} #{I18n.l(adaptation.fecha_factura, format: '%^b')}"
                hash_asientoDeDiario["numeroBeneficiario"] = adaptation.catalog_vendor.clave # self.vehicle_consumptions[0].vehicle.catalog_company.clave
        #aun no esta
                hash_asientoDeDiario["factura"] = adaptation.n_factura #""#"145525"
    #----------------------------------
    
                hash_asientoDeDiario["fechaFactura"] = "1#{adaptation.fecha_factura.strftime("%y")}#{(adaptation.fecha_factura).strftime("%j")}"
                hash_asientoDeDiario["fechaEfectiva"] = "1#{adaptation.created_at.strftime("%y")}#{(adaptation.created_at).strftime("%j")}"
                hash_asientoDeDiario["codigoMoneda"] = "D"
                hash_asientoDeDiario["originador"] = @current_user.correo_ordenes #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["usuarioActualizacion"] = @current_user.correo_ordenes #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["idPrograma"] = adaptation.id
                hash_asientoDeDiario["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
                hash_asientoDeDiario["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
                hash_asientoDeDiario["estacionDeTrabajo"]  = "WEB91a"
                @asientoDeDiario <<hash_asientoDeDiario
            #byebug

            hash_info_adicional["UUID"] = adaptation.uuid
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

    def adaptation_create
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó la adaptación #{self.catalogo_adaptation.descripcion} al vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
    end
end
