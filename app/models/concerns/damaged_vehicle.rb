class DamagedVehicle < ActiveRecord::Base
  
    def readonly?
        true
    end

    def self.grafica_indicadores_daniados(empresa, cedis, fecha_inicio, fecha_fin, area, vehiculo)
        if cedis != ""
            if area == "" and vehiculo == ""
                prueba = DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','vehiculos_daniados','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin).group(:id_empresa,:nombre_empresa,:id_cedis,:cedis,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin)
            elsif area != "" and vehiculo == ""
                prueba = DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','vehiculos_daniados','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).group(:id_empresa,:nombre_empresa,:id_cedis,:cedis,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area)
            elsif area == "" and vehiculo != ""
                prueba = DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','vehiculos_daniados','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).group(:id_empresa,:nombre_empresa,:id_cedis,:cedis,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo)
            elsif area != "" and vehiculo != ""
                prueba = DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','vehiculos_daniados','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).group(:id_empresa,:nombre_empresa,:id_cedis,:cedis,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo)
            end
        elsif empresa !=""
            if area == "" and vehiculo == ""
                prueba =  DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos','porcentaje').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,fecha: fecha_inicio..fecha_fin)
            elsif area != "" and vehiculo == ""
                prueba =  DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos','porcentaje').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,fecha: fecha_inicio..fecha_fin, catalog_area_id: area)
            elsif area == "" and vehiculo != ""
                prueba =  DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos','porcentaje').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo)
            elsif area != "" and vehiculo != ""
                prueba =  DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos','porcentaje').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo)
            end
        else
            if area == "" and vehiculo == ""
                prueba =  DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos','porcentaje').where(fecha: fecha_inicio..fecha_fin ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(fecha: fecha_inicio..fecha_fin)
            elsif area != "" and vehiculo == ""
                prueba =  DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos','porcentaje').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area)
            elsif area == "" and vehiculo != ""
                prueba =  DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos','porcentaje').where(fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo)
            elsif area != "" and vehiculo != ""
                prueba =  DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos','porcentaje').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos,:porcentaje)
                prueba2 =  DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo)
            end
        end
        #byebug
        return prueba,prueba2
        #DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','total_vehiculos','porcentaje').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin)
    end

    def self.grafica_indicadores_monto(empresa, cedis, fecha_inicio, fecha_fin)
        if cedis != ""
            DamagedVehicle.select('id_empresa','nombre_empresa','id_cedis','cedis','vehiculos_daniados','total_vehiculos').where(id_empresa: empresa,id_cedis: cedis, fecha: fecha_inicio..fecha_fin ).group(:id_empresa,:nombre_empresa,:id_cedis,:cedis,:vehiculos_daniados,:total_vehiculos)
        else
            DamagedVehicle.select('id_empresa','nombre_empresa','vehiculos_daniados','total_vehiculos').where(id_empresa: empresa, fecha: fecha_inicio..fecha_fin ).group(:id_empresa,:nombre_empresa,:vehiculos_daniados,:total_vehiculos)
        end
        #byebug
    end
end