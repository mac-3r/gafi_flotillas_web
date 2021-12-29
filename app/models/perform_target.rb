class PerformTarget < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :vehicle_type
  validates :clave, uniqueness: true
  validates :clave,:objperform,:idealperform, presence: true

  def self.listado_tipos
    VehicleType.all
  end

  def get_status
    return self.status ? "Activo" : "Inactivo"
  end
end
