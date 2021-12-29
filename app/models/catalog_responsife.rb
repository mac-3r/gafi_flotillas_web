class CatalogResponsife < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_personal
  belongs_to :catalog_area
  validates :correo, presence: true
    validates :status, inclusion: { in: [true, false] }
    def get_status
        return self.status ? "Activo" : "Inactivo"
      end
end
