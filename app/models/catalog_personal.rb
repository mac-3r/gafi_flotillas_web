class CatalogPersonal < ApplicationRecord
    validates :clave,:nombre, presence: true
    has_many :catalog_responsives
    has_many :vehicles
    belongs_to :user ,optional: true
    validates :rfc, length: { maximum: 15 }
    has_one :responsable

    def self.listado_personal
        CatalogPersonal.where(estatus: 1).order(nombre: :asc)
    end
end
