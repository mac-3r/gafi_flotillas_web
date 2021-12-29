class VehicleConfiguration < ApplicationRecord

    def self.listado_configuraciones
        self.all
    end
    
    def clave_nombre
        "#{self.clave}.- #{self.descripcion}"
    end

end
