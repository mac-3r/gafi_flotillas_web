class TicketTireBattery < ApplicationRecord
  belongs_to :vehicle
  enum tipo: ["Llanta", "Batería","Extintor"]
  enum estatus: ["Pendiente", "Atendida sin gasto","Autorizado","Proceso de compra","Pendiente de entrega","Entregado"]

  def self.update_request(control,current_user)
    @mensaje_error = ""
    bandera_error = false
    estatus ="Autorizado"
    error = 0
    #byebug
    order = MaintenanceControl.where(id: control)
      order.each do |order|
      if order.catalog_vendor_id != nil
          if !order.fecha_factura.nil?
            #byebug
                  estatus_json =  TicketTireBattery.enviar_json(current_user,order)
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



def self.enviar_json(current_user,order)
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
    hash_poliza["compañiaDocumento"] = order.vehicle.catalog_company.clave
    hash_poliza["tipoDocumento"] = "PV"
        #sacar de vendors ------
    hash_poliza["numeroProveedor"] = order.catalog_vendor.clave#"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
    hash_poliza["numeroBeneficiario"] = order.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
        #------------------------------
    hash_poliza["fechaFactura"] = "1#{order.fecha_factura.strftime("%y")}#{(order.fecha_factura).strftime("%j")}"
    hash_poliza["fechaEfectiva"] = "1#{order.created_at.strftime("%y")}#{(order.created_at).strftime("%j")}"

