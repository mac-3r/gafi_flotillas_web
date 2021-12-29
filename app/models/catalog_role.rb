class CatalogRole < ApplicationRecord
    validates :clave,:nombre, uniqueness: true
    validates :clave,:nombre, presence: true
    #has_many :users
    has_many :catalog_roles_users
    has_many :users, through: :catalog_roles_users
    has_and_belongs_to_many :permissions
    has_many :competition_tables
    attr_accessor :seleccionado

    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
    def self.listado_roles
        CatalogRole.where(status:true).order(nombre: :asc)
    end

    def self.crear_rol(params)
        bandera_error = 4
        mensaje = ""
        begin
            nombre = params[:rol][:nombre]
            rol_exis = CatalogRole.find_by(nombre: nombre)
            if rol_exis
                bandera_error = 1
                mensaje = "El rol ya fue capturado anteriormente."
            else
                rol = CatalogRole.create(descripcion: params[:rol][:descripcion], nombre: nombre)
                if rol.save
                    mensaje = "El rol fue registrado con éxito."
                else
                    bandera_error = 3
                    rol.errors.full_messages.each do |error|
                        mensaje += "#{error}. "
                    end
                end
            end
        rescue Exception => error
            bandera_error = 3
            mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
        end
        return bandera_error, mensaje
    end

    def self.editar_rol(params)
        bandera_error = 4
        mensaje = ""
        begin
            nombre = params[:rol][:nombre]
            descripcion = params[:rol][:descripcion]
            rol_exis = CatalogRole.find_by(id: params[:id])
            if rol_exis
                rol = rol_exis
                if rol.update(nombre: nombre, descripcion: descripcion)
                    mensaje = "El rol fue actualizado con éxito."
                else
                    bandera_error = 3
                    rol.errors.full_messages.each do |error|
                        mensaje += "#{error}. "
                    end
                end
            else
                bandera_error = 1
                mensaje = "No se encontró el rol o no se puede modificar."
            end
        rescue Exception => error
            bandera_error = 3
            mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
        end
        return bandera_error, mensaje
    end

    def self.roles_x_usuario (id)
        usu_rol=User.find(id).catalog_roles
        roles = CatalogRole.all

        roles.each do |rol|
            if usu_rol.exists?(rol.id)
                rol.seleccionado = true
            end
        end
        roles   
     end

     def self.add_roles(id, roles)
        usuario= User.find(id)
        if !roles.nil?
            roles = CatalogRole.where(id: roles)
            usuario.catalog_roles =(roles)
        else
            usuario.catalog_roles.clear
            usuario.save
        end
        
    end
end
