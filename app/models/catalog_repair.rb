class CatalogRepair < ApplicationRecord
    has_many :maintenance_controls
    validates :clave, uniqueness: true
    validates :clave,:categoria,:subcategoria, presence: true
    validates :status, inclusion: { in: [true, false] }
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
    def self.listado_reparaciones
      CatalogRepair.all.order(subcategoria: :asc)
    end
  
end
