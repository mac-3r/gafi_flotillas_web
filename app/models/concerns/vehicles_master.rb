class VehiclesMaster < ActiveRecord::Base
  
    def readonly?
        true
    end

    def self.consulta_maestro(vehiculo,cedis,area,tipo,empresa,fecha_inicio,fecha_fin,activos, pagina = 1)
      cadena_consulta = ""
      if vehiculo != ""
        cadena_consulta += " numero_economico = '#{vehiculo}' and"
      end
      if cedis != "" 
        cadena_consulta += " catalog_branch_id = #{cedis} and"
      end
      if area != "" 
        cadena_consulta += " catalog_area_id = #{area} and"
      end
      if tipo != ""
        cadena_consulta += " vehicle_type_id = #{tipo} and"
      end
      if empresa != ""
        cadena_consulta += " catalog_company_id = #{empresa} and"
      end

      if activos != nil
        cadena_consulta += " vehicle_status_id = 1 and"
      end

      if fecha_inicio != "" and fecha_fin != ""
        cadena_consulta += " fecha_compra between '#{(fecha_inicio).strftime("%Y-%m-%d")}' and '#{(fecha_fin).strftime("%Y-%m-%d")}'"
      else
        cadena_consulta += " created_at <= '#{(Time.now + 1.day).strftime("%Y-%m-%d")}'"
      end

        consulta = VehiclesMaster.where(cadena_consulta).order(numero_economico: :asc).page(pagina).per(30)
      return consulta  
    end

end