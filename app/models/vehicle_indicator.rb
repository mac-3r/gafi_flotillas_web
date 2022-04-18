class VehicleIndicator < ApplicationRecord
  belongs_to :vehicle_type

  def get_status
    return self.status ? "Activo" : "Inactivo"
  end
  
  def self.listado_indicador
    VehicleIndicator.all
  end

  def self.get_month_week(date_or_time, start_day = :sunday)

    date = date_or_time.to_date
    week_start_format = start_day == :sunday ? '%U' : '%W'
  
    month_week_start = Date.new(date.year, date.month, 1)
    month_week_start_num = month_week_start.strftime(week_start_format).to_i
    month_week_start_num += 1 if month_week_start.wday > 4 # Skip first week if doesn't contain a Thursday
  
    month_week_index = date.strftime(week_start_format).to_i - month_week_start_num
    month_week_index + 1 # Add 1 so that first week is 1 and not 0
  
  end

  def self.correo_siniestros_x_mes(fecha_inicio = Time.zone.now.to_date.beginning_of_month,fecha_fin = (Time.zone.now.to_date).end_of_month)
    #if Time.zone.now.to_date.end_of_month == Time.zone.now.to_date
      valor = ""
      contador = 0
      parametro = Parameter.find_by(valor: "correos gerente cedis")
      rol = CatalogRole.find_by(clave: parametro.valor_extendido)
      usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
      usuarios_gerentes.each do |user|
        contador += 1
        #IndicatorMailer.siniestros_x_mes(fecha_inicio,fecha_fin,user).deliver_later(wait: (20 * contador).seconds) if contador == 1
        IndicatorMailer.siniestros_x_mes(fecha_inicio,fecha_fin,user).deliver_now
      end
    #end
  end

  # def self.cantidad_siniestros_x_cedis(fecha_inicio = Time.zone.now.to_date.beginning_of_month,fecha_fin = (Time.zone.now.to_date).end_of_month)
  #   if Time.zone.now.to_date.end_of_month == Time.zone.now.to_date
  #     valor = ""
  #     contador = 0
  #     parametro = Parameter.find_by(valor: "correos gerente cedis")
  #     rol = CatalogRole.find_by(clave: parametro.valor_extendido)
  #     usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
  #     usuarios_gerentes.each do |user|
  #       contador += 1
  #       IndicatorMailer.cantidad_siniestros_x_cedis(user).deliver_later(wait: (20 * contador).seconds)
  #     end
  #   end
  # end

  def self.cantidad_siniestros_x_cedis(fecha_inicio = Time.zone.now.to_date.beginning_of_month,fecha_fin = (Time.zone.now.to_date).end_of_month)
    if Time.zone.now.to_date.end_of_month == Time.zone.now.to_date
      valor = ""
      contador = 0
      parametro = Parameter.find_by(valor: "correos gerente cedis")
      rol = CatalogRole.find_by(clave: parametro.valor_extendido)
      usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
      usuarios_gerentes.each do |user|
        contador += 1
        #IndicatorMailer.cantidad_siniestros_x_cedis(user).deliver_later(wait: (20 * contador).seconds)
        IndicatorMailer.cantidad_siniestros_x_cedis(user).deliver_later
      end
    end
  end

  def self.cantidad_siniestros_x_responsable(fecha_inicio = Time.zone.now.to_date.beginning_of_month,fecha_fin = (Time.zone.now.to_date).end_of_month)
    if Time.zone.now.to_date.end_of_month == Time.zone.now.to_date
      valor = ""
      contador = 0
      parametro = Parameter.find_by(valor: "correos gerente cedis")
      rol = CatalogRole.find_by(clave: parametro.valor_extendido)
      usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
      resultados = InsuranceReportTicket.consulta_siniestros_indicador
      usuarios_gerentes.each do |user|
        contador += 1
        IndicatorMailer.cantidad_siniestros_x_responsable(resultados,user).deliver_later
      end
    end
  end

  def self.correo_monto_siniestros_x_mes(fecha_inicio = Time.zone.now.to_date.beginning_of_month,fecha_fin = (Time.zone.now.to_date).end_of_month)
    if Time.zone.now.to_date.end_of_month == Time.zone.now.to_date
      valor = ""
      contador = 0
      parametro = Parameter.find_by(valor: "correos gerente cedis")
      rol = CatalogRole.find_by(clave: parametro.valor_extendido)
      usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
      usuarios_gerentes.each do |user|
        contador += 1
        IndicatorMailer.monto_siniestros_x_mes(user).deliver_later
      end
    end
  end

  def self.correo_incidencias_responsable_siniestro(fecha_inicio = Time.zone.now.to_date.beginning_of_month,fecha_fin = Time.zone.now.to_date.end_of_month)
    if Time.zone.now.to_date.end_of_month == Time.zone.now.to_date
      valor = ""
      contador = 0
      parametro = Parameter.find_by(valor: "correos gerente cedis")
      rol = CatalogRole.find_by(clave: parametro.valor_extendido)
      usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
      usuarios_gerentes.each do |user|
          cedis = CatalogBranchesUser.where(user_id: user.id)
          cedis.each do |suc|
              cedis_id = suc.catalog_branch_id
              ticket = InsuranceReportTicket.consulta_responsable(valor,cedis_id,valor,fecha_inicio.to_date,fecha_fin.to_date,valor,valor, valor)
              responsables = ResponsibleReportResponsible.responsables_matriz(fecha_inicio.to_date,fecha_fin.to_date,cedis_id,valor, valor)
              #if responsables != [] and ticket != [[],[]]
                  contador += 1
                  IndicatorMailer.correo_incidencias_responsable_siniestro(ticket, responsables,user).deliver_later
              #end
          end
      end
    end
  end

  def self.consulta_siniestros_indicador_correo(fecha_inicio = Time.zone.now.to_date.beginning_of_month,fecha_fin = Time.zone.now.to_date.end_of_month)

    if Time.zone.now.to_date.end_of_month == Time.zone.now.to_date
      empresa = ""
      responsabilidad = "Todos"
      area = ""
      vehiculo = ""
      @bandera_error = false
      parametro = Parameter.find_by(valor: "correos gerente cedis")
      rol = CatalogRole.find_by(clave: parametro.valor_extendido)
      usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
      contador = 0
      usuarios_gerentes.each do |user|
          cedis = CatalogBranchesUser.where(user_id: user.id)
          cedis.each do |suc|
              contador += 1
              cedis_id = suc.catalog_branch_id
              @resultados = InsuranceReportTicket.consulta_siniestros_indicador_correo(empresa,cedis_id,responsabilidad,area,vehiculo,fecha_inicio,fecha_fin)
              #byebug
              if !@resultados.nil?
                IndicatorMailer.correo_indicador_siniestros_cedis(@resultados,user).deliver_late
              end
          end
      end
      if @resultados == []
        @mensaje = "No se encontró información."
        @bandera_error = true
      end
    end
  end

  def self.correo_monto_siniestrada(fecha_inicio,fecha_fin)
    if Time.zone.now.to_date.end_of_month == Time.zone.now.to_date
      @bandera_error = false
      parametro = Parameter.find_by(valor: "correos gerente cedis")
      rol = CatalogRole.find_by(clave: parametro.valor_extendido)
      usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
      usuarios_gerentes.each do |user|
          cedis = CatalogBranchesUser.where(user_id: user.id)
          cedis.each do |suc|
              cedis_id = suc.catalog_branch_id
              IndicatorMailer.indicador_monto_siniestrada_correo( suc.catalog_branch.catalog_company_id,cedis_id, fecha_inicio, fecha_fin, "", "",user).deliver_later
          end
      end
    end
      #@grafica = DamagedVehicleAmmount.grafica_indicadores_monto(session["empresa_dva"], session["cedis_dva"], session["fechaini_dva"], session["fechafin_dva"], session["area_dva"], session["vehiculo_dva"])
      #@tabla = DamagedVehicleResponsible.tabla_indicadores_monto(session["empresa_dva"], session["cedis_dva"], session["fechaini_dva"], session["fechafin_dva"], session["area_dva"], session["vehiculo_dva"])
      #byebug
  end

