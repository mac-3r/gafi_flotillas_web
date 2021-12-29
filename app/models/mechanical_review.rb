class MechanicalReview < ApplicationRecord
  belongs_to :catalog_brand
  validates :clave,:descripcion, presence: true
  def get_status
    return self.status ? "Activo" : "Inactivo"
  end
end
