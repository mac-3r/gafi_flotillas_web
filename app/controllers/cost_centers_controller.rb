class CostCentersController < ApplicationController
  before_action :set_cost_center, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /cost_centers
  # GET /cost_centers.json
  def index
    session["area"] = ""
    session["cedis"] = ""
    @cost_centers = CostCenter.consulta_centros(session["area"],session["cedis"])
  end
 
  def filtrado_centros
    session["area"] = params[:catalog_area_id]
    session["cedis"] = params[:catalog_branch_id]
    @cost_centers = CostCenter.consulta_centros(session["area"],session["cedis"])
    respond_to do |format|
      format.js
    end
  end

  # GET /cost_centers/1
  # GET /cost_centers/1.json
  def show
  end

  # GET /cost_centers/new
  def new
    @cost_center = CostCenter.new
  end

  # GET /cost_centers/1/edit
  def edit
  end

  # POST /cost_centers
  # POST /cost_centers.json
  def create
    begin
    @cost_center = CostCenter.new(cost_center_params)
    if !params[:cost_center][:status].present?
      @cost_center.status = false
    end
    respond_to do |format|
      params[:cost_center][:catalog_company_id] = params[:cost_center][:catalog_company_id]
      params[:cost_center][:catalog_branch_id] = params[:cost_center][:catalog_branch_id]
      if @cost_center.save
        format.html { redirect_to cost_centers_path, notice: 'Se creó correctamente' }
        format.json { render :show, status: :created, location: @cost_center }
      else
        format.html { render :new }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
        format.html { redirect_to cost_centers_path, alert: 'El centro de costo ya existe' }
      end
    end
  end

  # PATCH/PUT /cost_centers/1
  # PATCH/PUT /cost_centers/1.json
  def update
    begin
    if !params[:cost_center][:status].present?
      params[:cost_center][:status] = false
    else
      params[:cost_center][:status] = true
    end
    respond_to do |format|
      if @cost_center.update(cost_center_params)
        format.html { redirect_to cost_centers_path, notice: 'Se actualizo correctamente' }
        format.json { render :show, status: :ok, location: @cost_center }
      else
        format.html { render :edit }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
        format.html { redirect_to cost_centers_path, alert: 'El centro de costo ya existe' }
      end
    end
  end

  # DELETE /cost_centers/1
  # DELETE /cost_centers/1.json
  def destroy
     @cost_center.destroy
     respond_to do |format|
       format.html { redirect_to cost_centers_url, notice: 'Se eliminó correctamente' }
       format.json { head :no_content }
     end
    # cost_center = @cost_center
    # if  cost_center.update(status: 0)
    #   flash[:notice] = "Se eliminó correctamente"
    #    redirect_to cost_centers_path
    #  else
    #    flash[:alert] = "Se eliminó correctamente"
    #    redirect_to  cost_centers_path
    #  end
  end

  def cedis_x_centro
    @numero_economico = Vehicle.where(catalog_branch_id: params[:cedis])
    if params[:comparativo].present?
      @comparacion = true
    else
      @comparacion = false
    end
    respond_to do |format|
      format.js
    end
  end

  def ccosto_x_cedis
    @centro_costos = CostCenter.where(catalog_branch_id: params[:cedis])
  end
  

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_cost_center
      @cost_center = CostCenter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cost_center_params
      params.require(:cost_center).permit(:clave, :descripcion, :status, :catalog_company_id,:catalog_branch_id,:unidad_negocio,:catalog_area_id,:centro_costo)
    end
    def invalid_foreign_key
      redirect_to cost_centers_url, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
