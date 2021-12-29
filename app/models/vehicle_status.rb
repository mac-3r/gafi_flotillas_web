class VehicleStatus < ApplicationRecord
    has_many :vehicles
    validates :nombre,:descripcion, uniqueness: true
    validates :nombre,:descripcion, presence: true
    validates :status, inclusion: { in: [true, false] }
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
    def self.listado_status
      VehicleStatus.where(status:true).order(descripcion: :asc)
  end
end
