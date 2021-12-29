class CatalogBranchesUsersController < ApplicationController
  before_action :validacion_menu
  def index
    session["usuario"] = ""
    session["cedis"] = ""
    @asignaciones = CatalogBranchesUser.consulta_usuarios(session["usuario"],session["cedis"])
    @cedis_user = CatalogBranchesUser.new
    @usuarios = User.all.order(name: :asc)
    @cedis = CatalogBranch.all
  end
 
  def filtrado_usuarios_cedis
    session["usuario"] = params[:user_id]
    session["cedis"] = params[:catalog_branch_id2]
    @asignaciones = CatalogBranchesUser.consulta_usuarios(session["usuario"],session["cedis"])
    respond_to do |format|
      format.js
    end
  end

  def modal_asignar_cedis
		@cedis_user = CatalogBranchesUser.new
		@usuarios = User.all.order(name: :asc)
		@cedis = CatalogBranch.all
		respond_to do |format|
			format.js
		end
  end
  
  def eliminar_cedis_asignado
		begin
			usuario = User.find_by(id: params[:id_user])
			cedis = CatalogBranch.find_by(id: params[:id_cedis])
			usr_cedis = CatalogRolesUser.where(user_id: params[:id_user], catalog_branch_id: params[:id_cedis])
			if usuario.catalog_branches.delete(cedis)
				@bandera_error = 4
				@mensaje = "CEDIS eliminado al usuario con éxito."
			else
				@bandera_error = 3
				@mensaje = ""
				usr_cedis.errors.full_messages.each do |error|
					@mensaje += "#{error}. "
				end
			end
		rescue Exception => error
			@bandera_error = 3
			@mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
		end
		@asignaciones = CatalogBranchesUser.all
		respond_to do |format|
			format.js
		end
  end
  
    def asignar_cedis
      begin
        usuario = User.find_by(id: params[:catalog_branches_user][:user_id])
        cedis = CatalogBranch.find_by(id: params[:catalog_branch_id])
        #byebug
        if usuario
          if cedis
            existe = CatalogBranchesUser.find_by(user_id: usuario.id, catalog_branch_id: cedis.id)
            if !existe
              usr_cedis = CatalogBranchesUser.create(user_id: usuario.id, catalog_branch_id: cedis.id)
              if usr_cedis.save
                @bandera_error = 4
                @mensaje = "CEDIS asignado con éxito."
              else
                @bandera_error = 3
                @mensaje = ""
                usr_cedis.errors.full_messages.each do |error|
                  @mensaje += "#{error}. "
                end
              end
            else
              @bandera_error = 1
              @mensaje = "El usuario ya tiene el CEDIS asignado."
            end
          else
            @bandera_error = 1
            @mensaje = "No se encontró el CEDIS seleccionado."
          end
        else
          @bandera_error = 1
          @mensaje = "No se encontró el usuario seleccionado."
        end
      rescue Exception => error
        @bandera_error = 3
        @mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
      end
      @asignaciones = CatalogBranchesUser.all
      respond_to do |format|
        format.js
      end
    end
  
    def recarga_datatable_cedis_usuario
      # respond_to do |format|
      # 	format.html
      # 	format.json {render json: UsersRolsDatatable.new(view_context)}
      # end
    end

    private

      def validacion_menu
        session["menu1"] = "Seguridad"
        session["menu2"] = "Usuarios por CEDIS"
      end
  end