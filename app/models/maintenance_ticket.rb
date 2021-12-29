class MaintenanceTicket < ApplicationRecord
  belongs_to :vehicle
  enum estatus:["Cancelado","Pendiente","Rechazado", "Autorizado"]

  def self.consulta_tickets(empresa,cedis,user,tipo,linea,area)
    cadena_consulta = ""

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
      cadena_consulta += " maintenance_tickets.created_at <= '#{(Time.now + 1.day).strftime("%Y-%m-%d %H:%M:%M")}'"
        consulta = MaintenanceTicket.joins(:vehicle).where(cadena_consulta)
      return consulta  
  end

end
