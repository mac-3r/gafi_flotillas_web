class CatalogCompany < ApplicationRecord
    has_many :catalog_branches
    has_many :vehicles
    has_many :cost_centers
    has_many :budget_concepts
    has_many :purchase_orders
    has_many :customers
    has_many :delivery_addresses
    validates :clave,:nombre, uniqueness: true
    validates :nombre,:clave,:domicilio,:codigo_postal,:telefono,:rfc, presence: true
    validates :abreviatura, length: { maximum: 3 }

    def self.listado_empresas
        CatalogCompany.where(status:true).order(nombre: :asc)
    end
    
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
end
