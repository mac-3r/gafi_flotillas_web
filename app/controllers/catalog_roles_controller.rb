class CatalogRolesController < ApplicationController
  before_action :set_catalog_role, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_roles
  # GET /catalog_roles.json
  def index
    @catalog_roles = CatalogRole.order(nombre: :asc)
    #@catalog_roles = CatalogRole.where(status: true)
  end

  # GET /catalog_roles/1
  # GET /catalog_roles/1.json
  def show
  end

  # GET /catalog_roles/new
  def new
    @catalog_role = CatalogRole.new
  end

  # GET /catalog_roles/1/edit
  def edit
  end

  # POST /catalog_roles
  # POST /catalog_roles.json
  def create
    @catalog_role = CatalogRole.new(catalog_role_params)
    if !params[:catalog_role][:status].present?
      @catalog_role.status = false
      end
    respond_to do |format|
      if @catalog_role.save
        format.html { redirect_to catalog_roles_url, notice: 'Se creó correctamente' }
        format.json { render :show, status: :created, location: @catalog_role }
      else
        format.html { render :new }
        format.json { render json: @catalog_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalog_roles/1
  # PATCH/PUT /catalog_roles/1.json
  def update
    if !params[:catalog_role][:status].present?
      params[:catalog_role][:status] = false
      else
      params[:catalog_role][:status] = true
      end
    respond_to do |format|
      if @catalog_role.update(catalog_role_params)
        format.html { redirect_to catalog_roles_url, notice: 'Se actualizó correctamente' }
        format.json { render :show, status: :ok, location: @catalog_role }
      else
        format.html { render :edit }
        format.json { render json: @catalog_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalog_roles/1
  # DELETE /catalog_roles/1.json
  def destroy
     @catalog_role.destroy
     respond_to do |format|
       format.html { redirect_to catalog_roles_url, notice: 'Se eliminó correctamente' }
       format.json { head :no_content }
     end
    end

    def assign_permissions
      @bandera_error = false
      @rol = CatalogRole.find_by(id: params[:id])
      respond_to do |format|
        id= params[:id]
        @permisos = Permission.permisos_x_rol(id)
        format.js
      end
    end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Roles"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_role
      @catalog_role = CatalogRole.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_role_params
      params.require(:catalog_role).permit(:clave, :nombre, :descripcion, :status)
    end
    def invalid_foreign_key
      redirect_to catalog_roles_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
