class InsuranceBeneficiary < ApplicationRecord
    has_many :vehicles
    validates :clave,:descripcion, uniqueness: true
    validates :clave,:descripcion, presence: true
    validates :status, inclusion: { in: [true, false] }
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
    def self.listado_beneficiado
      InsuranceBeneficiary.where(status:true).order(descripcion: :asc)
    end
    
end
