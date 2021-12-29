class DamagedVehicleResponsible < ActiveRecord::Base
  
    def readonly?
        true
    end

    def self.tabla_indicadores_daniados(empresa, cedis, fecha_inicio, fecha_fin, area, vehiculo)
        if cedis != "" 
            if area == "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin ).group(:sucursal)
            elsif area != "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:sucursal)
            elsif area == "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:sucursal)
            elsif area != "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:sucursal)
            end
        elsif empresa != ""
            if area == "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin ).group(:sucursal,:id_empresa)
            elsif area != "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:sucursal,:id_empresa)
            elsif area == "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:sucursal,:id_empresa)
            elsif area != "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:sucursal,:id_empresa)
            end
        else
            if area == "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(fecha: fecha_inicio..fecha_fin ).group(:sucursal,:id_empresa)
            elsif area != "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:sucursal,:id_empresa)
            elsif area == "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:sucursal,:id_empresa)
            elsif area != "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad','sum(total_siniestros) as total').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:sucursal,:id_empresa)
            end
        end
    end

    def self.tabla_indicadores_monto(empresa, cedis, fecha_inicio, fecha_fin, area, vehiculo)
        if cedis != "" 
            if area == "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin ).group(:sucursal)
            elsif area != "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:sucursal)
            elsif area == "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:sucursal)
            elsif area != "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:sucursal)
            end
        elsif empresa != ""
            if area == "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin ).group(:sucursal,:id_empresa)
            elsif area != "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:sucursal,:id_empresa)
            elsif area == "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:sucursal,:id_empresa)
            elsif area != "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:sucursal,:id_empresa)
            end
        else
            if area == "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(fecha: fecha_inicio..fecha_fin ).group(:sucursal,:id_empresa)
            elsif area != "" and vehiculo == ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:sucursal,:id_empresa)
            elsif area == "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:sucursal,:id_empresa)
            elsif area != "" and vehiculo != ""
                DamagedVehicleResponsible.select('sucursal','sum(monto_sin) as cantidad').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:sucursal,:id_empresa)
            end
        end
    end
end
