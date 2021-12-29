class VerificationReports < ActiveRecord::Base
  
    def readonly?
        true
    end

    def self.consulta_verificaciones(company, branch, area, vehicle, fecha_ini, fecha_fin)
        cadena = ""
        if company != "" and company != nil
            cadena += "verification_reports.catalog_company_id = #{company} and "
        end
        if branch != "" and branch != nil
            cadena += "verification_reports.catalog_branch_id = #{branch} and "
        end
        if area != "" and area != nil
            cadena += "verification_reports.catalog_area_id = #{area} and "
        end
        if vehicle != "" and vehicle != nil
            cadena += "verification_reports.vehicle_id = #{vehicle} and "
        end
        if (fecha_ini != "" and fecha_ini != nil) and (fecha_fin != "" and fecha_fin != nil)
            cadena += "(verification_reports.fecha_auditoria between '#{Date.strptime(fecha_ini, "%d/%m/%Y").to_date.strftime("%Y-%m-%d")}' and '#{Date.strptime(fecha_fin, "%d/%m/%Y").to_date.strftime("%Y-%m-%d")}') and "
        elsif (fecha_ini != "" and fecha_ini != nil) and (fecha_fin == "" or fecha_fin == nil)
            cadena += "verification_reports.fecha_auditoria >= '#{Date.strptime(fecha_ini, "%d/%m/%Y").to_date.strftime("%Y-%m-%d")}' and "
        elsif (fecha_ini == "" or fecha_ini == nil) and (fecha_fin != "" and fecha_fin != nil)
            cadena += "verification_reports.fecha_auditoria <= '#{Date.strptime(fecha_fin, "%d/%m/%Y").to_date.strftime("%Y-%m-%d")}' and "
        end
        cadena += "verification_reports.estatus != 0"
        return @verificaciones = VerificationReports.where(cadena).order(fecha_auditoria: :desc)
    end
    
end