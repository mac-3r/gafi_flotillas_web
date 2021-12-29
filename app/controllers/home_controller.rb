class HomeController < ApplicationController
    #layout :login, only: [:login]
    def index
        
    end
    def login
        render action: "login", layout: "login"
    end

    def dashboard
        @resultados_areas = []
        @resultados_nombre = []
        @resultados_cedis = []
        @res_nombre_cedis = []
        @resultados_mmto = []
        @gastos_comb = []
        @semana = []
        fecha_actual = Date.today
        inicio = fecha_actual.beginning_of_year
        #tarjetas
        @total_vehiculos = Vehicle.all.count
        @vehiculos_activos = Vehicle.joins(:vehicle_status).where(vehicle_statuses: {descripcion: "Activo"}).count
        @vehiculos_inactivos = Vehicle.joins(:vehicle_status).where(vehicle_statuses: {descripcion: "Inactivo"}).count
        @vehiculos_siniestados = Vehicle.joins(:vehicle_status).where(vehicle_statuses: {descripcion: "Siniestrado"}).count
        #vehiculos x area
        areas = CatalogArea.all
        areas.each do |area|
            contador = Vehicle.where(catalog_area_id: area.id).count
            calculo = contador.to_f/@total_vehiculos.to_f * 100.0
            @resultados_areas.push(calculo.round(2))
            @resultados_nombre.push(area.descripcion)
        end 
        #vehiculos x cedis
        sucursales = CatalogBranch.all
        sucursales.each do |cedis|
            contador_cedis = Vehicle.where(catalog_branch_id: cedis.id).count
            calculo_cedis = contador_cedis.to_f/@total_vehiculos.to_f * 100.0
            @resultados_cedis.push(calculo_cedis.round(2))
            @res_nombre_cedis.push(cedis.decripcion)
            #vehiculos en mantenimiento
            @vehiculos_mantenimiento = MaintenanceControl.joins(:vehicle).where(vehicles:{catalog_branch_id:cedis.id},fecha_factura:fecha_actual.at_beginning_of_month..fecha_actual).count
            @resultados_mmto.push(@vehiculos_mantenimiento)
            #combustible
            @gasto_combustible = Consumption.where(catalog_branch_id:cedis.id,fecha_inicio: fecha_actual.beginning_of_month..fecha_actual).group_by_week(:fecha_fin, week_start: :monday).sum(:monto)
            @gastos_comb.push(@gasto_combustible.map{|x|x[1]})
            @semana.push(@gasto_combustible.map{|x|x[0]})
        end
        @resultados_combustible =  @res_nombre_cedis.zip(@semana, @gastos_comb)
        #flotillas sinietradas
        @flotillas_siniestradas = DamagedVehicle.grafica_indicadores_daniados("", "", inicio, fecha_actual)
    end
end
