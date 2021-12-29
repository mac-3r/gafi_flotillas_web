class CatalogRolesUsersController < ApplicationController
	#load_and_authorize_resource class: CatalogRolesUser
	before_action :validacion_menu
	def index
		session["usuario"] = ""
		session["rol"] = ""
		@asignaciones = CatalogRolesUser.consulta_usuarios_rol(session["usuario"],session["rol"])
		@rol_user = CatalogRolesUser.new
		@usuarios = User.all.order(name: :asc)
		@responsables = Responsable.all
		@roles = CatalogRole.all
	end
	 
	def filtrado_usuarios_rol
		session["usuario"] = params[:user_id]
		session["rol"] = params[:rol_id]
		@asignaciones = CatalogRolesUser.consulta_usuarios_rol(session["usuario"],session["rol"])
		respond_to do |format|
		  format.js
		end
	end

	def modal_asignar_rol
		@rol_user = CatalogRolesUser.new
		@usuarios = User.all.order(name: :asc)
		@responsables = Responsable.all
		@roles = CatalogRole.all
		respond_to do |format|
			format.js
		end
	end

	def eliminar_rol_asignado
		begin
			usuario = User.find_by(id: params[:id_user])
			rol = CatalogRole.find_by(id: params[:id_rol])
			usr_rol = CatalogRolesUser.where(user_id: params[:id_user], catalog_role_id: params[:id_rol])
			if usuario.catalog_roles.delete(rol)
				@bandera_error = 4
				@mensaje = "Rol eliminado al usuario con éxito."
			else
				@bandera_error = 3
				@mensaje = ""
				usr_rol.errors.full_messages.each do |error|
					@mensaje += "#{error}. "
				end
			end
		rescue Exception => error
			@bandera_error = 3
			@mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
		end
		@asignaciones = CatalogRolesUser.all
		respond_to do |format|
			format.js
		end
	end

	def asignar_rol
		begin
			usuario = User.find_by(id: params[:catalog_roles_user][:user_id])
			rol = CatalogRole.find_by(id: params[:catalog_roles_user][:catalog_role_id])
			if usuario
				if rol
					existe = CatalogRolesUser.find_by(user_id: usuario.id, catalog_role_id: rol.id)
					if !existe
						usr_rol = CatalogRolesUser.create(user_id: usuario.id, catalog_role_id: rol.id)
						if usr_rol.save
							@bandera_error = 4
							@mensaje = "Rol asignado con éxito."
						else
							@bandera_error = 3
							@mensaje = ""
							usr_rol.errors.full_messages.each do |error|
								@mensaje += "#{error}. "
							end
						end
					else
						@bandera_error = 1
						@mensaje = "El usuario ya tiene el rol asignado."
					end
				else
					@bandera_error = 1
					@mensaje = "No se encontró el rol seleccionado."
				end
			else
				@bandera_error = 1
				@mensaje = "No se encontró el usuario seleccionado."
			end
		rescue Exception => error
			@bandera_error = 3
			@mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
		end
		@asignaciones = CatalogRolesUser.all
		respond_to do |format|
			format.js
		end
	end

	def recarga_datatable_rol_usuario
		# respond_to do |format|
		# 	format.html
		# 	format.json {render json: UsersRolsDatatable.new(view_context)}
		# end
	end

	private
		def validacion_menu
			session["menu1"] = "Seguridad"
			session["menu2"] = "Roles de usuarios"
      	end
end
