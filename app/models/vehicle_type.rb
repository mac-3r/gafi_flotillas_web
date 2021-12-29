class VehicleType < ApplicationRecord
    has_many :vehicle_checklists
    has_many :perform_targets
    has_many :vehicles
    has_many :vehicle_indicators
    has_many :purchase_details
    has_many :monthly_yields

    validates :clave,:descripcion, uniqueness: true
    validates :clave,:descripcion,:rendimiento_ideal, presence: true
    validates :status, inclusion: { in: [true, false] }

    def get_status
        return self.status ? "Activo" : "Inactivo"
    end

    def self.listado_tipos
        VehicleType.where(status:true).order(descripcion: :asc)
    end
end

