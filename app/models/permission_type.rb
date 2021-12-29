class PermissionType < ApplicationRecord

    def self.listado_tipos_permiso
        self.all
    end

    def clave_nombre
        "#{self.clave}.- #{self.descripcion}"
    end
    
end
