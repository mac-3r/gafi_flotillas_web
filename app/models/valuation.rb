class Valuation < ApplicationRecord
    has_many :valuations_branches
    has_many :consumptions

    def self.listado_tasas
        Valuation.where(estatus: true).order(descripcion: :asc)
    end
    
end
