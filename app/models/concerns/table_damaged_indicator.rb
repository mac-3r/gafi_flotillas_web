class TableDamagedIndicator < ActiveRecord::Base
  
    def readonly?
        true
    end

    def self.tabla(empresa, cedis, fecha, anio, tipo, area, vehiculo)
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
        arreglo_tabla = Array.new
        if cedis != ""
            if area == "" and vehiculo == ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id",'sum(costo) as sumatoria').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal,:sucursal_id)
            elsif area != "" and vehiculo == ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id",'sum(costo) as sumatoria').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal,:sucursal_id)
            elsif area == "" and vehiculo != ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id",'sum(costo) as sumatoria').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal,:sucursal_id)
            elsif area != "" and vehiculo != ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id",'sum(costo) as sumatoria').where(id_empresa: empresa, sucursal_id: cedis, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal,:sucursal_id)
            end
            
            sumatoria = 0
            consulta1.each do |cons|
                sumatoria += cons.sumatoria
            end

            consulta1.each do |cons|
                hash = Hash.new
                hash["sucursal"] = cons.sucursal
                if area == "" and vehiculo == ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0).count
                elsif area != "" and vehiculo == ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, catalog_area_id: area).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, catalog_area_id: area).count
                elsif area == "" and vehiculo != ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, vehicle_id: vehiculo).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, vehicle_id: vehiculo).count
                elsif area != "" and vehiculo != ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, catalog_area_id: area, vehicle_id: vehiculo).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, catalog_area_id: area, vehicle_id: vehiculo).count
                end
                hash["total_siniestros"] = consulta2
                hash["num_siniestros"] = consulta_si + consulta_no
                hash["resp_si"] = consulta_si
                hash["resp_no"] = consulta_no
                hash["calculo"] = (cons.sumatoria / sumatoria) * 100
                arreglo_tabla.push(hash)
            end

        #byebug
        elsif empresa != ""
            if area == "" and vehiculo == ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id",'sum(costo) as sumatoria').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal,  :sucursal_id)
            elsif area != "" and vehiculo == ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id",'sum(costo) as sumatoria').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal,  :sucursal_id)
            elsif area == "" and vehiculo != ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id",'sum(costo) as sumatoria').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal,  :sucursal_id)
            elsif area != "" and vehiculo != ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id",'sum(costo) as sumatoria').where(id_empresa: empresa,  fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal,  :sucursal_id)
            end

            sumatoria = 0
            consulta1.each do |cons|
                sumatoria += cons.sumatoria
            end

            consulta1.each do |cons|
                hash = Hash.new
                hash["sucursal"] = cons.sucursal
                if area == "" and vehiculo == ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0).count
                elsif area != "" and vehiculo == ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, catalog_area_id: area).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, catalog_area_id: area).count
                elsif area == "" and vehiculo != ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, vehicle_id: vehiculo).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, vehicle_id: vehiculo).count
                elsif area != "" and vehiculo != ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, catalog_area_id: area, vehicle_id: vehiculo).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, catalog_area_id: area, vehicle_id: vehiculo).count
                end
                hash["total_siniestros"] = consulta2
                hash["num_siniestros"] = consulta_si + consulta_no
                hash["resp_si"] = consulta_si
                hash["resp_no"] = consulta_no
                hash["calculo"] = (cons.sumatoria / sumatoria) * 100
                arreglo_tabla.push(hash)
            end
        else
            
            if area == "" and vehiculo == ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id","id_empresa",'sum(costo) as sumatoria').where(fecha: fecha_inicio..fecha_fin).order(sucursal: :asc).group(:sucursal,:sucursal_id,:id_empresa)
            elsif area != "" and vehiculo == ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id","id_empresa",'sum(costo) as sumatoria').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area).order(sucursal: :asc).group(:sucursal,:sucursal_id,:id_empresa)
            elsif area == "" and vehiculo != ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id","id_empresa",'sum(costo) as sumatoria').where(fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal,:sucursal_id,:id_empresa)
            elsif area != "" and vehiculo != ""
                ciclo = AnnualAmountsPaid.find_by(anio_inicio: fecha_inicio.to_date.year.to_i, anio_fin: fecha_inicio.to_date.year.to_i + 1)
                consulta1 = TableDamagedIndicator.select("sucursal", "sucursal_id","id_empresa",'sum(costo) as sumatoria').where(fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc).group(:sucursal,:sucursal_id,:id_empresa)
            end
            sumatoria = 0
            consulta1.each do |cons|
                sumatoria += cons.sumatoria
            end
            
            consulta1.each do |cons|
                hash = Hash.new
                hash["sucursal"] = cons.sucursal
                if area == "" and vehiculo == ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0).count
                elsif area != "" and vehiculo == ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, catalog_area_id: area).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, catalog_area_id: area).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, catalog_area_id: area).count
                elsif area == "" and vehiculo != ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, vehicle_id: vehiculo).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, vehicle_id: vehiculo).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, vehicle_id: vehiculo).count
                elsif area != "" and vehiculo != ""
                    consulta2 = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, catalog_area_id: area, vehicle_id: vehiculo).sum(:costo)
                    consulta_si = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 1, catalog_area_id: area, vehicle_id: vehiculo).count
                    consulta_no = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin, respon_gafi: 0, catalog_area_id: area, vehicle_id: vehiculo).count
                end
                #conteo = TableDamagedIndicator.where(id_empresa: cons.id_empresa, sucursal_id: cons.sucursal_id, fecha: fecha_inicio..fecha_fin).count
                hash["total_siniestros"] = consulta2
                hash["num_siniestros"] = consulta_si + consulta_no
                hash["resp_si"] = consulta_si
                hash["resp_no"] = consulta_no
                hash["calculo"] = (cons.sumatoria / sumatoria) * 100
                arreglo_tabla.push(hash)
            end
        end
        return arreglo_tabla
    end

end