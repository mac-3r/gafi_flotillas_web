class VehiclePrice < ApplicationRecord
  belongs_to :catalog_brand
  validates :monto, presence: true
  validates :status, inclusion: { in: [true, false] }
  def get_status
    return self.status ? "Activo" : "Inactivo"
  end
end
