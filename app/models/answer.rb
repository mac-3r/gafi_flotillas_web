class Answer < ApplicationRecord
    enum estatus: {"Activo": 0, "Inactivo":1}

    
    def self.listado_respuestas
        Answer.where(estatus:0).order(descripcion: :asc)
    end

end
