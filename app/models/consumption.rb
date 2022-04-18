class Consumption < ApplicationRecord
    has_many :vehicle_consumptions
    belongs_to :catalog_branch, optional: true
    belongs_to :catalog_vendor
    belongs_to :valuation, optional: true
    enum estatus: ["Pendiente", "Por autorizar", "Autorizado", "Rechazado"]
    has_one_attached :factura
    has_one_attached :pdf
    scope :por_fecha_inicio, -> (fecha_inicio) {where("fecha_inicio >= ?", fecha_inicio)}
    scope :por_fecha_fin, -> (fecha_fin) {where("fecha_fin <= ?", fecha_fin)}
    scope :por_cedis, -> (cedis) {where(catalog_branches: {id: cedis})}

    def self.busqueda_solicitud(fecha_inicio, fecha_fin,cedis)
        if fecha_inicio != "" and fecha_fin != "" and cedis != ""
            self.joins(:catalog_branch).por_cedis(cedis).por_fecha_inicio(fecha_inicio.to_date).por_fecha_fin(fecha_fin.to_date).where(estatus: "Autorizado")
        elsif fecha_inicio == "" and fecha_fin != "" and cedis != ""
            self.joins(:catalog_branch).por_cedis(cedis).por_fecha_fin(fecha_fin.to_date).where(estatus: "Autorizado")
        elsif fecha_inicio != "" and fecha_fin == "" and cedis != ""
            self.joins(:catalog_branch).por_cedis(cedis).por_fecha_inicio(fecha_inicio.to_date).where(estatus:"Autorizado")
        elsif fecha_inicio == "" and fecha_fin == "" and cedis != ""
            self.joins(:catalog_branch).por_cedis(cedis).where(estatus:"Autorizado")
        end
    end
    
    def self.consulta_cargas(fecha_ini,fecha_fin,proveedor,cedis,estatus)
        cadena_consulta = ""
        fecha_hora = (Time.now - 1.year).strftime("%Y-%m-%d %H:%M:%M")
        #fecha_hora = (Time.now + 7.hours).strftime("%Y-%m-%d %H:%M:%M")
		if estatus != "" or estatus.nil?
			cadena_consulta += " estatus = #{estatus} and"
		end

        if proveedor != ""
            cadena_consulta += " catalog_vendor_id = #{proveedor} and"
        end

        if cedis != ""
            cadena_consulta += " catalog_branch_id = #{cedis} and"
        end

        if fecha_ini != "" and fecha_fin != ""
            cadena_consulta += " fecha_inicio >= '#{(fecha_ini).strftime("%Y-%m-%d")}' and fecha_fin <= '#{(fecha_fin).strftime("%Y-%m-%d")}'"
        else
            cadena_consulta += " created_at <= '#{fecha_hora}'"
        end
		consulta = Consumption.where(cadena_consulta).where.not(estatus:2).order(created_at: :desc)
		return consulta  
    end


    def self.litros_consumo(fecha_inicio,fecha_fin,cedis,vendor, encabezado)
        arreglo_litros = Array.new()
        #byebug
        #ventas = encabezado.vehicle_consumptions.where(vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas").id).ids)
        ventas = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas")),fecha: fecha_inicio..fecha_fin)
        #byebug
        ventas.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"                
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_admin(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        admin = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Administrativo")),fecha: fecha_inicio..fecha_fin)
        #byebug
        admin.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_almacen(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        
        almacen = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Almacén")),fecha: fecha_inicio..fecha_fin)
        #byebug
        almacen.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

# ---------------------------- consumos con iva --------------------------------

    def self.litros_consumo8(fecha_inicio,fecha_fin,cedis,vendor, encabezado)
        arreglo_litros = Array.new()
        #byebug
        #ventas = encabezado.vehicle_consumptions.where(vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas").id).ids)
        valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
        ventas = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas")),fecha: fecha_inicio..fecha_fin)
        #byebug
        ventas.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"                
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_admin8(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
        admin = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Administrativo")),fecha: fecha_inicio..fecha_fin)
        #byebug
        admin.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_almacen8(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        
        valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
        almacen = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Almacén")),fecha: fecha_inicio..fecha_fin)
        #byebug
        almacen.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end


    def self.litros_consumo16(fecha_inicio,fecha_fin,cedis,vendor, encabezado)
        arreglo_litros = Array.new()
        #byebug
        #ventas = encabezado.vehicle_consumptions.where(vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas").id).ids)
        valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
        ventas = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas")),fecha: fecha_inicio..fecha_fin)
        #byebug
        ventas.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"                
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_admin16(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
        admin = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Administrativo")),fecha: fecha_inicio..fecha_fin)
        #byebug
        admin.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_almacen16(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        
        valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
        almacen = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Almacén")),fecha: fecha_inicio..fecha_fin)
        #byebug
        almacen.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end


# ---------------------------- consumos con iva --------------------------------

    def self.crear_documento(params, encabezado)
        bandera_error = 0
        mensaje = ""
        bandera_detallado = true
        busqueda_enc = Consumption.find_by(id: encabezado)
        #byebug
        Consumption.transaction do
            #begin
            if busqueda_enc
                doc = File.open(params[:consumption][:factura]) { |f| Nokogiri::XML(f) }
                archivo = Hash.from_xml(doc.to_s)
                hash = archivo["Comprobante"]
                folio_factura = hash["Folio"] 
                serie_factura = hash["Serie"]
                fecha_factura = hash["Fecha"]
                total_factura = hash["Total"].split(".")
                empresa_xml = hash["Receptor"]["Rfc"]
                identificador_unico = hash["Complemento"]["TimbreFiscalDigital"]["UUID"]
                impuestos_traladados = hash["Impuestos"]["TotalImpuestosTrasladados"].to_f
                impuestos_retenidos =  hash["Impuestos"]["TotalImpuestosRetenidos"].to_f
                monto_encabezado = busqueda_enc.monto.round(2).to_s.split(".")
                total = monto_encabezado[0].to_f - total_factura[0].to_f
                total_impuestos = impuestos_traladados + impuestos_retenidos
                if serie_factura == "" or serie_factura.nil?
                    folio_factura_def = "F-#{folio_factura}"
                else
                    folio_factura_def = "#{serie_factura}#{folio_factura}"
                end
                empresa = CatalogCompany.find_by(rfc: empresa_xml)
                if empresa
                    array = []
                    array_i = []
                    array_b = []
                    #obtener todos los importes
                    file = Nokogiri::XML(File.open(params[:consumption][:factura]))    
                    doc_pass = file.xpath("//cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto")    
                    doc_pass.each do |pass|
                        hash_importe = {}
                        hash_importe[:importe] = pass['Importe']
                        array << hash_importe
                    end
                    #byebug
                    #obtener todos los impuestos
                    doc_pass2 = file.xpath("//cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto/cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado")    
                    doc_pass2.each do |pass2|
                        hash_impuesto = {}
                        hash_impuesto[:impuesto] = pass2['Importe']
                        array_i << hash_impuesto
                    end
                    
                    if array.length > 2
                        #suma el importe y el impuesto
                        suma =  (0..array.size - 1).each_with_object([]) { |i, obj| obj <<  (array[i][:importe].to_f + array_i[i][:impuesto].to_f).round(2) }
                        #muestra los id de los registros que coinciden con la suma
                        totales = (0..suma.size - 1).each_with_object([]){ |i,obj| obj << VehicleConsumption.where("consumption_id = #{encabezado} and monto >= #{suma[i] - 0.02} and monto <= #{suma[i] + 0.02}").pluck(:id) }
                        prueba = (0..totales.size - 1).each_with_object([]){ |i,obj|
                            obj << if totales[i].empty?
                                puts "No coincide"
                            else
                                # recorrer el de totales y buscar con find_by(key: value)
                                buscar_id = VehicleConsumption.find_by(id: totales[i])
                                puts "Coincide"
                                if buscar_id
                                    buscar_id.update(impuestos:array_i[i][:impuesto].to_f)
                                else
                                    puts "Error al registrar"
                                end
                            end
                        }
                    else
                        bandera_detallado = false
                    #     suma =  (0..array.size - 1).each_with_object([]) { |i, obj| obj <<  (array[i][:importe].to_f + array_i[i][:impuesto].to_f).round(2) }
                    #     #muestra los id de los registros que coinciden con la suma
                    #     totales = (0..suma.size - 1).each_with_object([]){ |i,obj| obj << VehicleConsumption.where("consumption_id = #{encabezado} and monto >= #{suma[i] - 0.02} and monto <= #{suma[i] + 0.02}").pluck(:id) }
                    #     prueba = (0..totales.size - 1).each_with_object([]){ |i,obj|
                    #         obj << if totales[i].empty?
                    #             puts "No coincide"
                    #         else
                    #             # recorrer el de totales y buscar con find_by(key: value)
                    #             buscar_id = VehicleConsumption.find_by(id: totales[i])
                    #             puts "Coincide"
                    #             if buscar_id
                    #                 division_mto_fact = monto_encabezado / buscar_id.monto
                    #                 prorrat_imp = division_mto_fact * total_impuestos

                    #                 buscar_id.update(impuestos: prorrat_imp.to_f)
                    #             else
                    #                 puts "Error al registrar"
                    #             end
                    #         end
                    #     }

                    end
                    
                    # #suma el importe y el impuesto
                    # suma =  (0..array.size - 1).each_with_object([]) { |i, obj| obj <<  (array[i][:importe].to_f + array_i[i][:impuesto].to_f).round(2) }
                    # #muestra los id de los registros que coinciden con la suma
                    # totales = (0..suma.size - 1).each_with_object([]){ |i,obj| obj << VehicleConsumption.where("consumption_id = #{encabezado} and monto >= #{suma[i] - 0.02} and monto <= #{suma[i] + 0.02}").pluck(:id) }
                    # prueba = (0..totales.size - 1).each_with_object([]){ |i,obj|
                    #     obj << if totales[i].empty?
                    #         puts "No coincide"
                    #     else
                    #         # recorrer el de totales y buscar con find_by(key: value)
                    #         buscar_id = VehicleConsumption.find_by(id: totales[i])
                    #         puts "Coincide"
                    #         if buscar_id
                    #             buscar_id.update(impuestos:array_i[i][:impuesto].to_f)
                    #         else
                    #             puts "Error al registrar"
                    #         end
                    #     end
                    # }
                    #byebug
                    if monto_encabezado[0].to_f == total_factura[0].to_f #total >= 0 and total <= 1

                        if busqueda_enc.update(factura: params[:consumption][:factura], n_factura: folio_factura_def, fecha_factura: fecha_factura,impuestos:total_impuestos,uuid:identificador_unico,usuario_modifico:"#{User.current_user.name} #{User.current_user.last_name}", es_detallado: bandera_detallado, company_id: empresa.id)
                            ver_registros= VehicleConsumption.where(consumption_id:encabezado,impuestos: nil)
                            #byebug
                            if ver_registros.count > 0

                                ver_registros.each do |enc|
                                    bque_veh = VehicleTransferLog.where(vehicle_id: enc.vehicle_id, fecha: busqueda_enc.fecha_inicio..busqueda_enc.fecha_fin) 
                                    if bque_veh.length > 0
                                        enc.update(catalog_branch_id: bque_veh.last.catalog_branch_id)
                                    else
                                        bque_veh2 = VehicleTransferLog.where("vehicle_id = ? and fecha <= ?", enc.vehicle_id, busqueda_enc.fecha_inicio)
                                        if bque_veh2.length > 0
                                            enc.update(catalog_branch_id: bque_veh2.last.catalog_branch_id)
                                        else
                                            enc.update(catalog_branch_id: enc.vehicle.catalog_branch_id)
                                        end
                                    end
                                end
                                bandera_error = 1
                                if bandera_detallado == true
                                    mensaje = "La factura se adjuntó con éxito, pero algúnos impuestos no coincidieron. Favor de actualizar manualmente los impuestos."
                                else
                                    mensaje = "La factura se adjuntó con éxito"
                                end
                            else
                                bandera_error = 4                
                            end
                        else 
                            bandera_error = 3
                            busqueda_enc.errors.full_messages.each do |error|
                                mensaje += "#{error}. "
                            end
                        end
                    else
                        bandera_error = 1
                        mensaje = "El monto ya registrado y el total de la factura no coinciden."
                    end
                else
                    bandera_error = 1
                    mensaje = "No se encontró la empresa correspondiente a la factura. Por favor revise que el RFC de la empresa sea correcto."
                end
            else
                bandera_error = 1
                mensaje = "No se encontró el registro del encabezado."
            end
            if bandera_error == 4
                mensaje = "Documento agregado correctamente." 
                return mensaje,bandera_error
            else
                return mensaje, bandera_error
                raise ActiveRecord::Rollback
            end
        end
        # rescue ActiveRecord::RecordInvalid => e
        #     mensaje += "Ocurrió un error al guardar la factura,, por lo que la operación no pudo continuar: #{e}."
        #     bandera_error = true
        #     return mensaje, bandera_error
        # rescue Exception => error
        #     mensaje += "Ocurrió un error desconocido: #{error}. Favor de contactar al área de soporte."
        #     bandera_error = true
        #     return mensaje, bandera_error
    end

    def self.crear_pdf(params, encabezado)
        bandera_error = 0
        mensaje = ""
        busqueda_enc = Consumption.find_by(id: encabezado)
        begin
            if busqueda_enc
                if busqueda_enc.update(pdf: params[:consumption][:pdf])
                    bandera_error = 4
                    mensaje = "Documento agregado correctamente."                
                else
                    documento.errors.full_messages.each do |error|
                        mensaje += " #{error}."
                    end
                    bandera_error = 3
                end
            else
                bandera_error = 1
                mensaje = "No se encontró el registro del encabezado."
            end
        rescue Exception => error
            mensaje = error
            bandera_error = 3
        end
        return mensaje,bandera_error
    end
end
