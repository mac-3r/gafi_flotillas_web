class DamagedVehicleAmmount < ActiveRecord::Base
  
    def readonly?
        true
    end

    def self.grafica_indicadores_monto(empresa, cedis, fecha_inicio, fecha_fin, area, vehiculo)
        if cedis != ""
            if area == "" and vehiculo == ""
                montos = DamagedVehicleAmmount.where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin ).group(:id_cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('cedis').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin ).group(:cedis)
                resultado = numeros.zip(montos)
            elsif area != "" and vehiculo == ""
                montos = DamagedVehicleAmmount.where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:id_cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('cedis').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:cedis)
                resultado = numeros.zip(montos)
            elsif area == "" and vehiculo != ""
                montos = DamagedVehicleAmmount.where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:id_cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('cedis').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:cedis)
                resultado = numeros.zip(montos)
            elsif area != "" and vehiculo != ""
                montos = DamagedVehicleAmmount.where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:id_cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('cedis').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:cedis)
                resultado = numeros.zip(montos)
            end
            return resultado
        elsif empresa != ""
            if area == "" and vehiculo == ""
                montos = DamagedVehicleAmmount.where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin ).group(:id_empresa,:id_cedis,:cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('id_empresa','id_cedis','cedis').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin ).group(:id_empresa,:id_cedis,:cedis)
                resultado = numeros.zip(montos)
            elsif area != "" and vehiculo == ""
                montos = DamagedVehicleAmmount.where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:id_empresa,:id_cedis,:cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('id_empresa','id_cedis','cedis').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:id_empresa,:id_cedis,:cedis)
                resultado = numeros.zip(montos)
            elsif area == "" and vehiculo != ""
                montos = DamagedVehicleAmmount.where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:id_empresa,:id_cedis,:cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('id_empresa','id_cedis','cedis').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:id_empresa,:id_cedis,:cedis)
                resultado = numeros.zip(montos)
            elsif area != "" and vehiculo != ""
                montos = DamagedVehicleAmmount.where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin , catalog_area_id: area, vehicle_id: vehiculo).group(:id_empresa,:id_cedis,:cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('id_empresa','id_cedis','cedis').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:id_empresa,:id_cedis,:cedis)
                resultado = numeros.zip(montos)
            end
            return resultado
        else
            if area == "" and vehiculo == ""
                montos = DamagedVehicleAmmount.where(fecha: fecha_inicio..fecha_fin ).group(:id_empresa,:id_cedis,:cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('id_empresa','id_cedis','cedis').where(fecha: fecha_inicio..fecha_fin ).group(:id_empresa,:id_cedis,:cedis)
                resultado = numeros.zip(montos)
            elsif area != "" and vehiculo == ""
                montos = DamagedVehicleAmmount.where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area  ).group(:id_empresa,:id_cedis,:cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('id_empresa','id_cedis','cedis').where(fecha: fecha_inicio..fecha_fin , catalog_area_id: area ).group(:id_empresa,:id_cedis,:cedis)
                resultado = numeros.zip(montos)
            elsif area == "" and vehiculo != ""
                montos = DamagedVehicleAmmount.where(fecha: fecha_inicio..fecha_fin,  vehicle_id: vehiculo ).group(:id_empresa,:id_cedis,:cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('id_empresa','id_cedis','cedis').where(fecha: fecha_inicio..fecha_fin,  vehicle_id: vehiculo ).group(:id_empresa,:id_cedis,:cedis)
                resultado = numeros.zip(montos)
            elsif area != "" and vehiculo != ""
                montos = DamagedVehicleAmmount.where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area,  vehicle_id: vehiculo  ).group(:id_empresa,:id_cedis,:cedis).sum(:monto_sin)
                numeros = DamagedVehicleAmmount.select('id_empresa','id_cedis','cedis').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area,  vehicle_id: vehiculo  ).group(:id_empresa,:id_cedis,:cedis)
                resultado = numeros.zip(montos)
            end
            return resultado 
        end
    end
end