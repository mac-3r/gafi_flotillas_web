class BilledCompany < ApplicationRecord
    has_many :vehicles,dependent: :nullify
    validates :nombre, uniqueness: true
    validates :clave_jd,:nombre, presence: true
    def self.listado_emfac
        BilledCompany.where(status:true).order(nombre: :asc)
    end
    def get_status
      return self.status ? "Activo" : "Inactivo"
    end
end
