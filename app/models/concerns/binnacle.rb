class Binnacle < ActiveRecord::Base
    enum tipo_frecuencia: ["KM", "Meses", "Horas"]
    enum tipo_afinacion: ["Afinación menor", "Afinación mayor"]
    def readonly?
        true
    end

    def self.servicio_realizar(bitacora,ultimo_km,vehicle_id)
        # ultimo_km puede contener horas o kilometros 
        bandera_retorno = ""
        valor = Parameter.find_by(valor: "Valor para bitacora")
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
        multiplo_reemplazo = 0
        multiplo_insp = 0
        #ultimo_km = 60000
        concept_description =  ConceptServiceDescription.find_by(concept_description_id:bitacora.concept_description_id)

        if ultimo_km > 0 and bitacora.tipo_frecuencia != "Meses"
            if  bitacora.frecuencia_reemplazo != nil
                (1..10).each do |index|
                    mult_r = bitacora.frecuencia_reemplazo.to_f * index 
                    if mult_r >= ultimo_km
                        multiplo_reemplazo = mult_r
                        break
                    end
                end

                if vehiculo.catalog_route.descripcion == "Foraneo"
                    valor_def = multiplo_reemplazo - valor.valor_extendido.to_f
                    if ultimo_km >= valor_def and ultimo_km <= multiplo_reemplazo
                        bandera_retorno = concept_description.concept_service.descripcion
                    end 
                else
                    valor_def = multiplo_reemplazo - bitacora.frecuencia_reemplazo.to_f
                    val = valor_def + valor.valor_extendido.to_f
                    if ultimo_km >= valor_def and ultimo_km <= val
                        bandera_retorno = concept_description.concept_service.descripcion
                    end
                end
            end
            if bitacora.frecuencia_inspeccion != nil
                (1..10).each do |index|
                    mult_i = bitacora.frecuencia_inspeccion.to_f * index 
                    if mult_i >= ultimo_km.to_f
                        multiplo_insp = mult_i
                        break
                    end
                end

                if vehiculo.catalog_route.descripcion == "Foraneo"
                    valor_def = multiplo_insp - valor.valor_extendido.to_f
                    if ultimo_km >= valor_def and ultimo_km <= multiplo_insp
                        bandera_retorno = "Inspección"
                    end 
                else
                    valor_def = multiplo_insp - bitacora.frecuencia_inspeccion.to_f
                    val = valor_def + valor.valor_extendido.to_f
                    if ultimo_km >= valor_def and ultimo_km <= val
                        bandera_retorno = "Inspección"
                    end
                end
            end
        elsif  bitacora.tipo_frecuencia == "Meses"
            if ((bitacora.fecha != nil and bitacora.frecuencia_inspeccion != nil) or  bitacora.frecuencia_reemplazo)
                if bitacora.frecuencia_inspeccion != nil 
                    bandera_retorno =   self.validar_fecha(bitacora.fecha, bitacora.frecuencia_inspeccion,bitacora.concept_description_id,fecha_validacion)
                end
                if bitacora.frecuencia_reemplazo != nil
                    bandera_retorno =  self.validar_fecha(bitacora.fecha, bitacora.frecuencia_reemplazo,bitacora.concept_description_id,fecha_validacion)
                end
            end
        end 
            return bandera_retorno 
    end
    
    def self.validar_fecha(fecha, frecuencia, id,fecha_validacion)
        meses_transcurridos = (((Time.zone.now.to_date - fecha.to_date ).to_f / 365 * 12).round - 1)
        periodos_transcurridos = meses_transcurridos/frecuencia
        meses_transcurridos_periodo = periodos_transcurridos * frecuencia
       fecha_servicio =  fecha.to_date + meses_transcurridos_periodo.to_i.month
       if fecha_servicio.strftime('%y-%m') == Time.zone.now.to_date.strftime('%y-%m') or fecha_validacion <= Time.zone.now.to_date
          concept_description =  ConceptServiceDescription.find_by(concept_description_id:id)
          return   concept_description.concept_service.descripcion
       end
        
    end

    def self.ver_servicios(vehicle_id,km_actual) 
        begin
           bandera_error = 0
           res_servicios = []
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
           @conceptos = Concept.where(estatus:true)
           @conceptos.each do |concepto|
           @bitacora = Binnacle.where(concept_id:concepto.id, catalog_brand_id: vehiculo.catalog_brand_id)
           
           if @bitacora != []
               @bitacora.each do |bi|
                   multiplo_reemplazo = 0
                   multiplo_insp = 0
                #    if vehiculo.numero_economico == "588" or vehiculo.numero_economico == "610"
                #         byebug
                #     end
                   if bi.tipo_frecuencia == "KM" or bi.tipo_frecuencia == "Horas"
                       

                       if  bi.frecuencia_reemplazo != nil
                           (1..100000).each do |index|
                               mult_r = bi.frecuencia_reemplazo.to_f * index 
                               if mult_r >= km_actual.to_f
                                   multiplo_reemplazo = mult_r
                                   break
                               end
                           end
                           if vehiculo.catalog_route.descripcion == "Foraneo"
                           
                               valor_def = multiplo_reemplazo - valor.valor_extendido.to_f
                               if km_actual.to_f >= valor_def and km_actual.to_f <= multiplo_reemplazo
                                   servicio_realizar = true
                               else
                                   servicio_realizar = false
                               end 
                               
                           else
                               valor_def = multiplo_reemplazo - bi.frecuencia_reemplazo.to_f
                               val = valor_def + valor.valor_extendido.to_f
                               if km_actual.to_f >= valor_def and km_actual.to_f <= val
                                   servicio_realizar = true
                               else
                                   servicio_realizar = false
                               end
                           end
                       end

                       if bi.frecuencia_inspeccion != nil
                           (1..100000).each do |index|
                               mult_i = bi.frecuencia_inspeccion.to_f * index 
                                   if mult_i >= km_actual.to_f
                                       multiplo_insp = mult_i
                                       break
                                   end
                           end
                           if vehiculo.catalog_route.descripcion == "Foraneo"
                               valor_def = multiplo_insp - valor.valor_extendido.to_f
                               if km_actual.to_f >= valor_def and km_actual.to_f <= multiplo_insp
                                   servicio_realizar = true
                               else
                                   servicio_realizar = false
                               end 
                           else
                               valor_def = multiplo_insp - bi.frecuencia_inspeccion.to_f
                               val = valor_def + valor.valor_extendido.to_f
                               if km_actual.to_f >= valor_def and km_actual.to_f <= val
                                   servicio_realizar = true
                               else
                                   servicio_realizar = false
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
                           fecha_servicio = bi.fecha.to_date + meses_transcurridos_periodo.months
                           end
                           if fecha_servicio.strftime('%y-%m') == Time.zone.now.to_date.strftime('%y-%m')
                               servicio_realizar = true
                           elsif fecha_validacion <= Time.zone.now.to_date
                               servicio_realizar = true
                           else
                           servicio_realizar = false
                           end
                       else
                           meses_transcurridos = (((Time.zone.now.to_date - bi.fecha.to_date ).to_f / 365 * 12).round -1)
                           periodos_transcurridos = meses_transcurridos/bi.frecuencia_inspeccion
                           meses_transcurridos_periodo = periodos_transcurridos * bi.frecuencia_inspeccion
                           if meses_transcurridos == 0 or meses_transcurridos <=0
                           fecha_servicio = bi.fecha
                           else
                           fecha_servicio = bi.fecha.to_date + meses_transcurridos_periodo.months
                           end
                           if fecha_servicio.strftime('%y-%m') == Time.zone.now.to_date.strftime('%y-%m')
                           servicio_realizar = true
                           elsif fecha_validacion <= Time.zone.now.to_date
                           servicio_realizar = true
                           else
                               servicio_realizar = false
                           end
                       end
                   end
                   #arreglo con puros servicios
                   if servicio_realizar != false
                        res_servicios.push(servicio_realizar)  
                   end
               end
           end
       end
   rescue => exception
       bandera_error = 3
       mensaje = "Ocurrio un error, favor de contactar soporte. Error:#{exception}"
       puts mensaje
   end
       return res_servicios
   end

end