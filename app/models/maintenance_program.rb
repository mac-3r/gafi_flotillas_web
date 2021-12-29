class MaintenanceProgram < ApplicationRecord
  belongs_to :vehicle
  belongs_to :maintenance_frecuency
  has_many :service_orders
  
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
      cadena_consulta += " maintenance_programs.created_at <= '#{(Time.now + 1.day).strftime("%Y-%m-%d %H:%M:%M")}'"
        consulta = MaintenanceProgram.joins(:vehicle).where(cadena_consulta)
      return consulta  
  end

end
