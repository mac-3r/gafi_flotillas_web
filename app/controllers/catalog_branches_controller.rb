class CatalogBranchesController < ApplicationController
  before_action :set_catalog_branch, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  # GET /catalog_branches
  # GET /catalog_branches.json
  before_action :validacion_menu
  def index
    @catalog_branches = CatalogBranch.all.order(decripcion: :asc)
  end

  # GET /catalog_branches/1
  # GET /catalog_branches/1.json
  def show
  end

  # GET /catalog_branches/new
  def new
    @catalog_branch = CatalogBranch.new
    @empresas = CatalogCompany.all 
  end

  # GET /catalog_branches/1/edit
  def edit
  end

  # POST /catalog_branches
  # POST /catalog_branches.json
  def create
    begin
      params[:catalog_branch][:catalog_company_id] = params[:catalog_branch][:catalog_company_id]
      @catalog_branch = CatalogBranch.new(catalog_branch_params)
      if !params[:catalog_branch][:status].present?
        @catalog_branch.status = false
        end
      respond_to do |format|
        if @catalog_branch.save
          format.html { redirect_to catalog_branches_path, notice: 'Se creó correctamente' }
          format.json { render :show, status: :created, location: @catalog_branch }
        else
          format.html { render :new }
          format.json { render json: @catalog_branch.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_branches_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_branches/1
  # PATCH/PUT /catalog_branches/1.json
  def update
    begin
      if !params[:catalog_branch][:status].present?
        params[:catalog_branch][:status] = false
        else
        params[:catalog_branch][:status] = true
        end
      respond_to do |format|
        if @catalog_branch.update(catalog_branch_params)
          format.html { redirect_to catalog_branches_path, notice: 'Se actualizó correctamente' }
          format.json { render :show, status: :ok, location: @catalog_branch }
        else
          format.html { render :edit }
          format.json { render json: @catalog_branch.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_branches_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_branches/1
  # DELETE /catalog_branches/1.json
  def destroy
    @catalog_branch.destroy
    respond_to do |format|
      format.html { redirect_to catalog_branches_url, notice: 'Se eliminó correctamente' }
      format.json { head :no_content }
    end
  end

  def cedis_x_empresa_siniestralidad
    @cedis = CatalogBranch.where(status: true, catalog_company_id: params[:empresa]).order(decripcion: :asc)
    if params[:comparativo].present?
      @comparacion = true
    else
      @comparacion = false
    end
    respond_to do |format|
      format.js
    end
  end
  #busca cedis x empresa para los centros costos
  def cedis_x_empresa_centro
    @cedis = CatalogBranch.where(status: true, catalog_company_id: params[:empresa]).order(decripcion: :asc)
    if params[:comparativo].present?
      @comparacion = true
    else
      @comparacion = false
    end
    respond_to do |format|
      format.js
    end
  end
  
  def cedis_x_empresa_vehiculo
    @cedis = CatalogBranch.where(status: true, catalog_company_id: params[:empresa]).order(decripcion: :asc)
    if params[:comparativo].present?
      @comparacion = true
    else
      @comparacion = false
    end
    respond_to do |format|
      format.js
    end
  end

  def cedis_x_empresa_taller
    @cedis = CatalogBranch.where(status: true, catalog_company_id: params[:empresa]).order(decripcion: :asc)
    if params[:comparativo].present?
      @comparacion = true
    else
      @comparacion = false
    end
    respond_to do |format|
      format.js
    end
  end

  def cedis_x_empresa_lista
    @cedis = CatalogBranch.where(status: true, catalog_company_id: params[:empresa]).order(decripcion: :asc)
    if params[:comparativo].present?
      @comparacion = true
    else
      @comparacion = false
    end
    respond_to do |format|
      format.js
    end
  end

  def cedis_x_empresa_gasto
    @cedis = CatalogBranch.where(status: true, catalog_company_id: params[:empresa]).order(decripcion: :asc)
    if params[:comparativo].present?
      @comparacion = true
    else
      @comparacion = false
    end
    respond_to do |format|
      format.js
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_branch
      @catalog_branch = CatalogBranch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_branch_params
      params.require(:catalog_branch).permit(:clave, :clave_jd, :decripcion, :catalog_company_id, :status,:unidad_negocio,:abreviacion)
    end
    def invalid_foreign_key
      redirect_to catalog_branches_url, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