#aun no esta esta capturado a mano
    hash_poliza["fechaVencimiento"] = "" #"120252" 
    hash_poliza["fechaDescuento"] = "1#{order.fecha_factura.strftime("%y")}#{(order.fecha_factura).strftime("%j")}" #"120252"
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
    hash_poliza["importe"] = (( order.importe*100)).to_i
    hash_poliza["importePendiente"] = ((order.importe*100).to_i).to_s
    imponible = order.importe.to_f - order.impuestos.to_f #(self.monto/1.16).round(2)
    hash_poliza["importeImponible"] = (imponible.round(2)*100).round
    hash_poliza["importeImpuesto"] = (order.impuestos.to_f.floor(2)* 100).round# ((imponible * 0.16).round(2) *100).to_i


    hash_poliza["tasaFiscal"] = "IVA15GAS"
    hash_poliza["explicacionFiscal"] = "V"
    hash_poliza["tipoMoneda"] = "D"
    hash_poliza["moneda"] = "MXP"
    hash_poliza["glClass"] = order.catalog_vendor.compenlm

    #hash_poliza["cuentaBancaria"] = "00003021" #sacar de vendors -------------------------------------- la agarre de vendors
    #hash_poliza["cuentaBancaria"] = ""

    hash_poliza["modoDeCuenta"] = "2"
    hash_poliza["unidadDeNegocio"] = "#{order.service_order.catalog_branch.unidad_negocio}#{order.service_order.catalog_area.clave}"

    hash_poliza["plazo"] = order.catalog_vendor.plazo #sacar de vendors -----------------------------------------

    hash_poliza["factura"] = order.folio_factura # "145525"#self.n_factura
    
    tipo = order.service_order.ticket_tire_battery.tipo.first(3).upcase
    hash_poliza["nameRemark"] = "#{order.vehicle.catalog_branch.abreviacion} MTT-#{order.vehicle.catalog_area.abreviacion}-#{order.vehicle.numero_economico}-#{tipo} #{order.folio_factura}"
    hash_poliza["instrumentoDePago"] = order.catalog_vendor.instrumentopago
    hash_poliza["originador"] = @current_user.correo_ordenes
    hash_poliza["usuarioActualizacion"] = @current_user.correo_ordenes
    hash_poliza["idPrograma"] = order.id
    hash_poliza["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}" #"1#{self.updated_at.strftime("%y")}#{(self.updated_at).strftime("%j")}"
    hash_poliza["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
    hash_poliza["estacionDeTrabajo"] = "WEB91a"
     @poliza << hash_poliza
    hash_polizaInput["poliza"] = @poliza
            hash_asientoDeDiario = Hash.new 
            hash_asientoDeDiario["numeroLinea"] = "1000"
            hash_asientoDeDiario["numeroBatch"] = "0"
            hash_asientoDeDiario["fechaLM"] = "1#{order.fecha_factura.strftime("%y")}#{(order.fecha_factura).strftime("%j")}"
            hash_asientoDeDiario["tipoBatch"] = "V"
            hash_asientoDeDiario["compañia"] = order.vehicle.catalog_company.clave

            account_impact = AccountingImpact.find_by(catalog_branch_id: order.vehicle.catalog_branch_id,  cuenta_contable: "Mantenimiento y equipo de transporte",catalog_area_id: order.vehicle.catalog_area_id)#.select(:nombre)#    "01060102.6103.0101"
            if account_impact == nil
                @mensaje_error  = ["No se encontró el número de cuenta en el catálogo de afectación contable, por favor revise la información. Folio: #{order.id}"]
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
            hash_asientoDeDiario["subledger"] = order.catalog_vendor.clave
            hash_asientoDeDiario["subledgerType"] = "A"
    #---------------------------------------------------------------------------------------
            hash_asientoDeDiario["tipoLibro"] = "AA"
            hash_asientoDeDiario["periodoFiscal"] = "0"
            #hash_asientoDeDiario["sigloFiscal"] = "21"
            hash_asientoDeDiario["sigloFiscal"] = "20"
            hash_asientoDeDiario["añoFiscal"] = "0"
            hash_asientoDeDiario["moneda"] = "MXP"
            monto_total = order.importe
            impuestos_total = order.impuestos
            imponible = (monto_total.to_f - impuestos_total.to_f)
        # imponible = (self.monto/1.16).round(2)
        #     if index == 0
        #byebug
             hash_asientoDeDiario["monto"] = (imponible.round(2)*100).round#  (imponible * 100).to_i #((self.monto * 0.8654)*100).to_i
        #     else
        #     hash_asientoDeDiario["monto"] = ((imponible * 0.16).round(2) *100).to_i#((self.monto - (self.monto * 0.8654))*100).to_i
        #     end
    
            hash_asientoDeDiario["explicacion"] = order.catalog_vendor.razonsocial.first(30) #"Servicios Gasolineros de Mexic"# //eeee
            hash_asientoDeDiario["observaciones"] =  "#{order.vehicle.catalog_branch.abreviacion} MTT-#{order.vehicle.catalog_area.abreviacion}-#{order.vehicle.numero_economico}-#{tipo} #{order.folio_factura}"
            hash_asientoDeDiario["numeroBeneficiario"] = order.catalog_vendor.clave# self.vehicle_consumptions[0].vehicle.catalog_company.clave
    #aun no esta
            hash_asientoDeDiario["factura"] = order.folio_factura #""#"145525"
#----------------------------------

            hash_asientoDeDiario["fechaFactura"] = "1#{order.fecha_factura.strftime("%y")}#{(order.fecha_factura).strftime("%j")}"
            hash_asientoDeDiario["fechaEfectiva"] = "1#{order.created_at.strftime("%y")}#{(order.created_at).strftime("%j")}"
            hash_asientoDeDiario["codigoMoneda"] = "D"
            hash_asientoDeDiario["originador"] = @current_user.correo_ordenes #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
            hash_asientoDeDiario["usuarioActualizacion"] = @current_user.correo_ordenes #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
            hash_asientoDeDiario["idPrograma"] = order.id
            hash_asientoDeDiario["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
            hash_asientoDeDiario["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
            hash_asientoDeDiario["estacionDeTrabajo"]  = "WEB91a"
            @asientoDeDiario <<hash_asientoDeDiario
        #byebug

        hash_info_adicional["UUID"] = order.uuid
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
