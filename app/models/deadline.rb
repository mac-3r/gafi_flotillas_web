class Deadline < ApplicationRecord

    def get_status
        return self.estatus ? "Activo" : "Inactivo"
    end

end
