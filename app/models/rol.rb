class Rol < ApplicationRecord
    has_many :rols_users
    has_many :users, through: :rols_users
    has_and_belongs_to_many :permissions

    attr_accessor :seleccionado
    def self.crear_rol(params)
        bandera_error = 4
        mensaje = ""
        begin
            nombre = params[:rol][:nombre]
            rol_exis = Rol.find_by(nombre: nombre)
            if rol_exis
                bandera_error = 1
                mensaje = "El rol ya fue capturado anteriormente."
            else
                rol = Rol.create(descripcion: params[:rol][:descripcion], nombre: nombre)
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
            mensaje += "Ocurrió un error desconocido: #{error}. Favor de consultar al área de soporte."
        end
        return bandera_error, mensaje
    end

    def self.editar_rol(params)
        bandera_error = 4
        mensaje = ""
        begin
            nombre = params[:rol][:nombre]
            descripcion = params[:rol][:descripcion]
            rol_exis = Rol.find_by(id: params[:id])
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
            mensaje += "Ocurrió un error desconocido: #{error}. Favor de consultar al área de soporte."
        end
        return bandera_error, mensaje
    end

    def self.roles_x_usuario (id)
        usu_rol=User.find(id).rols
        roles = Rol.all

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
            roles = Rol.where(id: roles)
            usuario.rols =(roles)
        else

            usuario.rols.clear
            usuario.save
        end
        
     end
end
