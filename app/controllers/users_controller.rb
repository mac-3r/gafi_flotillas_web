class UsersController < ApplicationController
  before_action :menu_seleccionado

  def index
    nombre = "#{params[:name]}"
    @user = User.new
    if nombre !=""
      @users = User.where("name LIKE '%#{nombre}%' or last_name LIKE '%#{nombre}%'").order(name: :asc)
    else
      @users = User.all.order(name: :asc)
    end 
  end

  def create_new_user
    if params[:user][:password] == params[:user][:password_confirmation]
      user = User.new(email: params[:user][:email], password: params[:user][:password], name: params[:user][:name], last_name: params[:user][:last_name],user: params[:user][:user])
      if user.save
          flash[:notice] = "Usuario registrado"
          redirect_to users_path
      else
          mensaje = ""
          user.errors.full_messages.each do |message|
              mensaje += message
          end
          flash[:alert] = mensaje
          redirect_to users_path
      end
  else
      flash[:alert] = "No coinciden las contraseñas."
      redirect_to users_path
  end
  end

  def update
    usuario = User.find(params[:user][:id])
        if usuario
          if params[:user][:password].present?
            if usuario.update(name: params[:user][:name], email: params[:user][:email],  password: params[:user][:password],last_name: params[:user][:last_name],user: params[:user][:user])
              flash[:notice] = "Usuario actualizado"
              redirect_to users_path
            else
            mensaje = ""
                
            usuario.errors.full_messages.each do |message|
            mensaje += message
            end
            flash[:alert] = mensaje
            redirect_to users_path
          end
        else
          if usuario.update(name: params[:user][:name], email: params[:user][:email],last_name: params[:user][:last_name],user: params[:user][:user])
            flash[:notice] = "Usuario actualizado"
            redirect_to users_path
          else
          mensaje = ""
                
          usuario.errors.full_messages.each do |message|
          mensaje += message
          end
          flash[:alert] = mensaje
          redirect_to users_path
        end
      end
    else
      flash[:alert] = "No se encontró el usuario"
      redirect_to users_path
    end
  end

  def destroy
  end

  def ajax_seguridad_add_roles
    id= params[:id]
    Role.add_roles(id, params[:roles])
    @usuario =User.find(id)
    @roles =Role.roles_x_usuario(id)
    
    respond_to do |format|
        format.js
    end
end

def desactivar_usuario
  usuario = User.find_by(id: params[:id_usuario])
  if usuario
      if usuario.estatus
          usuario.update(estatus: false)
          flash[:notice] = "Usuario deshabilitado con éxito."
      else
          usuario.update(estatus: true)
          flash[:notice] = "Usuario habilitado con éxito."
      end
  else
      flash[:alert] = "No se encontró el usuario seleccionado"
  end
  redirect_to seguridad_path
end

#PERMISOS
def ajax_seguridad_permisos
    @permission = Permission.new
    id= params[:id_rol]
    @rol =CatalogRole.find(id)
    @permisos = Permission.permisos_x_rol(id)
end

def ajax_seguridad_add_permisos
    id= params[:id_rol]
    Permission.add_permisos(id, params[:permisos])
    @rol =CatalogRole.find_by(id: id)
    @permisos = Permission.permisos_x_rol(id)
    
    respond_to do |format|
        format.js
    end
end

  def menu_seleccionado
    session["menu1"] = "Seguridad"
    session["menu2"] = "Usuarios"
  end

end
