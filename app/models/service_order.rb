class ServiceOrder < ApplicationRecord
  belongs_to :maintenance_program, optional: true
  belongs_to :vehicle
  belongs_to :catalog_workshop, optional:true
  belongs_to :maintenance_ticket, optional: true
  belongs_to :catalog_tires_battery, optional: true
  belongs_to :catalog_vendor, optional: true
  belongs_to :order_service_type, optional:true
  belongs_to :ticket_tire_battery, optional:true
  has_one :maintenance_control
  has_one_attached :pdf
  has_one_attached :factura
  has_one_attached :adicional_archivo
  has_one_attached :cotizacion_servicio
  belongs_to :catalog_area, optional: true
  belongs_to :catalog_branch, optional: true

  
  enum estatus: ["Cancelado","Pendiente","Cita programada", "Nueva fecha sugerida","Entrada a taller", "Esperando autorización","Autorizada","Rechazada", "Rechazado y cancelado","Salió de taller","Compra autorizada","Compra Realizada","Servicio Finalizado", "En captura", "Entrega de vehículo"]
  enum tipo_servicio: ["Preventivo", "Preventivo Agencia", "Correctivo", "Correctivo Agencia"]

  def self.consulta_ordenes(n_orden,empresa,cedis,user,tipo,linea,area)
    cadena_consulta = ""
      if n_orden != ""
        cadena_consulta += " service_orders.n_orden = '#{n_orden}' and"
      end
      if empresa != ""
        cadena_consulta += " vehicles.catalog_company_id = #{empresa} and"
      end
      if cedis != "" 
        cadena_consulta += " vehicles.catalog_branch_id = #{cedis} and"
      end
      if user != "" 
        cadena_consulta += " vehicles.catalog_personal_id = #{user} and"
      end
      if tipo != ""
        cadena_consulta += " vehicles.vehicle_type_id = '#{tipo}' and"
      end
      if linea != ""
        cadena_consulta += " vehicles.catalog_brand_id = '#{linea}' and"
      end
      if area != ""
        cadena_consulta += " vehicles.catalog_area_id = '#{area}' and"
      end

      cadena_consulta += " service_orders.vehicle_id IS NOT NULL"
        #consulta = ServiceOrder.joins(:vehicle).where(cadena_consulta).order(created_at: :desc).limit(30)
        consulta = ServiceOrder.joins(:vehicle).where(cadena_consulta).order("vehicles.id asc")
      return consulta  
  end

  def self.consulta_ordenes_taller(n_orden,empresa,cedis,user,tipo,linea,area,taller)
    cadena_consulta = ""
      if n_orden != ""
        cadena_consulta += " service_orders.n_orden = '#{n_orden}' and"
      end
      if empresa != ""
        cadena_consulta += " vehicles.catalog_company_id = #{empresa} and"
      end
      if cedis != "" 
        cadena_consulta += " vehicles.catalog_branch_id = #{cedis} and"
      end
      if user != "" 
        cadena_consulta += " vehicles.catalog_personal_id = #{user} and"
      end
      if tipo != ""
        cadena_consulta += " vehicles.vehicle_type_id = '#{tipo}' and"
      end
      if linea != ""
        cadena_consulta += " vehicles.catalog_brand_id = '#{linea}' and"
      end
      if area != ""
        cadena_consulta += " vehicles.catalog_area_id = '#{area}' and"
      end

      cadena_consulta += " service_orders.vehicle_id IS NOT NULL and service_orders.catalog_workshop_id = #{taller}"
        #consulta = ServiceOrder.joins(:vehicle).where(cadena_consulta).order(created_at: :desc)
        consulta = ServiceOrder.joins(:vehicle).where(cadena_consulta).order("vehicles.id asc")
      return consulta  
  end

    def self.ver_servicios(linea,vehicle_id) 
         begin
            resultados = []
            bandera_error = 0
            res_servicios = []
            servicios_inf = []
            vehiculo = Vehicle.find_by(id: vehicle_id)

            programa = MaintenanceProgram.find_by(vehicle_id: vehicle_id)
            if programa != nil
                dias = programa.maintenance_frecuency.dias.to_i
                if dias != 0
                    fecha_validacion = programa.fecha_ultima_afinacion + dias.days
                else
                    fecha_validacion = programa.fecha_ultima_afinacion + 6.months
                end
            end
            valor = Parameter.find_by(valor: "Valor para bitacora")
            @ultimo_km = MileageIndicator.select('km_actual','fecha').where(vehicle_id:vehicle_id).last
            @conceptos = Concept.where(estatus:true)
            @conceptos.each do |concepto|

            @bitacora = Binnacle.where(concept_id:concepto.id, catalog_brand_id: linea.id)
            if @bitacora != []
                @bitacora.each do |bi|
                    multiplo_reemplazo = 0
                    multiplo_insp = 0
                    if bi.bujias == true
                        bujias = "si"
                    else
                        bujias = "no"
                    end

                    ser = ConceptServiceDescription.joins(:concept_service).where(concept_description_id:bi.concept_description_id).where.not(concept_services: {descripcion: "Inspección"})
                    ser1 = ConceptServiceDescription.joins(:concept_service).where(concept_description_id:bi.concept_description_id).where.not(concept_services: {descripcion: "Reemplazo"})
                    if bi.tipo_frecuencia == "KM" or bi.tipo_frecuencia == "Horas"
                        if  bi.frecuencia_reemplazo != nil
                            (1..10).each do |index|
                                mult_r = bi.frecuencia_reemplazo.to_f * index 
                                if mult_r >= @ultimo_km.km_actual.to_f
                                    multiplo_reemplazo = mult_r
                                    break
                                end
                            end
                            if vehiculo.catalog_route.descripcion == "Foraneo"
                            
                                valor_def = multiplo_reemplazo - valor.valor_extendido.to_f
                                if @ultimo_km.km_actual.to_f >= valor_def and @ultimo_km.km_actual.to_f <= multiplo_reemplazo
                                    servicio_realizar = ser[0].concept_service.descripcion
                                else
                                    servicio_realizar = ""
                                end 
                            else
                                valor_def = multiplo_reemplazo - bi.frecuencia_reemplazo.to_f
                                val = valor_def + valor.valor_extendido.to_f
                                if @ultimo_km.km_actual.to_f >= valor_def and @ultimo_km.km_actual.to_f <= val
                                    servicio_realizar = ser[0].concept_service.descripcion
                                else
                                    servicio_realizar = ""
                                end
                            end
                        end

                        if bi.frecuencia_inspeccion != nil
                            (1..10).each do |index|
                                mult_i = bi.frecuencia_inspeccion.to_f * index 
                                    if mult_i >= @ultimo_km.km_actual.to_f
                                        multiplo_insp = mult_i
                                        break
                                    end
                            end
                            if vehiculo.catalog_route.descripcion == "Foraneo"
                                valor_def = multiplo_insp - valor.valor_extendido.to_f
                                if @ultimo_km.km_actual.to_f >= valor_def and @ultimo_km.km_actual.to_f <= multiplo_insp
                                    servicio_realizar = ser1[0].concept_service.descripcion
                                else
                                    servicio_realizar = ""
                                end 
                            else
                                valor_def = multiplo_insp - bi.frecuencia_inspeccion.to_f
                                val = valor_def + valor.valor_extendido.to_f
                                if @ultimo_km.km_actual.to_f >= valor_def and @ultimo_km.km_actual.to_f <= val
                                    servicio_realizar = ser1[0].concept_service.descripcion
                                else
                                    servicio_realizar = ""
                                end
                            end
                        end
                    else
                        if bi.frecuencia_reemplazo != nil
                            meses_transcurridos = (((Time.zone.now.to_date - bi.fecha.to_date ).to_f / 365 * 12).round -1)
                            periodos_transcurridos = meses_transcurridos/bi.frecuencia_reemplazo
                            meses_transcurridos_periodo = periodos_transcurridos * bi.frecuencia_reemplazo
                            if meses_transcurridos == 0 or meses_transcurridos <=0
                            fecha_servicio = bi.fecha
                            else
                            fecha_servicio = bi.fecha.to_date + meses_transcurridos_periodo.month
                            end
                            if fecha_servicio.strftime('%y-%m') == Time.zone.now.to_date.strftime('%y-%m')
                                servicio_realizar = ser[0].concept_service.descripcion
                            elsif fecha_validacion <= Time.zone.now.to_date
                                servicio_realizar =  ser[0].concept_service.descripcion
                            else
                            servicio_realizar = ""
                            end
                        else
                            meses_transcurridos = (((Time.zone.now.to_date - bi.fecha.to_date ).to_f / 365 * 12).round -1)
                            periodos_transcurridos = meses_transcurridos/bi.frecuencia_inspeccion
                            meses_transcurridos_periodo = periodos_transcurridos * bi.frecuencia_inspeccion
                            if meses_transcurridos == 0 or meses_transcurridos <=0
                            fecha_servicio = bi.fecha
                            else
                            fecha_servicio = bi.fecha.to_date + meses_transcurridos_periodo.month
                            end
                            if fecha_servicio.strftime('%y-%m') == Time.zone.now.to_date.strftime('%y-%m')
                            servicio_realizar = ser1[0].concept_service.descripcion
                            elsif fecha_validacion <= Time.zone.now.to_date
                            servicio_realizar = ser1[0].concept_service.descripcion
                            else
                                servicio_realizar = ""
                            end
                        end
                    end
                    resultados.push(nombre_concepto:concepto.descripcion, accion:bi.nombre,tipo:bi.tipo_frecuencia,tipo_afinacion:bi.tipo_afinacion,frecuencia_r: bi.frecuencia_reemplazo,frecuencia_i: bi.frecuencia_inspeccion,servicio:servicio_realizar)
                    #arreglo con puros servicios
                    if servicio_realizar != ""
                        if concepto.descripcion == "MOTOR"
                            #solo se cobrara motor
                            res_servicios.push(servicio_realizar,bujias)  
                        end
                        servicios_inf.push(servicio:servicio_realizar,nombre:concepto.descripcion,accion:bi.nombre) 
                    end
                end
            end
        end
    rescue => exception
        bandera_error = 3
        mensaje = "Ocurrio un error, favor de contactar soporte. Error:#{exception}"
        puts mensaje
    end
        return resultados,res_servicios,servicios_inf,bandera_error,mensaje
    end

    def self.ver_precio(service_order)
        servicios = ServiceOrder.ver_servicios(service_order.vehicle.catalog_brand,service_order.vehicle_id)[1]
        precio = TuningPrice.find_by(catalog_workshop_id: service_order.catalog_workshop_id,catalog_brand_id:service_order.vehicle.catalog_brand_id,status:true,anio:Time.now.year)
        if precio
           if servicios != []
                if servicios.select {|a| a.include? 'Reemplazo'}.length > 0 and servicios.select {|a| a.include? 'si'}.length == 0
                    #solo reemplazo sin bujias
                precio_total = precio.precio_mayor_sin.to_f
                #reemplazo con bujias
                elsif servicios.select {|a| a.include? 'Reemplazo'}.length > 0 and servicios.select {|a| a.include? 'si'}.length > 0
                    precio_total = precio.precio_mayor.to_f 
                #solo inspeccion
                else
                    precio_total = 0
                end
            else 
                precio_total = 0
            end
        else 
            precio_total = 0
        end
        return precio_total
    end

  def self.historial_gastos(orden)
    vehiculo_id = orden.vehicle_id
    dos_an = I18n.l(Time.now - 2.years,format: '%Y')
    un_an = I18n.l(Time.now - 1.years,format: '%Y')
    actual = I18n.l(Time.now,format: '%Y')
    #busca reparaciones y el total de hace 2 años
    gasto_dos_años = MaintenanceControl.where("vehicle_id =#{vehiculo_id} and año ='#{dos_an}'")
    total_dos_años = MaintenanceControl.where("vehicle_id =#{vehiculo_id} and año ='#{dos_an}'").sum(:importe)
    #busca reparaciones y el total de hace 1 año
    gasto_un_año = MaintenanceControl.where("vehicle_id =#{vehiculo_id} and año ='#{un_an}'")
    total_un_año = MaintenanceControl.where("vehicle_id =#{vehiculo_id} and año ='#{un_an}'").sum(:importe)
    #busca reparaciones y el total de este año
    gasto_actual = MaintenanceControl.where("vehicle_id =#{vehiculo_id} and año ='#{actual}'")
    total_actual = MaintenanceControl.where("vehicle_id =#{vehiculo_id} and año ='#{actual}'").sum(:importe)
    return gasto_dos_años,total_dos_años,gasto_un_año,total_un_año,gasto_actual,total_actual
  end

    def self.crear_factura(params, encabezado)
      bandera_error = 0
      mensaje = ""
      id_registro = 0
      busqueda_enc = ServiceOrder.find_by(id: encabezado)
        #begin
            if busqueda_enc
                doc = File.open(params[:service_order][:factura]) { |f| Nokogiri::XML(f) }
                archivo = Hash.from_xml(doc.to_s)
                hash = archivo["Comprobante"]
                total_factura = hash["Total"]
                total_factura_comp = hash["Total"].split(".")
                monto_encabezado = busqueda_enc.precio.to_s.split(".")
                fecha_factura = hash["Fecha"]
                start_date = busqueda_enc.fecha_entrada
                end_date =  busqueda_enc.fecha_salida
                #cuando sea por mmto guaradara los dias
                if start_date and end_date 
                    dias_taller = ((end_date - start_date).to_f / 1.day).floor
                end
                mes = I18n.l(DateTime.parse(fecha_factura),format: '%B')
                ano = I18n.l(DateTime.parse(fecha_factura),format: '%Y')
                impuestos = hash["Impuestos"]["TotalImpuestosTrasladados"].to_f
                identificador_unico = hash["Complemento"]["TimbreFiscalDigital"]["UUID"]
                folio_factura = hash["Folio"] 
                serie_factura = hash["Serie"]
                if serie_factura == "" or serie_factura.nil?
                    folio_factura_def = "F-#{folio_factura}"
                else
                    folio_factura_def = "#{serie_factura}#{folio_factura}"
                end
                #actualizacion programa mmto
                ultimo_km = MileageIndicator.select('km_actual').where(vehicle_id: busqueda_enc.vehicle_id).last
                programa = MaintenanceProgram.find_by(vehicle_id: busqueda_enc.vehicle_id)
                if programa != nil
                    dias = programa.maintenance_frecuency.dias.to_i
                    if dias != 0
                        prox_fecha = programa.fecha_ultima_afinacion + dias.days
                    else
                        prox_fecha = programa.fecha_ultima_afinacion + 6.months
                    end
                    #(((14928+5000)/5000).round(2))*5000
                    prox_km = ((ultimo_km.km_actual.to_f + programa.frecuencia_mantenimiento.to_f)/programa.frecuencia_mantenimiento.to_f).round * programa.frecuencia_mantenimiento.to_f
                end
                if  monto_encabezado[0].to_f == total_factura_comp[0].to_f
                    if programa
                        if busqueda_enc.update(factura: params[:service_order][:factura]) and programa.update(fecha_proximo:prox_fecha,kms_proximo_servicio:prox_km)      
                            if busqueda_enc.catalog_workshop_id
                                if busqueda_enc.catalog_workshop.catalog_vendor_id
                                    if busqueda_enc.tipo_servicio == "Preventivo" or busqueda_enc.tipo_servicio == "Preventivo Agencia"
                                        res = ServiceOrder.registrar_preventivo(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
                                    else
                                        res = ServiceOrder.registrar_correctivo(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
                                    end
                                    if res[0] == 4
                                        bandera_error = res[0]
                                        id_registro = res[2]
                                        mensaje = res[1]
                                    else
                                        bandera_error = res[0]
                                        mensaje = res[1]
                                    end
                                else
                                    mensaje = "No se encontró el proveedor en el cátalogo de talleres, favor de asignar el proveedor al taller."
                                    bandera_error = 3
                                end
                            else busqueda_enc.ticket_tire_battery_id
                                busqueda_tk = TicketTireBattery.find_by(id:busqueda_enc.ticket_tire_battery_id)
                                res = ServiceOrder.registrar_compra(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
                                if res[0] == 4
                                    busqueda_tk.update(estatus:"Pendiente de entrega")
                                    bandera_error = res[0]
                                    id_registro = res[2]
                                    mensaje = res[1]
                                else
                                    bandera_error = res[0]
                                    mensaje = res[1]
                                end
                            end 
                        end
                    else
                        if busqueda_enc.update(factura: params[:service_order][:factura])
                            if busqueda_enc.catalog_workshop_id
                                if busqueda_enc.catalog_workshop.catalog_vendor_id
                                    if busqueda_enc.tipo_servicio == "Preventivo" or busqueda_enc.tipo_servicio == "Preventivo Agencia"
                                        res = ServiceOrder.registrar_preventivo(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
                                    else
                                        res = ServiceOrder.registrar_correctivo(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
                                    end
                                    if res[0] == 4
                                        bandera_error = res[0]
                                        id_registro = res[2]
                                        mensaje = res[1]
                                    else
                                        bandera_error = res[0]
                                        mensaje = res[1]
                                    end
                                else
                                    mensaje = "No se encontró el proveedor en el cátalogo de talleres, favor de asignar el proveedor al taller."
                                    bandera_error = 3
                                end
                            else busqueda_enc.ticket_tire_battery_id
                                busqueda_tk = TicketTireBattery.find_by(id:busqueda_enc.ticket_tire_battery_id)
                                res = ServiceOrder.registrar_compra(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
                                if res[0] == 4
                                    busqueda_tk.update(estatus:"Pendiente de entrega")
                                    bandera_error = res[0]
                                    id_registro = res[2]
                                    mensaje = res[1]
                                else
                                    bandera_error = res[0]
                                    mensaje = res[1]
                                end
                            end 
                        end
                    end
                else
                    bandera_error = 1
                    mensaje = "El monto ya registrado y el total de la factura no coinciden."
                end
            end
            #byebug
        # rescue Exception => error
        #   mensaje = error
        #   bandera_error = 3
        # end
        return mensaje,bandera_error,id_registro
    end

    def self.registrar_compra(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
        bandera_error = 0
        mensaje = ""
        id_registro = 0

        if  busqueda_enc.ticket_tire_battery.tipo == "Llanta"
            reparacion = CatalogRepair.find_by(subcategoria:"Llantas",status:true)
        elsif busqueda_enc.ticket_tire_battery.tipo == "Batería"
            reparacion = CatalogRepair.find_by(subcategoria:"Baterías",status:true)
        else
            reparacion = CatalogRepair.find_by(subcategoria:"Extintor",status:true)
        end
        iva_importe =  busqueda_enc.precio.to_f * 0.16

        if reparacion
            factura =  MaintenanceControl.new(importe: total_factura, fecha_factura:fecha_factura,importe_iva:iva_importe,impuestos:impuestos,folio_factura:folio_factura_def,uuid:identificador_unico,mes_pago:mes,año:ano,vehicle_id:busqueda_enc.vehicle_id,km_actual: ultimo_km.km_actual,dias_taller: dias_taller,catalog_vendor_id:busqueda_enc.catalog_vendor_id,service_order_id:busqueda_enc.id,tipo:"Compra",catalog_repair_id:reparacion.id,estatus:"Pendiente")
        else
            factura =  MaintenanceControl.new(importe: total_factura, fecha_factura:fecha_factura,importe_iva:iva_importe,impuestos:impuestos,folio_factura:folio_factura_def,uuid:identificador_unico,mes_pago:mes,año:ano,vehicle_id:busqueda_enc.vehicle_id,km_actual: ultimo_km.km_actual,dias_taller: dias_taller,catalog_vendor_id:busqueda_enc.catalog_vendor_id,service_order_id:busqueda_enc.id,tipo:"Compra",estatus:"Pendiente")
        end

        if factura.save
            bandera_error = 4
            id_registro = factura.id
            mensaje = "Documento agregado correctamente, complete los datos para el control de mantenimiento"
        else
            factura.errors.full_messages.each do |error|
            mensaje += " #{error}."
            end
            bandera_error = 3
        end
        return bandera_error,mensaje,id_registro
    end
    
    def self.registrar_correctivo(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
        bandera_error = 0
        mensaje = ""
        id_registro = 0        
        iva_importe =  busqueda_enc.precio.to_f * 0.16
        factura = MaintenanceControl.new(importe: total_factura, fecha_factura:fecha_factura,importe_iva:iva_importe,impuestos:impuestos,folio_factura:folio_factura_def,uuid:identificador_unico,mes_pago:mes,año:ano,catalog_workshop_id:busqueda_enc.catalog_workshop_id,vehicle_id:busqueda_enc.vehicle_id,km_actual: ultimo_km.km_actual,dias_taller: dias_taller,catalog_vendor_id:busqueda_enc.catalog_workshop.catalog_vendor_id,service_order_id:busqueda_enc.id,tipo:"Correctivo",estatus:"Pendiente")
        if factura.save
            bandera_error = 4
            id_registro = factura.id
            mensaje = "Documento agregado correctamente, complete los datos para el control de mantenimiento"
        else
            factura.errors.full_messages.each do |error|
            mensaje += " #{error}."
            end
            bandera_error = 3
        end
        return bandera_error,mensaje,id_registro
    end
    
    def self.registrar_preventivo(busqueda_enc,identificador_unico,fecha_factura,folio_factura_def,mes,ano,dias_taller,ultimo_km,impuestos,total_factura)
        bandera_error = 0
        mensaje = ""
        id_registro = 0
        iva_importe =  busqueda_enc.precio.to_f * 0.16
        factura = MaintenanceControl.new(importe:total_factura, fecha_factura:fecha_factura,importe_iva:iva_importe,impuestos:impuestos,folio_factura:folio_factura_def,uuid:identificador_unico,mes_pago:mes,año:ano,catalog_workshop_id:busqueda_enc.catalog_workshop_id,vehicle_id:busqueda_enc.vehicle_id,km_actual: ultimo_km.km_actual,dias_taller: dias_taller,catalog_vendor_id:busqueda_enc.catalog_workshop.catalog_vendor_id,service_order_id:busqueda_enc.id,tipo:"Preventivo",estatus:"Pendiente")
        if factura.save
            bandera_error = 4
            id_registro = factura.id
            mensaje ="Documento agregado correctamente, complete los datos para el control de mantenimiento"
        else
            factura.errors.full_messages.each do |error|
            mensaje += " #{error}."
            end
            bandera_error = 3
        end
        return bandera_error,mensaje,id_registro
    end

    def self.guardar_bitacora(linea,numero,orden)
        servicios = ServiceOrder.ver_servicios(linea,numero)[0]
            servicios.each do |servicio|
                if servicio[:servicio] != ""
                   registro = BinnacleOrder.create(service_order_id:orden,tipo_afinacion: servicio[:tipo_afinacion],categoria: servicio[:nombre_concepto],concepto:servicio[:accion],tipo_frecuencia:servicio[:tipo],frencuencia_reemplazo: servicio[:frecuencia_r],frecuencia_inspeccion:servicio[:frecuencia_i],servicio:servicio[:servicio])
                end    
            end
    end
    
    def self.crear_pdf(params, encabezado)
      bandera_error = 0
      mensaje = ""
      busqueda_enc = ServiceOrder.find_by(id: encabezado)
      begin
          if busqueda_enc
              if busqueda_enc.update(pdf: params[:service_order][:pdf])
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

    def self.revision_precios(orden)
        if orden.factura.attached?
            #doc = File.open(orden.factura.blob) { |f| Nokogiri::XML(f) }
            doc = Nokogiri::XML(orden.factura.download)
            archivo = Hash.from_xml(doc.to_s)
            hash = archivo["Comprobante"]
            total_factura = hash["Total"].to_f
            impuestos = hash["Impuestos"]["TotalImpuestosTrasladados"].to_f
            uuid = hash["Complemento"]["TimbreFiscalDigital"]["UUID"]
            return (total_factura - impuestos), total_factura, "#{hash["Serie"]}#{hash["Folio"]}", uuid
        else
            return 0, 0, "Sin factura", nil
        end
    end
    
end
