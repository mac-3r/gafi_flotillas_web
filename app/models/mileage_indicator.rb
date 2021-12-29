class MileageIndicator < ApplicationRecord
  belongs_to :vehicle


  def self.consulta_km(empresa,cedis,fecha_ini,fecha_fin)
    max = MileageIndicator.maximum("fecha")
    cadena_consulta = ""
    if empresa != ""
      cadena_consulta += " vehicles.catalog_company_id = #{empresa} and"
    end

    if cedis != ""
      cadena_consulta += " vehicles.catalog_branch_id = #{cedis} and"
    end
    
    if fecha_ini != "" and fecha_fin != ""
        cadena_consulta += " fecha >= '#{fecha_ini.midnight}' and fecha <= '#{fecha_fin.end_of_day}'"
    else
        cadena_consulta += " fecha between '#{Date.today.beginning_of_week.strftime("%Y-%m-%d %H:%M:%S")}' and '#{(Date.today  + 30.hours).strftime("%Y-%m-%d %H:%M:%S")}'"
    end

    
    consulta = MileageIndicator.joins(:vehicle).where(cadena_consulta)
    return consulta  
  end

end
