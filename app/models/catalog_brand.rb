class CatalogBrand < ApplicationRecord
    has_many :vehicle_prices
    has_many :budget_details
    has_many :budget_distibutions
    has_many :monthly_yields
    has_many :tuning_prices
    has_many :expense_vehicle_types
    has_many :catalog_considerations
    has_many :mechanical_reviews
    has_many :purchase_details
    has_many :frequency_concepts

    validates :clave,:descripcion, uniqueness: true
    validates :clave,:descripcion, presence: true

    def self.listado_lineas
        CatalogBrand.where(status:true).order(descripcion: :asc)
    end
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
end
