class BimonthlyVerification < ApplicationRecord
    belongs_to :vehicle
    belongs_to :catalog_personal
    belongs_to :user

    def self.consulta_auditorias(vehiculo,empresa,cedis,user,tipo,area)
        cadena_consulta = ""
    
      if vehiculo != ""
        cadena_consulta += " vehicles.id = #{vehiculo} and "
      end
      if empresa != ""
        cadena_consulta += " vehicles.catalog_company_id = #{empresa} and "
      end
      if cedis != "" 
        cadena_consulta += " vehicles.catalog_branch_id = #{cedis} and "
      end
      if user != "" 
        cadena_consulta += " vehicles.catalog_personal_id = #{user} and "
      end
      if tipo != ""
        cadena_consulta += " vehicles.vehicle_type_id = #{tipo} and "
      end
      if area != ""
        cadena_consulta += " vehicles.catalog_area_id = #{area} and "
      end
      cadena_consulta += " bimonthly_verifications.fecha_captura between '#{Time.now.beginning_of_year.strftime("%Y-%m-%d %H:%M:%M")}' and '#{Time.now.strftime("%Y-%m-%d %H:%M:%M")}'"
        consulta = BimonthlyVerification.joins(:vehicle).where(cadena_consulta)
      return consulta   
    end

end