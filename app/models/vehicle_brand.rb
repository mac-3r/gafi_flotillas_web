class VehicleBrand < ApplicationRecord
    has_many :vehicles
    has_many :purchase_orders
    def self.listado_linea
        VehicleBrand.all
    end
end
