class DamagedPercentage < ActiveRecord::Base
  
    def readonly?
        true
    end

    def self.grafica_porcentaje(empresa, cedis, fecha, anio, tipo, area, vehiculo)
        #byebug
        if tipo == "0"
            texto = "01/#{fecha}"
            fecha_inicio = Date.strptime(texto, "%d/%m/%Y")
            fecha_fin = fecha_inicio.end_of_month
            if fecha_inicio.month.to_i == 9 
                fecha_inicio = fecha_inicio+13.days
            end
            if fecha_inicio.month.to_i == 10
                fecha_inicio = fecha_inicio+16.days
            end
        else
            texto = "17/10/#{anio}"
            texto2 = "14/09/#{anio}"
            fecha_inicio = Date.strptime(texto, "%d/%m/%Y")
            fecha_fin = Date.strptime(texto2, "%d/%m/%Y")
            fecha_fin = fecha_fin + 1.year
        end
        #byebug
        if cedis != ""
            anio = fecha_inicio.to_date.year
            if fecha_inicio.to_date.month <= 9
                anio -= 1
            end
            ciclo = AnnualAmountsPaid.find_by(anio_inicio: anio, anio_fin: anio + 1)
            #byebug
            if ciclo 
                if tipo == "0"
                    if area == "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area != "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area == "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area != "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    end
                    resultado = mes_anio.zip(costo)
                    #map_mes = mes_anio.map{|x| x.sucursal}
                    map_mes = mes_anio
                    #map_mes_numero = mes_anio.map{|x| "#{x.mes_numero}"}
                    map_costo = costo.map{|x|x[1]}
                    array_porcentaje = Array.new

                    anio = fecha_inicio.to_date.year
                    if fecha_inicio.to_date.month <= 9
                        anio -= 1
                    end

                    fecha_uno = "#{anio}-11-01".to_date
                    prima_octubre = ciclo.cantidad/365*17
                    prima_noviembre = ciclo.cantidad/365*(fecha_uno.end_of_month.day.to_i)
                    prima_diciembre = ciclo.cantidad/365*((fecha_uno + 1.month).end_of_month.day.to_i)
                    prima_enero = ciclo.cantidad/365*((fecha_uno + 2.month).end_of_month.day.to_i)
                    prima_febrero = ciclo.cantidad/365*((fecha_uno + 3.month).end_of_month.day.to_i)
                    prima_marzo = ciclo.cantidad/365*((fecha_uno + 4.month).end_of_month.day.to_i)
                    prima_abril = ciclo.cantidad/365*((fecha_uno + 5.month).end_of_month.day.to_i)
                    prima_mayo = ciclo.cantidad/365*((fecha_uno + 6.month).end_of_month.day.to_i)
                    prima_junio = ciclo.cantidad/365*((fecha_uno + 7.month).end_of_month.day.to_i)
                    prima_julio = ciclo.cantidad/365*((fecha_uno + 8.month).end_of_month.day.to_i)
                    prima_agosto = ciclo.cantidad/365*((fecha_uno + 9.month).end_of_month.day.to_i)
                    prima_septiembre = ciclo.cantidad/365*14
                    # map_costo.each do |cost|
                        
                    # end
                    costo.each do |cost|
                        if cost[0][1] == "01" 
                            array_porcentaje.push(((cost[1]/prima_enero) * 100))
                        end
                        if cost[0][1] == "02" 
                            array_porcentaje.push(((cost[1]/ prima_febrero) * 100))
                            #byebug
                        end
                        if cost[0][1] == "03" 
                            array_porcentaje.push(((cost[1]/prima_marzo) * 100))
                        end
                        if cost[0][1] == "04" 
                            array_porcentaje.push(((cost[1]/ prima_abril) * 100))
                        end
                        if cost[0][1] == "05" 
                            array_porcentaje.push(((cost[1] / prima_mayo)* 100))
                        end
                        if cost[0][1] == "06" 
                            array_porcentaje.push(((cost[1] / prima_junio) * 100))
                        end
                        if cost[0][1] == "07" 
                            array_porcentaje.push(((cost[1] / prima_julio) * 100))
                        end
                        if cost[0][1] == "08" 
                            array_porcentaje.push(((cost[1] / prima_agosto) * 100))
                        end
                        if cost[0][1] == "09" 
                            array_porcentaje.push(((cost[1] / prima_septiembre) * 100))
                        end
                        if cost[0][1] == "10" 
                            array_porcentaje.push(((cost[1] / prima_octubre) * 100))
                        end
                        if cost[0][1] == "11" 
                            array_porcentaje.push(((cost[1] / prima_noviembre) * 100))
                        end
                        if cost[0][1] == "12" 
                            array_porcentaje.push(((cost[1] / prima_diciembre) * 100))
                        end
                    end
                else
                    if area == "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area != "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area == "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area != "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    end
                    resultado = mes_anio.zip(costo)
                    map_mes = mes_anio
                    map_costo = costo.map{|x|x[1]}
                    array_porcentaje = Array.new
                    sumatoria = 0
                    costo.each do |cost|
                        sumatoria += cost[1]
                    end
                    costo.each do |cost|
                        array_porcentaje.push((cost[1] / sumatoria) * 100)
                    end
                end
                resultado = map_mes.zip(array_porcentaje)
                #byebug
                return resultado
            end
        elsif empresa != ""
            anio = fecha_inicio.to_date.year
                    if fecha_inicio.to_date.month <= 9
                        anio -= 1
                    end
            ciclo = AnnualAmountsPaid.find_by(anio_inicio: anio, anio_fin: anio + 1)
            #byebug
            if ciclo 
                if tipo == "0"
                    if area == "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area != "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area == "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area != "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    end
                    resultado = mes_anio.zip(costo)

                    #map_mes = mes_anio.map{|x| x.sucursal}
                    map_mes = mes_anio
                    #map_mes_numero = mes_anio.map{|x| "#{x.mes_numero}"}
                    map_costo = costo.map{|x|x[1]}
                    array_porcentaje = Array.new

                    anio = fecha_inicio.to_date.year
                    if fecha_inicio.to_date.month <= 9
                        anio -= 1
                    end
                    fecha_uno = "#{anio}-11-01".to_date
                    prima_octubre = ciclo.cantidad/365*17
                    prima_noviembre = ciclo.cantidad/365*(fecha_uno.end_of_month.day.to_i)
                    prima_diciembre = ciclo.cantidad/365*((fecha_uno + 1.month).end_of_month.day.to_i)
                    prima_enero = ciclo.cantidad/365*((fecha_uno + 2.month).end_of_month.day.to_i)
                    prima_febrero = ciclo.cantidad/365*((fecha_uno + 3.month).end_of_month.day.to_i)
                    prima_marzo = ciclo.cantidad/365*((fecha_uno + 4.month).end_of_month.day.to_i)
                    prima_abril = ciclo.cantidad/365*((fecha_uno + 5.month).end_of_month.day.to_i)
                    prima_mayo = ciclo.cantidad/365*((fecha_uno + 6.month).end_of_month.day.to_i)
                    prima_junio = ciclo.cantidad/365*((fecha_uno + 7.month).end_of_month.day.to_i)
                    prima_julio = ciclo.cantidad/365*((fecha_uno + 8.month).end_of_month.day.to_i)
                    prima_agosto = ciclo.cantidad/365*((fecha_uno + 9.month).end_of_month.day.to_i)
                    prima_septiembre = ciclo.cantidad/365*14
                    # map_costo.each do |cost|
                        #byebug
                    # end
                    costo.each do |cost|
                        if cost[0][1] == "01" 
                            array_porcentaje.push(((cost[1]/prima_enero) * 100))
                        end
                        if cost[0][1] == "02" 
                            array_porcentaje.push(((cost[1]/ prima_febrero) * 100))
                            #byebug
                        end
                        if cost[0][1] == "03" 
                            array_porcentaje.push(((cost[1]/prima_marzo) * 100))
                        end
                        if cost[0][1] == "04" 
                            array_porcentaje.push(((cost[1]/ prima_abril) * 100))
                        end
                        if cost[0][1] == "05" 
                            array_porcentaje.push(((cost[1] / prima_mayo)* 100))
                        end
                        if cost[0][1] == "06" 
                            array_porcentaje.push(((cost[1] / prima_junio) * 100))
                        end
                        if cost[0][1] == "07" 
                            array_porcentaje.push(((cost[1] / prima_julio) * 100))
                        end
                        if cost[0][1] == "08" 
                            array_porcentaje.push(((cost[1] / prima_agosto) * 100))
                        end
                        if cost[0][1] == "09" 
                            array_porcentaje.push(((cost[1] / prima_septiembre) * 100))
                        end
                        if cost[0][1] == "10" 
                            array_porcentaje.push(((cost[1] / prima_octubre) * 100))
                        end
                        if cost[0][1] == "11" 
                            array_porcentaje.push(((cost[1] / prima_noviembre) * 100))
                        end
                        if cost[0][1] == "12" 
                            array_porcentaje.push(((cost[1] / prima_diciembre) * 100))
                        end
                        #byebug
                    end
                else
                    if area == "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area != "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area == "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area != "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    end
                    resultado = mes_anio.zip(costo)
                    map_mes = mes_anio
                    map_costo = costo.map{|x|x[1]}
                    array_porcentaje = Array.new
                    sumatoria = 0
                    costo.each do |cost|
                        sumatoria += cost[1]
                    end
                    #byebug
                    costo.each do |cost|
                        array_porcentaje.push((cost[1] / sumatoria) * 100)
                    end
                #byebug
                end
                resultado = map_mes.zip(array_porcentaje)

                #byebug
                return resultado
            end
        else
            #SIN EMPRESA SI CEDIS 
            anio = fecha_inicio.to_date.year
                    if fecha_inicio.to_date.month <= 9
                        anio -= 1
                    end
            ciclo = AnnualAmountsPaid.find_by(anio_inicio: anio, anio_fin: anio + 1)
            #byebug
            if ciclo 
                if tipo == "0"
                    if area == "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where( fecha: fecha_inicio..fecha_fin).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area != "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where( fecha: fecha_inicio..fecha_fin, catalog_area_id: area).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area == "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where( fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    elsif area != "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where( fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal', 'mes_numero','costo').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal, :mes_numero).sum(:costo)
                    end
                    resultado = mes_anio.zip(costo)

                    #map_mes = mes_anio.map{|x| x.sucursal}
                    map_mes = mes_anio
                    #map_mes_numero = mes_anio.map{|x| "#{x.mes_numero}"}
                    map_costo = costo.map{|x|x[1]}
                    array_porcentaje = Array.new

                    anio = fecha_inicio.to_date.year
                    if fecha_inicio.to_date.month <= 9
                        anio -= 1
                    end
                    fecha_uno = "#{anio}-11-01".to_date
                    prima_octubre = ciclo.cantidad/365*17
                    prima_noviembre = ciclo.cantidad/365*(fecha_uno.end_of_month.day.to_i)
                    prima_diciembre = ciclo.cantidad/365*((fecha_uno + 1.month).end_of_month.day.to_i)
                    prima_enero = ciclo.cantidad/365*((fecha_uno + 2.month).end_of_month.day.to_i)
                    prima_febrero = ciclo.cantidad/365*((fecha_uno + 3.month).end_of_month.day.to_i)
                    prima_marzo = ciclo.cantidad/365*((fecha_uno + 4.month).end_of_month.day.to_i)
                    prima_abril = ciclo.cantidad/365*((fecha_uno + 5.month).end_of_month.day.to_i)
                    prima_mayo = ciclo.cantidad/365*((fecha_uno + 6.month).end_of_month.day.to_i)
                    prima_junio = ciclo.cantidad/365*((fecha_uno + 7.month).end_of_month.day.to_i)
                    prima_julio = ciclo.cantidad/365*((fecha_uno + 8.month).end_of_month.day.to_i)
                    prima_agosto = ciclo.cantidad/365*((fecha_uno + 9.month).end_of_month.day.to_i)
                    prima_septiembre = ciclo.cantidad/365*14
                    # map_costo.each do |cost|
                        #byebug
                    # end
                    costo.each do |cost|
                        if cost[0][1] == "01" 
                            array_porcentaje.push(((cost[1]/prima_enero) * 100))
                        end
                        if cost[0][1] == "02" 
                            array_porcentaje.push(((cost[1]/ prima_febrero) * 100))
                            #byebug
                        end
                        if cost[0][1] == "03" 
                            array_porcentaje.push(((cost[1]/prima_marzo) * 100))
                        end
                        if cost[0][1] == "04" 
                            array_porcentaje.push(((cost[1]/ prima_abril) * 100))
                        end
                        if cost[0][1] == "05" 
                            array_porcentaje.push(((cost[1] / prima_mayo)* 100))
                        end
                        if cost[0][1] == "06" 
                            array_porcentaje.push(((cost[1] / prima_junio) * 100))
                        end
                        if cost[0][1] == "07" 
                            array_porcentaje.push(((cost[1] / prima_julio) * 100))
                        end
                        if cost[0][1] == "08" 
                            array_porcentaje.push(((cost[1] / prima_agosto) * 100))
                        end
                        if cost[0][1] == "09" 
                            array_porcentaje.push(((cost[1] / prima_septiembre) * 100))
                        end
                        if cost[0][1] == "10" 
                            array_porcentaje.push(((cost[1] / prima_octubre) * 100))
                        end
                        if cost[0][1] == "11" 
                            array_porcentaje.push(((cost[1] / prima_noviembre) * 100))
                        end
                        if cost[0][1] == "12" 
                            array_porcentaje.push(((cost[1] / prima_diciembre) * 100))
                        end
                        #byebug
                    end
                else
                    if area == "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(fecha: fecha_inicio..fecha_fin).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area != "" and vehiculo == ""
                        mes_anio = DamagedPercentage.select('sucursal').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area == "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    elsif area != "" and vehiculo != ""
                        mes_anio = DamagedPercentage.select('sucursal').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).group(:sucursal).order(sucursal: :asc)
                        costo = DamagedPercentage.select('sucursal','costo').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal).sum(:costo)
                    end
                    resultado = mes_anio.zip(costo)
                    map_mes = mes_anio
                    map_costo = costo.map{|x|x[1]}
                    array_porcentaje = Array.new
                    sumatoria = 0
                    costo.each do |cost|
                        sumatoria += cost[1]
                    end
                    costo.each do |cost|
                        array_porcentaje.push((cost[1] / sumatoria) * 100)
                    end
                end
                resultado = map_mes.zip(array_porcentaje)
                return resultado
            end
        end
    end
end