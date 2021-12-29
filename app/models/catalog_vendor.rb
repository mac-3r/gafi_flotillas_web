class CatalogVendor < ApplicationRecord
    has_many :purchase_orders
    has_many :consumptions
    has_many :catalog_workshops
    has_many :service_orders
    has_many :maintenance_controls
    has_many :vehicle_adaptations
    belongs_to :user ,optional: true
    has_many :valuations_branches

    def self.listado_proveedor
        CatalogVendor.all.order(razonsocial: :asc)
    end
end
