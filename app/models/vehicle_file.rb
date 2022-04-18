class VehicleFile < ApplicationRecord
  belongs_to :vehicle
  has_one_attached :documento
  enum tipo_archivo: {"Licencia de conducir": "001", "Fotografía del vehículo": "002", "Fotografía del vehículo siniestrado": "003","Factura del vehículo": "004","Factura aseguradora": "005","Factura de adaptación": "006","Permiso federal": "007","Permiso físico mecánico": "008","Permiso ambiental": "009","Tarjeta de circulación": "010","Póliza de seguro": "011"}

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

  def self.cambio_tipo(valor)
    if valor == "001"
      return "Licencia de conducir"
    elsif valor == "002"
      return "Fotografía del vehículo"
    elsif valor == "003"
      return "Fotografía del vehículo siniestrado"
    elsif valor == "004"
      return "Factura del vehículo"
    elsif valor == "005"
      return "Factura aseguradora"
    elsif valor == "006"
      return "Factura de adaptación"
    elsif valor == "007"
      return "Permiso federal"
    elsif valor == "008"
      return "Permiso físico mecánico"
    elsif valor == "009"
      return "Permiso ambiental"
    elsif valor == "010"
      return "Tarjeta de circulación"
    elsif valor == "011"
      return "Póliza de seguro"
    else
      return nil
    end
  end
  

end
