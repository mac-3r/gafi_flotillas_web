class CatalogPermitsVehicle < ApplicationRecord
    validates :clave, presence: true
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
end
