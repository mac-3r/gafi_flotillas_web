class CatalogoAdaptation < ApplicationRecord
    validates :descripcion, presence: true
    has_many :vehicle_adaptations

    validates :status, inclusion: { in: [true, false] }
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end

    def self.listado_adaptaciones
      CatalogoAdaptation.where(status: true)
    end
end
