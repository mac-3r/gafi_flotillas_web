class GeneralVehicleFile < ApplicationRecord
    has_one_attached :documento
    enum tipo_archivo: {"Licencia de conducir": "001", "Fotografía del vehículo": "002", "Fotografía del vehículo siniestrado": "003","Factura del vehículo": "004","Factura aseguradora": "005","Factura de adaptación": "006","Permiso federal": "007","Permiso físico mecánico": "008","Permiso ambiental": "009","Tarjeta de circulación": "010"}

end
