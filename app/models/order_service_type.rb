class OrderServiceType < ApplicationRecord
    validates :nombre,:origen,:descripcion, presence: true
    has_many :service_orders
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
    def self.listado_ordenes
        OrderServiceType.where(status:true)
    end
end
