class CatalogModel < ApplicationRecord
    has_many :vehicles
    has_many :purchase_details
    has_many :monthly_yields

    validates :clave,:descripcion, uniqueness: true
    validates :clave,:descripcion, presence: true

    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
    def self.listado_modelo
        CatalogModel.where(status:true).order(descripcion: :asc)
    end
end
