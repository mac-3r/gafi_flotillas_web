class VehiclePermit < ApplicationRecord
    belongs_to :vehicle
    validates :descripcion,:fecha_vigencia, presence: true
    validates :status, inclusion: { in: [true, false] }
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
    def self.listado_permisos
        VehiclePermit.all
    end
end
