class Responsable < ApplicationRecord
    has_many :vehicles
    belongs_to :catalog_personal ,optional: true

    def self.listado_responsables
        Responsable.all
    end
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
end
