class MaintenanceFrecuency < ApplicationRecord
  belongs_to :vehicle_type
  belongs_to :catalog_model
  enum tipo: {"Por KM": 0,"Por horas": 1}

  def self.consulta_frecuencias(tipo,modelo)
    cadena_consulta = ""

    if tipo != "" and modelo == ""
      cadena_consulta += " vehicle_type_id = #{tipo}"
    end

    if modelo != "" and tipo == ""
      cadena_consulta += " catalog_model_id = #{modelo}"
    end
    
    if tipo != "" and modelo != ""
      cadena_consulta += " vehicle_type_id = #{tipo} and catalog_model_id = #{modelo}"
    end
    
    consulta = MaintenanceFrecuency.joins(:vehicle_type).where(cadena_consulta).order(descripcion: :asc)
    return consulta  
  end

  def self.importar_frecuencias(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    arreglo_reportes = Array.new()
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      tipo = VehicleType.find_by(descripcion: row["Tipo de vehículo"])
      modelo = CatalogModel.find_by(clave: row["Modelo (Clave)"])
      begin
        guardar = MaintenanceFrecuency.create(vehicle_type_id: tipo.id, catalog_model_id: modelo.id, mensual_recorrido: row["mensual recorrido"], frecuencia: row["Frecuencia de mantenimiento"].to_f / 1000)
        
        if !guardar.save
            guardar.errors.full_messages.each do |error|
              arreglo_reportes.push(error)
            end
        end
      rescue => exception
        
      end
    end
    return arreglo_reportes
  end
end
