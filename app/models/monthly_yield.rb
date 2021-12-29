class MonthlyYield < ApplicationRecord
  belongs_to :vehicle
  belongs_to :catalog_branch
  belongs_to :vehicle_type
  belongs_to :catalog_model
  belongs_to :catalog_brand

  def self.import_yields(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    arreglo_reportes = Array.new()
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        hash_reporte = Hash.new

        if row["# Unidad"]
          #quita los espacios en blanco al incio y al final
          vehiculo = Vehicle.find_by(numero_economico: row["# Unidad"].to_s.strip)
          cedis = CatalogBranch.find_by(decripcion: row["Cedis"].to_s.strip)
          tipo = VehicleType.find_by(descripcion: row["Tipo de Vehículo"].to_s.strip)
          linea = CatalogBrand.find_by(descripcion: row["Modelo"].to_s.strip)
          modelo = CatalogModel.find_by(descripcion: row["Año"].to_s.strip)

          #byebug
          #validacion para campos foraneos
          if !vehiculo
            hash_reporte["Problema"] = "El vehiculo con el numero economico #{row["# Unidad"]} no se encuentra registrado en el maestro de vehículos, verifique por favor..."
            hash_reporte["fila"] = i
            arreglo_reportes.push(hash_reporte)
            next
         end
         if !cedis
            hash_reporte["Problema"] = "El CEDIS #{row["Cedis"]} no se encuentra registrado en el catálogo de CEDIS, verifique por favor..."
            hash_reporte["fila"] = i
            arreglo_reportes.push(hash_reporte)
            next
          end
          if !tipo
            hash_reporte["Problema"] = "El tipo de vehículo #{row["Tipo de Vehículo"]} no se encuentra registrado en el catálogo de Tipos de vehículo, verifique por favor..."
            hash_reporte["fila"] = i
            arreglo_reportes.push(hash_reporte)
            next
          end
          if !linea
            hash_reporte["Problema"] = "La Linea del vehiculo#{row["Modelo"]} no se encuentra registrado en el catálogo de Líneas, verifique por favor..."
            hash_reporte["fila"] = i
            arreglo_reportes.push(hash_reporte)
            next
          end
          if !modelo
            hash_reporte["Problema"] = "El modelo del vehiculo#{row["Año"]} no se encuentra registrado en el catálogo de modelos, verifique por favor..."
            hash_reporte["fila"] = i
            arreglo_reportes.push(hash_reporte)
            next
          end
          begin
              store_info = MonthlyYield.create(vehicle_id:vehiculo.id,catalog_branch_id:cedis.id,vehicle_type_id:tipo.id,catalog_brand_id:linea.id,catalog_model_id:modelo.id,
                cierre_enero:row["Cierre Enero"],recorrido_enero:row["Recorrido Enero"], lts_enero:row["Lts Enero"],cierre_febrero:row["Cierre Febrero"], recorrido_febrero:row["Recorrido Febrero"],lts_febrero:row["Lts Febrero"],
                cierre_marzo:row["Cierre Marzo"],recorrido_marzo:row["Recorrido Marzo"], lts_marzo:row["Lts Marzo"],cierre_abril:row["Cierre Abril"],recorrido_abril:row["Recorrido Abril"], lts_abril:row["Lts Abril"],
                cierre_mayo:row["Cierre Mayo"],recorrido_mayo:row["Recorrido Mayo"], lts_mayo:row["Lts Mayo"],cierre_junio:row["Cierre Junio"],recorrido_junio:row["Recorrido Junio"], lts_junio:row["Lts Junio"],
                cierre_julio:row["Cierre Julio"],recorrido_julio:row["Recorrido Julio"], lts_julio:row["Lts Julio"],cierre_agosto:row["Cierre Agosto"],recorrido_agosto:row["Recorrido Agosto"], lts_agosto:row["Lts Agosto"],
                cierre_septiembre:row["Cierre Septiembre"],recorrido_septiembre:row["Recorrido Septiembre"], lts_septiembre:row["Lts Septiembre"],cierre_octubre:row["Cierre Octubre"],recorrido_octubre:row["Recorrido Octubre"], lts_octubre:row["Lts Octubre"],
                cierre_noviembre:row["Cierre Noviembre"],recorrido_noviembre:row["Recorrido Noviembre"],lts_noviembre:row["Lts Noviembre"],cierre_diciembre:row["Cierre Diciembre"],recorrido_diciembre:row["Recorrido Diciembre"],lts_diciembre:row["Lts Diciembre"],
                rendi_enero:row["Rendimiento Enero"],rendi_febrero:row["Rendimiento Febrero"],rendi_marzo:row["Rendimiento Marzo"],rendi_abril:row["Rendimiento Abril"],rendi_mayo:row["Rendimiento Mayo"],rendi_junio:row["Rendimiento Junio"],rendi_julio:row["Rendimiento Julio"],
                rendi_agosto:row["Rendimiento Agosto"],rendi_septiembre:row["Rendimiento Septiembre"],rendi_octubre:row["Rendimiento Octubre"],rendi_noviembre:row["Rendimiento Noviembre"],rendi_diciembre:row["Rendimiento Diciembre"],rendimiento_ideal:row["Rendimiento ideal"])
              if !store_info.save!        
                store_info.errors.full_messages do |error|
                  hash_reporte["Problema"] = error
                  hash_reporte["fila"] = i
                  hash_reporte["Descripción del artículo"] = row["Descripción del artículo"]
                  end
                  arreglo_reportes.push(hash_reporte)
              end
          rescue Exception => error
            hash_reporte["Problema"] = error
            hash_reporte["fila"] = i
              # row["Descripción del artículo"] != "" ? hash_vehiculo["Descripción del artículo"] = row["Descripción del artículo"] :  hash_vehiculo["Descripción del artículo"] = ""
              arreglo_reportes.push(hash_reporte)
          end
        else
          hash_reporte["Problema"] = "Algunos de los campos marcados como obligatorios en el archivo estan vacios, verifique por favor..."
          hash_reporte["fila"] = i
          arreglo_reportes.push(hash_reporte)
        end
    end
    return arreglo_reportes
  end
end
