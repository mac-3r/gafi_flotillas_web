class VehicleConsumption < ApplicationRecord
  belongs_to :vehicle, optional: true
  belongs_to :consumption, optional: true

  def self.consulta_acumulado(vehiculo,empresa,cedis,area,fecha_i,fecha_f)
    cadena_consulta = ""
    
      if vehiculo != ""
        cadena_consulta += "  vehicles.id= #{vehiculo} and"
      end
      if empresa != "" 
        cadena_consulta += " vehicles.catalog_company_id = #{empresa} and"
      end
      if cedis != "" 
        cadena_consulta += " vehicles.catalog_branch_id = #{cedis} and"
      end
      if area != ""
        cadena_consulta += " vehicles.catalog_area_id = '#{area}' and"
      end
      if fecha_i != "" and fecha_f != ""
        cadena_consulta += " consumptions.fecha_inicio >= '#{fecha_i.strftime("%Y-%m-%d")}' and consumptions.fecha_fin <= '#{fecha_f.strftime("%Y-%m-%d")}'"
      else
        cadena_consulta += " consumptions.fecha_inicio >= '#{Date.today.at_beginning_of_month.strftime("%Y-%m-%d")}' and consumptions.fecha_fin <= '#{Time.now.strftime("%Y-%m-%d")}'"
      end
    
        consulta = VehicleConsumption.joins(:vehicle).joins(:consumption).where(cadena_consulta).where.not(consumptions:{estatus:0})
      return consulta  
  end

  def self.import_consumption(file)
    monto = 0
    id_registro = 0
    n_cargas = 0
    spreadsheet = Roo::Spreadsheet.open(file.path)
    arreglo_consumo = Array.new()
    arreglo_id = Array.new
    hash_consumo = Hash.new

    header = spreadsheet.row(3)

    if spreadsheet.sheets.length > 1
      hash_consumo["Problema"] = "Se han detectado más hojas de cálculo, por favor verifique la información."
      arreglo_consumo.push(problema:  "Se han detectado más hojas de cálculo, por favor verifique la información.",fila:0)
    else
      (4..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
          if row["No Economico"] != "" and !row["No Economico"].nil?
            vehiculo = Vehicle.find_by(numero_economico: row["No Economico"])
            if !vehiculo
              arreglo_consumo.push(problema: "El campo de No económico #{row["No Economico"]} no se encuentra dentro del catalogo de vehículos, verifique por favor...",fila:i)
              next
            else
              vehiculo_id = vehiculo.id
              if vehiculo.reparto == true
                # if !row["Odometro"].present?
                #   arreglo_consumo.push(problema: "El campo de odometro se encuentra vacío, verifique por favor...",fila:i)
                #   next
                # end

                if row["Odometro"] == nil or row["Odometro"] == ""
                  arreglo_consumo.push(problema: "El campo de odometro se encuentra vacío, verifique por favor...",fila:i)
                  next
                end
      
                # if !row["Rendimiento"].present?
                #   arreglo_consumo.push(problema: "El campo de rendimiento se encuentra vacío, verifique por favor...",fila:i)
                #   next
                # end 

                if row["Rendimiento"] == nil or row["Rendimiento"] == ""
                  arreglo_consumo.push(problema: "El campo de rendimiento se encuentra vacío, verifique por favor...",fila:i)
                  next
                end 
              end
            end
          else
            arreglo_consumo.push(problema: "El campo de No económico se encuentra vacío, verifique por favor...",fila:i)
          end   


          # if !row["Cantidad"].present?
          #   arreglo_consumo.push(problema: "El campo de cantidad se encuentra vacío, verifique por favor...",fila:i)
          #   next
          # end

          if row["Cantidad"] == nil or row["Cantidad"] == ""
            arreglo_consumo.push(problema: "El campo de cantidad se encuentra vacío, verifique por favor...",fila:i)
            next
          end

          # if !row["Monto"].present?
          #   arreglo_consumo.push(problema: "El campo de monto se encuentra vacío, verifique por favor...",fila:i)
          #   next
          # else
          #   monto += row["Monto"].to_f
          # end

          if row["Monto"] == nil or row["Monto"] == ""
            arreglo_consumo.push(problema: "El campo de monto se encuentra vacío, verifique por favor...",fila:i)
            next
          else
            monto += row["Monto"].to_f
          end

          # if !row["Fecha"].present?
          #   arreglo_consumo.push(problema: "El campo de fecha se encuentra vacío, verifique por favor...",fila:i)
          #   next
          # end

          if row["Fecha"] == nil or row["Fecha"] == ""
            arreglo_consumo.push(problema: "El campo de fecha se encuentra vacío, verifique por favor...",fila:i)
            next
          end

          if arreglo_consumo == []
          n_cargas += 1
          begin 
            store_consumo = VehicleConsumption.create(vehicle_id: vehiculo_id,tarjeta: row["Tarjeta"], placa: row["Placas"], estacion: row["Estacion"], fecha: row["Fecha"], hora: row["Hora"], despacho: row["Despacho"], bomba: row["Bomba"], producto: row["Producto"], cantidad: row["Cantidad"], monto: row["Monto"], datos: row["Datos"], odometro: row["Odometro"], rendimiento: row["Rendimiento"], recorrido: row["Recorrido"], cliente: row["Cliente"])
            if !store_consumo.save!        
              store_consumo.errors.full_messages do |error|
                hash_consumo["Problema"] = error
                hash_consumo["fila"] = i
                hash_consumo["producto"] = row["NOMBRE"]
              end
              arreglo_consumo.push(problema: error,fila:i)
            else
              arreglo_id.push(store_consumo.id)
            end
          rescue Exception => error
            arreglo_consumo.push(problema: error,fila:i)
          end
        end
      end
    end
    return arreglo_consumo, monto, n_cargas, arreglo_id
  end
  #exportar excel
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |vehicle_consumption|
        csv << vehicle_consumption.attributes.values_at(*column_names)
      end
    end
  end

  def self.consulta_reporte_mensual(fecha_inicio, fecha_fin, company, branch, area, vehicle)
    @arreglo_mes_fecha = Array.new
    @arreglo_mes_datos = Array.new
    cadena = "vehicles.reparto = true and consumptions.id IS NOT NULL"
    cadena += " and vehicles.catalog_company_id = #{company}" if company != ""
    cadena += " and vehicles.catalog_branch_id = #{branch}" if branch != ""
    cadena += " and vehicles.catalog_area_id = #{area}" if area != ""
    cadena += " and vehicles.id = #{vehicle}" if vehicle != ""
    if fecha_inicio == "" and fecha_fin == ""
      fecha_inicio = Time.zone.now.beginning_of_year
      fecha_fin = Time.zone.now.end_of_year
      cantidad_meses = TimeDifference.between(fecha_inicio, fecha_fin).in_months
      for i in 0..(cantidad_meses - 1) do
        fecha = fecha_inicio + i.months
        fecha_ant = fecha - 1.month
        consulta = VehicleConsumption.find_by_sql("select vehicle_id, max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) as cierre,
        max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) -
        max(case when fecha between '#{fecha_ant.strftime("%Y-%m-%d")}' and '#{fecha_ant.end_of_month.strftime("%Y-%m-%d")}' then odometro end) as recorrido,
            sum(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then cantidad end) as lts,
            ((max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) -
              max(case when fecha between '#{fecha_ant.strftime("%Y-%m-%d")}' and '#{fecha_ant.end_of_month.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento
                    from vehicle_consumptions INNER JOIN vehicles ON vehicles.id = vehicle_consumptions.vehicle_id
                    INNER JOIN consumptions ON consumptions.id = vehicle_consumptions.consumption_id
                    where #{cadena} group by vehicle_id,numero_economico order by vehicles.numero_economico")
        @arreglo_mes_datos.push(consulta)
        @arreglo_mes_fecha.push(fecha)
      end
    elsif fecha_inicio != "" and fecha_fin != ""
      split_inicio = fecha_inicio.split("/")
      split_fin = fecha_fin.split("/")
      if split_inicio.length == 2
        fecha_inicio = Date.new(split_inicio[1].to_i, split_inicio[0].to_i, 1)
      elsif split_inicio.length > 2
        fecha_inicio = Date.new(split_inicio[split_fin.length].to_i, split_inicio[split_fin.length - 1].to_i, 1)
      elsif split_inicio.length < 2
        fecha_inicio = Time.zone.now.to_date.beginning_of_year
      end
      if split_fin.length == 2
        fecha_fin = Date.new(split_fin[1].to_i, split_fin[0].to_i, 1)
      elsif split_fin.length > 2
        fecha_fin = Date.new(split_fin[split_fin.length].to_i, split_fin[split_fin.length - 1].to_i, 1)
      elsif split_fin.length < 2
        fecha_fin = Time.zone.now.to_date.end_of_year
      end
      cantidad_meses = TimeDifference.between(fecha_inicio, fecha_fin).in_months
      for i in 0..(cantidad_meses + 1) do
        fecha = fecha_inicio + i.months
        fecha_ant = fecha - 1.month
        consulta = VehicleConsumption.find_by_sql("select vehicle_id, max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) as cierre,
        max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) -
        max(case when fecha between '#{fecha_ant.strftime("%Y-%m-%d")}' and '#{fecha_ant.end_of_month.strftime("%Y-%m-%d")}' then odometro end) as recorrido,
            sum(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then cantidad end) as lts,
            ((max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) -
              max(case when fecha between '#{fecha_ant.strftime("%Y-%m-%d")}' and '#{fecha_ant.end_of_month.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento
                    from vehicle_consumptions INNER JOIN vehicles ON vehicles.id = vehicle_consumptions.vehicle_id
                    INNER JOIN consumptions ON consumptions.id = vehicle_consumptions.consumption_id
                    where #{cadena} group by vehicle_id,numero_economico order by vehicles.numero_economico")
        @arreglo_mes_datos.push(consulta)
        @arreglo_mes_fecha.push(fecha)
      end
      #byebug
    elsif fecha_inicio != "" and fecha_fin == ""
      split_inicio = fecha_inicio.split("/")
      split_fin = fecha_fin.split("/")
      if split_inicio.length == 2
        fecha_inicio = Date.new(split_inicio[1].to_i, split_inicio[0].to_i, 1)
      elsif split_inicio.length > 2
        fecha_inicio = Date.new(split_inicio[split_fin.length].to_i, split_inicio[split_fin.length - 1].to_i, 1)
      elsif split_inicio.length < 2
        fecha_inicio = Time.zone.now.to_date.beginning_of_year
      end
      fecha_fin = Time.zone.now.to_date
      cantidad_meses = TimeDifference.between(fecha_inicio, fecha_fin).in_months
      for i in 0..(cantidad_meses + 1) do
        fecha = fecha_inicio + i.months
        fecha_ant = fecha - 1.month
        consulta = VehicleConsumption.find_by_sql("select vehicle_id, max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) as cierre,
        max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) -
        max(case when fecha between '#{fecha_ant.strftime("%Y-%m-%d")}' and '#{fecha_ant.end_of_month.strftime("%Y-%m-%d")}' then odometro end) as recorrido,
            sum(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then cantidad end) as lts,
            ((max(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then odometro end) -
              max(case when fecha between '#{fecha_ant.strftime("%Y-%m-%d")}' and '#{fecha_ant.end_of_month.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha.strftime("%Y-%m-%d")}' and '#{fecha.end_of_month.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento
                    from vehicle_consumptions INNER JOIN vehicles ON vehicles.id = vehicle_consumptions.vehicle_id
                    INNER JOIN consumptions ON consumptions.id = vehicle_consumptions.consumption_id
                    where #{cadena} group by vehicle_id,numero_economico order by vehicles.numero_economico")
        @arreglo_mes_datos.push(consulta)
        @arreglo_mes_fecha.push(fecha)
      end
    else
      @bandera_renderiza == 2
    end
    return @arreglo_mes_fecha, @arreglo_mes_datos
  end
  
end
