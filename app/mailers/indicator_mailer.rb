class IndicatorMailer < ApplicationMailer

    def correo_incidencias_responsable_siniestro(ticket, responsables,usuario)
      if ticket != nil and responsables != nil
        @ticket = ticket
        @responsables = responsables
        mail(to: usuario.email, subject: 'Reporte de incidencias por responsable de siniestro', cc: "no_replay_flotillas@gafi.com.mx")
      end
    end

    def siniestros_x_mes(fecha_inicio,fecha_fin,usuario)
      @resultados = InsuranceReportTicket.where(fecha_ocurrio: fecha_inicio..fecha_fin)
      #mail(to: 'jeros@apbsoluciones.com', subject: "Siniestralidad del mes de #{I18n.l(Time.zone.now.to_date,format: '%B')} #{Time.zone.now.to_date.strftime("%Y")}")
      mail(to: usuario.email, subject: "Siniestralidad del mes de #{I18n.l(Time.zone.now.to_date,format: '%B')} #{Time.zone.now.to_date.strftime("%Y")}", cc: "no_replay_flotillas@gafi.com.mx")
    end

    def cantidad_siniestros_x_responsable(resultado,usuario)
      @resultados = resultado
      #mail(to: 'jeros@apbsoluciones.com', subject: "Reporte de incidencias por responsable de siniestro")
      mail(to: usuario.email, subject: "Reporte de incidencias por responsable de siniestro", cc: "no_replay_flotillas@gafi.com.mx")
    end

    def licencias_x_expirar
      @licencias = CatalogLicence.licencias_expirar("","","","")
      mail(to: 'jeros@apbsoluciones.com', subject: "Reporte de licencias por expirar", cc: "no_replay_flotillas@gafi.com.mx")
      #mail(to: usuario.email, subject: "Reporte de licencias por expirar")
    end

    def monto_siniestros_x_mes(usuario)
      hoy = Time.zone.now.to_date
      
      if hoy.month.to_i >= 10
        fecha_inicio = Date.new(Time.zone.now.year.to_i, 10, 16)
        fecha_fin = Date.new(Time.zone.now.year.to_i + 1, 10, 15)
      else
        fecha_inicio = Date.new(Time.zone.now.year.to_i - 1, 10, 16)
        fecha_fin = Date.new(Time.zone.now.year.to_i, 10, 15)
      end
        @tabla = DamagedVehicleResponsible.tabla_indicadores_monto("", "", fecha_inicio, fecha_fin, "", "")
      #mail(to: 'jeros@apbsoluciones.com', subject:"Monto de siniestralidad del mes de #{I18n.l(fecha_inicio,format: '%B')} #{fecha_inicio.strftime("%Y")} - #{I18n.l(Time.zone.now.to_date,format: '%B')} #{Time.zone.now.to_date.strftime("%Y")}")
      mail(to: usuario.email, subject:"Monto de siniestralidad del mes de #{I18n.l(fecha_inicio,format: '%B')} #{fecha_inicio.strftime("%Y")} - #{I18n.l(Time.zone.now.to_date,format: '%B')} #{Time.zone.now.to_date.strftime("%Y")}", cc: "no_replay_flotillas@gafi.com.mx")
    end

    def cantidad_siniestros_x_cedis(usuario)
      hoy = Time.zone.now.to_date
      
      if hoy.month.to_i >= 10
        fecha_inicio = Date.new(Time.zone.now.year.to_i, 10, 16)
        fecha_fin = Date.new(Time.zone.now.year.to_i + 1, 10, 15)
      else
        fecha_inicio = Date.new(Time.zone.now.year.to_i - 1, 10, 16)
        fecha_fin = Date.new(Time.zone.now.year.to_i, 10, 15)
      end
      @resultados = InsuranceReportTicket.consulta_siniestros_indicador
      #mail(to: 'jeros@apbsoluciones.com', subject:"Cantidad de siniestros por CEDIS de #{I18n.l(fecha_inicio,format: '%B')} #{fecha_inicio.strftime("%Y")} - #{I18n.l(Time.zone.now.to_date,format: '%B')} #{Time.zone.now.to_date.strftime("%Y")}")
      mail(to: usuario.email, subject:"Cantidad de siniestros por CEDIS de #{I18n.l(fecha_inicio,format: '%B')} #{fecha_inicio.strftime("%Y")} - #{I18n.l(Time.zone.now.to_date,format: '%B')} #{Time.zone.now.to_date.strftime("%Y")}", cc: "no_replay_flotillas@gafi.com.mx")
    end

    def correo_indicador_siniestros_cedis(resultados,usuario)
      if resultados != nil and resultados != []
          @resultados = resultados
          #mail(to: 'jeros@apbsoluciones.com', subject: 'Indicador siniestros por CEDIS')
          mail(to: usuario.email, subject: 'Indicador siniestros por CEDIS', cc: "no_replay_flotillas@gafi.com.mx")
        end
    end
    
    def indicador_monto_siniestrada_correo(empresa_dva, cedis_dva, fechaini_dva, fechafin_dva, area_dva, vehiculo_dva,usuario)
      @tabla = DamagedVehicleResponsible.tabla_indicadores_monto(empresa_dva, cedis_dva, fechaini_dva, fechafin_dva, area_dva, vehiculo_dva)
      if @tabla != []
        mail(to: usuario.email, subject: 'Indicador monto flotilla siniestrada', cc: "no_replay_flotillas@gafi.com.mx")
      end
    end
    
    def indicador_flotilla_siniestrada_correo(tabla,usuario)
        @tabla = tabla
        mail(to: usuario.email, subject: 'Indicador flotilla siniestrada', cc: "no_replay_flotillas@gafi.com.mx")
    end
    
    def indicador_vehiculos_dentro_rendimiento(resultados,usuario)
        @resultados = resultados
        mail(to: usuario.email, subject: 'Indicador de vehículos dentro de rendimiento', cc: "no_replay_flotillas@gafi.com.mx")
    end

    def reporte_combustible_acumulado(fecha_i,fecha_f,cedis,usuario)
        @nombre_cedis = cedis.decripcion
        @mes = I18n.l(fecha_i,format: '%B')
        @resultados = VehicleConsumption.joins(:consumption).where("vehicle_consumptions.fecha between '#{fecha_i.strftime('%Y-%m-%d')}' and '#{fecha_f.strftime('%Y-%m-%d')}' and consumptions.estatus != 0 and consumptions.catalog_branch_id = #{cedis.id}")
        if @resultados != []
          mail(to: usuario.email, subject: "Reporte de control de combustible acumulado #{@nombre_cedis}", cc: "no_replay_flotillas@gafi.com.mx")    
        end
    end

    def reporte_mensual_reparto(fecha_i,fecha_f,fecha_i_ant,fecha_f_ant,cedis,usuario)
      @nombre_cedis = cedis.decripcion
      @mes = I18n.l(fecha_i,format: '%B')
      @resultados = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_i.strftime("%Y-%m-%d")}' and '#{fecha_f.strftime("%Y-%m-%d")}' then odometro end) - max(case when fecha between '#{fecha_i_ant.strftime("%Y-%m-%d")}' and '#{fecha_f_ant.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_i.strftime("%Y-%m-%d")}' and '#{fecha_f.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento").where(vehicles:{reparto: true,catalog_branch_id:cedis.id}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
      #byebug
      mail(to: usuario.email, subject: "Reporte de rendimientos mensual de reparto #{@nombre_cedis}", cc: "no_replay_flotillas@gafi.com.mx")
    end

    def correo_responsivas(responsable,branch_id)
      @nombre = responsable.nombre
      @listado = Vehicle.where(catalog_branch_id:branch_id, responsable_id: responsable).order(:numero_economico)
      mail(to: responsable.catalog_personal.correo, subject: 'Responsivas', cc: "no_replay_flotillas@gafi.com.mx")
    end

    #anual
    def indicador_presupuesto_correo(anio,anio_anterior,cedis,usuario)
        @resultados = Array.new
        @nombre_cedis = cedis.decripcion
        cumple = 0
        no_cumple = 0
        query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_branch_id as cedis","(sum(case when fecha between '#{anio_anterior}-01-01' and '#{anio_anterior}-12-31' then monto end) * 1.05) as presupuesto_anterior","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end) * 1.05) as presupuesto_actual","(sum(case when fecha between '#{anio}-01-01' and '#{anio}-12-31' then cantidad end)) as litros_actual").where(vehicles:{catalog_branch_id:cedis.id}).group(:vehicle_id,:catalog_branch_id)
        query.each do |que|
           if que.presupuesto_actual.to_f >= que.presupuesto_anterior.to_f 
              combustible = FuelBudget.find_by(vehicle_id: que.vehicle_id)
              if combustible
                if que.litros_actual.to_f >= combustible.litros.to_f
                  cumple += 1
                else
                  no_cumple += 1
                end
              end
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
        @resultados.push(cedis: cedis.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje)    
        mail(to: usuario.email, subject: "Reporte de vehículos fuera de presupuesto #{@nombre_cedis}", cc: "no_replay_flotillas@gafi.com.mx")
    end
    #anual
    def indicador_combustible_km(anio,cedis,usuario)
        cumple = 0
        no_cumple = 0
        @resultados = Array.new
        @nombre_cedis = cedis.decripcion
        query = VehicleConsumption.joins(:vehicle).select("vehicle_id","catalog_brand_id as linea","catalog_branch_id as cedis","sum(CASE WHEN fecha between '#{anio}-01-01' and '#{anio}-12-31' then monto end)/sum(CASE WHEN fecha between '#{anio}-01-01' and '#{anio}-12-31' then odometro end) as gasto").where(vehicles:{catalog_branch_id:cedis.id}).group(:vehicle_id,:catalog_branch_id,:catalog_brand_id)
        query.each do |que|
          objetivo_gasto = ExpenseVehicleType.find_by(catalog_branch_id: que.cedis,catalog_brand_id:que.linea)
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
        @resultados.push(cedis: cedis.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje)
        mail(to: usuario.email, subject: "Reporte objetivo del gasto por km #{@nombre_cedis}", cc: "no_replay_flotillas@gafi.com.mx")
    end
    
    def correo_programa_mantenimiento_usuario
      
    end

    def correo_programa_mantenimiento_gerente
      
    end
    
    
end