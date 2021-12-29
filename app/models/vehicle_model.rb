class VehicleModel < ApplicationRecord
    has_many :vehicles
    def self.listado_modelos
        VehicleModel.all
    end
end
