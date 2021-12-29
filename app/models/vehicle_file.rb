class VehicleFile < ApplicationRecord
  belongs_to :vehicle
  has_one_attached :documento
  enum tipo_archivo: {"Licencia de conducir": "001", "Fotografía del vehículo": "002", "Fotografía del vehículo siniestrado": "003","Factura del vehículo": "004","Factura aseguradora": "005","Factura de adaptación": "006","Permiso federal": "007","Permiso físico mecánico": "008","Permiso ambiental": "009","Tarjeta de circulación": "010"}

  def self.consulta_documentos(vehiculo,fecha)
    cadena_consulta = ""

    if vehiculo != ""
      cadena_consulta += " vehicles.id = #{vehiculo} and"
    end
    if fecha != ""
      cadena_consulta += " vehicle_files.fecha_vencimiento = '#{fecha.strftime("%Y-%m-%d")}'"
    else
      cadena_consulta += " vehicle_files.fecha_vencimiento between '#{Time.now.beginning_of_year.strftime("%Y-%m-%d")}' and '#{Time.now.strftime("%Y-%m-%d")}'"      
    end

    consulta = VehicleFile.joins(:vehicle).where(cadena_consulta).order(fecha_vencimiento: :asc)
    return consulta  
  end

end