def self.correo_flotilla_siniestrada(fecha_inicio,fecha_fin)
    @bandera_error = false
    parametro = Parameter.find_by(valor: "correos gerente cedis")
    rol = CatalogRole.find_by(clave: parametro.valor_extendido)
    usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
    usuarios_gerentes.each do |user|
        cedis = CatalogBranchesUser.where(user_id: user.id)
        cedis.each do |suc|
            cedis_id = suc.catalog_branch_id
            @tabla2 = DamagedVehicleResponsible.tabla_indicadores_daniados(suc.catalog_branch.catalog_company_id,cedis_id,fecha_inicio,fecha_fin, "", "")
            arreglo = []
            @tabla = []
            @tabla2.each do |tab|
                hash_ren = {}
                hash_ren = Vehicle.joins(:catalog_branch).where(catalog_branches:{decripcion: tab.sucursal}).count
                calculo = tab.total * 100 / hash_ren
                arreglo << hash_ren
                @tabla.push({sucursal: tab.sucursal,cantidad: tab.cantidad,total:tab.total,vehiculos:hash_ren,total_v:calculo})
            end
            if @tabla != []
                IndicatorMailer.indicador_flotilla_siniestrada_correo(@tabla,user).deliver_later
            end
        end
    end
    
end
# VehicleIndicator.correo_indicador_vehiculos_dentro_rendimiento('2021-12-01','2021-12-31')
def self.correo_indicador_vehiculos_dentro_rendimiento(fecha_inicio,fecha_final)
    @indicador = Array.new
    @arreglo = []
    @arreglo_ren = []
    @bandera_error = false
    cedis = ""
    compania = ""
    @resultados = []

    fecha_inicio_anterior = fecha_inicio.to_date - 1.month
    fecha_final_anterior = fecha_inicio_anterior.end_of_month
    @total_grafica = 0
    @buen_grafica = 0
    @percentaje_grafica = 0
    parametro = Parameter.find_by(valor: "correos gerente cedis")
    rol = CatalogRole.find_by(clave: parametro.valor_extendido)
    usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
    usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
            cedis_id = suc.catalog_branch_id
                #query = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento").where(vehicles:{catalog_branch_id:cedis_id, reparto: true}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
                query = VehicleConsumption.find_by_sql("select vehicle_id, max(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then odometro end) as cierre,
                max(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then odometro end) -
                max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end) as recorrido,
                sum(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then cantidad end) as lts,
                ((max(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then odometro end) -
                max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento
                from vehicle_consumptions INNER JOIN vehicles ON vehicles.id = vehicle_consumptions.vehicle_id 
                INNER JOIN consumptions ON consumptions.id = vehicle_consumptions.consumption_id
                where vehicles.reparto = true and consumptions.id IS NOT NULL and vehicles.catalog_branch_id = #{cedis_id} group by vehicle_id,numero_economico order by vehicles.numero_economico")
                #query = VehicleConsumption.joins(:vehicle).select("vehicle_id","((max(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento").where(vehicles:{catalog_branch_id:cedis_id, reparto: true}).group(:vehicle_id)
                cumple = 0
                no_cumple = 0
                query.each do |que|
                    rendimiento_i = que.vehicle.vehicle_type
                    #rendimiento_i = VehicleType.find_by(id: que.tipo)
                    # if suc.catalog_branch_id == 8
                    #   byebug
                    # end
                    if rendimiento_i.rendimiento_ideal != nil
                      if que.rendimiento.to_f < rendimiento_i.rendimiento_ideal
                        #if que.rendimiento.to_f >= rendimiento_i.rendimiento_ideal
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
                @resultados.push(cedis: suc.catalog_branch.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje.round(2))
            end
        if @resultados != []
            IndicatorMailer.indicador_vehiculos_dentro_rendimiento(@resultados,user).deliver_later
        end
        
    end
end

def self.correo_reporte_acumulado(fecha_inicio,fecha_final)
    parametro = Parameter.find_by(valor: "correos gerente cedis")
    rol = CatalogRole.find_by(clave: parametro.valor_extendido)
    usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
    usuarios_gerentes.each do |user|
        cedis = CatalogBranchesUser.where(user_id: user.id)
        cedis.each do |suc|
            IndicatorMailer.reporte_combustible_acumulado(fecha_inicio.to_date,fecha_final.to_date,suc.catalog_branch,user).deliver_later
        end
    end
end

def self.correo_reporte_reparto(fecha_inicio,fecha_final)  
    fecha_inicio_anterior = fecha_inicio.to_date - 1.month
    fecha_final_anterior = fecha_inicio_anterior.end_of_month
    parametro = Parameter.find_by(valor: "correos gerente cedis")
    rol = CatalogRole.find_by(clave: parametro.valor_extendido)
    usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
    usuarios_gerentes.each do |user|
        cedis = CatalogBranchesUser.where(user_id: user.id)
        cedis.each do |suc|
            IndicatorMailer.reporte_mensual_reparto(fecha_inicio.to_date,fecha_final.to_date,fecha_inicio_anterior,fecha_final_anterior,suc.catalog_branch,user).deliver_later
        end
    end
end

def self.notificar_gerente
    responsables = Vehicle.select('catalog_branch_id','responsable_id').group(:catalog_branch_id, :responsable_id)
    responsables.each do |res|
        if res.responsable_id
          dato = Responsable.find_by(id:res.responsable_id)
          if dato.catalog_personal_id
              if dato.catalog_personal.correo != ""
                IndicatorMailer.correo_responsivas(dato,res.catalog_branch_id).deliver_later
              end
          end  
        end
    end
end

#anual
def self.correo_indicador_presupuesto
    anio = Date.today.year
    anio_anterior = anio - 1
    parametro = Parameter.find_by(valor: "correos gerente cedis")
    rol = CatalogRole.find_by(clave: parametro.valor_extendido)
    usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
    usuarios_gerentes.each do |user|
        cedis = CatalogBranchesUser.where(user_id: user.id)
        cedis.each do |suc|
            IndicatorMailer.indicador_presupuesto_correo(anio,anio_anterior,suc.catalog_branch,user).deliver_later
        end
    end
end

def self.correo_indicador_km
    anio = Date.today.year
    parametro = Parameter.find_by(valor: "correos gerente cedis")
    rol = CatalogRole.find_by(clave: parametro.valor_extendido)
    usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
    usuarios_gerentes.each do |user|
        cedis = CatalogBranchesUser.where(user_id: user.id)
        cedis.each do |suc|
            IndicatorMailer.indicador_combustible_km(anio,suc.catalog_branch,user).deliver_later
        end
    end
end
  
end
