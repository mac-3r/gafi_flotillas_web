class CatalogArea < ApplicationRecord
    has_many :catalog_responsives
    has_many :vehicles
    has_many :budget_concepts
    has_many :budget_distibutions
    has_many :budget_sales_replacements
    has_many :accounting_impacts
    has_many :cost_centers
    validates :descripcion, uniqueness: true
    validates :descripcion, presence: true
    has_and_belongs_to_many :sections
    has_many :service_orders

    def self.listado_areas
        CatalogArea.where(status:true).order(descripcion: :asc)
    end

    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
end
