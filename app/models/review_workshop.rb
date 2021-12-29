class ReviewWorkshop < ApplicationRecord
    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
end
