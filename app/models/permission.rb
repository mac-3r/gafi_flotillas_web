class Permission < ApplicationRecord
    has_and_belongs_to_many :catalog_roles
    #validates :nombre, uniqueness: true
    validates_uniqueness_of :nombre, case_sensitive: true
    attr_accessor :seleccionado 
    
    def self.permisos_x_rol(id)
        perm_rol = CatalogRole.find_by(id: id).permissions
        permisos = Permission.all.order(menu: :asc,  nombre: :asc)
        permisos.each do |permiso|
            #if perm_rol.exists?(permiso.id)
            if permiso.id.in?(perm_rol.map{|x|x.id})
                permiso.seleccionado = true
            end
        end
        #byebug
        permisos 
    end
    def self.add_permisos(id, permisos)
        rol= CatalogRole.find_by(id: id)
        if !permisos.nil?
            permisos = Permission.where(id: permisos)
            rol.permissions =(permisos)
        else
            rol.permissions.clear
            rol.save
        end
    
    end   
end
