class CatalogRolesUser < ApplicationRecord
    belongs_to :user
    belongs_to :catalog_role

    def self.consulta_usuarios_rol(usuario,rol)
        cadena_consulta = ""
           if usuario != "" and rol != ""
            cadena_consulta += " catalog_roles_users.user_id = #{usuario} and catalog_roles_users.catalog_role_id = #{rol}"
          elsif  rol != "" and usuario == ""
            cadena_consulta += " catalog_roles_users.catalog_role_id = #{rol}"
          elsif  rol == "" and usuario != ""
            cadena_consulta += " catalog_roles_users.user_id = #{usuario}"
          else
            cadena_consulta = ""
          end
            consulta = CatalogRolesUser.joins(:user).where(cadena_consulta).order(name: :asc)
          return consulta  
    end

    # has_many :catalog_roles_users
    # has_many :users, through: :catalog_roles_users
    # has_and_belongs_to_many :permissions

    # attr_accessor :seleccionado
    # def self.crear_rol(params)
    #     bandera_error = 4
    #     mensaje = ""
    #     begin
    #         nombre = params[:rol][:nombre]
    #         rol_exis = CatalogRole.find_by(nombre: nombre)
    #         if rol_exis
    #             bandera_error = 1
    #             mensaje = "El rol ya fue capturado anteriormente."
    #         else
    #             rol = CatalogRole.create(descripcion: params[:rol][:descripcion], nombre: nombre)
    #             if rol.save
    #                 mensaje = "El rol fue registrado con éxito."
    #             else
    #                 bandera_error = 3
    #                 rol.errors.full_messages.each do |error|
    #                     mensaje += "#{error}. "
    #                 end
    #             end
    #         end
    #     rescue Exception => error
    #         bandera_error = 3
    #         mensaje += "Ocurrió un error desconocido: #{error}. Favor de consultar al área de soporte."
    #     end
    #     return bandera_error, mensaje
    # end

    # def self.editar_rol(params)
    #     bandera_error = 4
    #     mensaje = ""
    #     begin
    #         nombre = params[:rol][:nombre]
    #         descripcion = params[:rol][:descripcion]
    #         rol_exis = CatalogRole.find_by(id: params[:id])
    #         if rol_exis
    #             rol = rol_exis
    #             if rol.update(nombre: nombre, descripcion: descripcion)
    #                 mensaje = "El rol fue actualizado con éxito."
    #             else
    #                 bandera_error = 3
    #                 rol.errors.full_messages.each do |error|
    #                     mensaje += "#{error}. "
    #                 end
    #             end
    #         else
    #             bandera_error = 1
    #             mensaje = "No se encontró el rol o no se puede modificar."
    #         end
    #     rescue Exception => error
    #         bandera_error = 3
    #         mensaje += "Ocurrió un error desconocido: #{error}. Favor de consultar al área de soporte."
    #     end
    #     return bandera_error, mensaje
    # end

    # def self.roles_x_usuario (id)
    #     usu_rol=User.find(id).catalog_roles
    #     roles = CatalogRole.all

    #     roles.each do |rol|
    #         if usu_rol.exists?(rol.id)
    #             rol.seleccionado = true
    #         end
    #     end
    #     roles   
    #  end

    #  def self.add_roles(id, roles)
    #     usuario= User.find(id)
    #     if !roles.nil?
    #         roles = CatalogRole.where(id: roles)
    #         usuario.catalog_roles =(roles)
    #     else

    #         usuario.catalog_roles.clear
    #         usuario.save
    #     end
        
    #  end
end
