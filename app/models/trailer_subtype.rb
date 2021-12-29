class TrailerSubtype < ApplicationRecord

    def self.listado_tipos_remolque
        self.all
    end

    def clave_nombre
        "#{self.clave}.- #{self.nombre}"
    end

end
