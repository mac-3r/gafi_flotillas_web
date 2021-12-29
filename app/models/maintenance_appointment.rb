class MaintenanceAppointment < ApplicationRecord
  belongs_to :vehicle
  belongs_to :catalog_workshop,optional: true
  enum status: ["Pendiente de confirmar", "Cita confirmada","Cita reasignada","Cita cancelada"]

  def self.consulta_citas(vehiculo,empresa,cedis,user,tipo,linea,area)
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
      cadena_consulta += " maintenance_appointments.fecha_cita between '#{Time.now.beginning_of_year.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")}'"
        consulta = MaintenanceAppointment.joins(:vehicle).where(cadena_consulta)
      return consulta  
  end

end
