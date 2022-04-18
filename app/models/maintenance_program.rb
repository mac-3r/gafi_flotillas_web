class MaintenanceProgram < ApplicationRecord
  belongs_to :vehicle
  belongs_to :maintenance_frecuency
  has_many :service_orders

  def self.importar_programa(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(2)
    arreglo_errores = Array.new
    (3..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      begin
        if row["No. Econ."] == 532
          byebug
        end
        if row["Frecuencia de mmto. (kms) **"] == ""
          arreglo_errores.push(linea: i, error: "No se capturó frecuencia de mantenimiento")
          next
        end
        if row["No. Econ."] == ""
          arreglo_errores.push(linea: i, error: "No se capturó número económico")
          next
        end
        if row["Fecha"] == ""
          arreglo_errores.push(linea: i, error: "No se capturó fecha de última afinación")
          next
        end
        if row["Kms ult. Afinación"] == ""
          arreglo_errores.push(linea: i, error: "No se capturó kilometros de última afinación")
          next
        end
        if row["Fecha max"] == ""
          arreglo_errores.push(linea: i, error: "No se capturó fecha maxima de proximo servicio")
          next
        end
        if row["Kms prox. Servicio"] == ""
          arreglo_errores.push(linea: i, error: "No se capturó kilometros para proximo servicio")
          next
        end
        if row["Fecha aproximada\npara sig. servicio"] == ""
          arreglo_errores.push(linea: i, error: "No se capturó fecha aproximada para próximo servicio")
          next
        end
        if row["Kilometraje con el que termina la semana"] == ""
          arreglo_errores.push(linea: i, error: "No se capturó kilometraje con el que termina la semana")
          next
        end
        consulta_vehiculo = Vehicle.find_by(numero_economico: row["No. Econ."])
        if !consulta_vehiculo
          arreglo_errores.push(linea: i, error: "No se encontró vehículo con el número económico #{row["No. Econ."]}")
          next
        end
        consulta_frecuencia = MaintenanceFrecuency.find_by(frecuencia: row["Frecuencia de mmto. (kms) **"], vehicle_type_id: consulta_vehiculo.vehicle_type_id, catalog_model_id: consulta_vehiculo.catalog_model_id)
        if !consulta_frecuencia
          arreglo_errores.push(linea: i, error: "No se encontró frecuencia de mantenimiento para el vehículo con número económico #{row["No. Econ."]}")
          next
        end
        consulta_programa = MaintenanceProgram.find_by(vehicle_id: consulta_vehiculo.id, maintenance_frecuency_id: consulta_frecuencia.id)
        if consulta_programa
          #byebug
          if consulta_programa.update(frecuencia_mantenimiento: row["Frecuencia de mmto. (kms) **"], fecha_ultima_afinacion: row["Fecha"], kms_ultima_afinacion: row["Kms ult. Afinación"], fecha_proximo: row["Fecha aproximada\npara sig. servicio"], kms_proximo_servicio: row["Kms prox. Servicio"], km_actual: row["Kilometraje con el que termina la semana"])
            
          else
            mensaje = ""
            consulta_programa.errors.full_messages.each do |error|
              mensaje += "#{error}. "
            end
            arreglo_errores.push(linea: i, error: "#{mensaje}")
          end
          #byebug
        else
          programa = MaintenanceProgram.new(maintenance_frecuency_id: consulta_frecuencia.id, vehicle_id: consulta_vehiculo.id, km_inicio_ano: 0, km_recorrido_curso: row["Kilometraje con el que termina la semana"], promedio_mensual: 0, frecuencia_mantenimiento: row["Frecuencia de mmto. (kms) **"], fecha_ultima_afinacion: row["Fecha"], kms_ultima_afinacion: row["Kms ult. Afinación"], fecha_proximo: row["Fecha aproximada\npara sig. servicio"], kms_proximo_servicio: row["Kms prox. Servicio"], km_actual: row["Kilometraje con el que termina la semana"])
          if programa.save
            
          else
            mensaje = ""
            programa.errors.full_messages.each do |error|
              mensaje += "#{error}. "
            end
            arreglo_errores.push(linea: i, error: "#{mensaje}")
          end
        end
      rescue Exception => e
        arreglo_errores.push(linea: i, error: "#{e}")
      end
    end
    if arreglo_errores.length > 0
      return arreglo_errores
    else
      return nil
    end
  end
  
  
  def self.busqueda_tolerancia(valor)
    fecha_actual= Date.today
    fecha_8_dias = Date.today + 8.day
    fecha_15_dias = Date.today + 15.day
    
    if valor == "1"
      consulta = MaintenanceProgram.where(fecha_proximo:fecha_15_dias)
    elsif valor == "2"
      consulta = MaintenanceProgram.where(fecha_proximo:fecha_8_dias)
    elsif valor == "3"
      consulta = MaintenanceProgram.where("fecha_proximo > ?", fecha_actual)
    end
    #byebug
		return consulta 
  end

  def self.consulta_programas(vehiculo,empresa,cedis,user,tipo,linea,area)
    cadena_consulta = ""
    
      if vehiculo != ""
        cadena_consulta += " vehicles.id = #{vehiculo} and"
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
      cadena_consulta += " vehicles.vehicle_type_id != 6 and vehicles.vehicle_type_id != 11 and"
      cadena_consulta += " maintenance_programs.created_at <= '#{(Time.now + 1.day).strftime("%Y-%m-%d %H:%M:%M")}'"
        consulta = MaintenanceProgram.joins(:vehicle).where(cadena_consulta)
      return consulta  
  end

end
