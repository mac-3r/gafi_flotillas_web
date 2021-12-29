class CatalogRepairsController < ApplicationController
  before_action :set_catalog_repair, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_repairs
  # GET /catalog_repairs.json
  def index
    reparacion = "#{params[:reparacion]}"

    if reparacion != ""
      @catalog_repairs = CatalogRepair.where("subcategoria LIKE '%#{reparacion}%'").order(categoria: :asc)
    else
      @catalog_repairs = CatalogRepair.all.order(categoria: :asc)
    end
  end

  # GET /catalog_repairs/1
  # GET /catalog_repairs/1.json
  def show
  end

  # GET /catalog_repairs/new
  def new
    @catalog_repair = CatalogRepair.new
  end

  # GET /catalog_repairs/1/edit
  def edit
  end

  # POST /catalog_repairs
  # POST /catalog_repairs.json
  def create
    begin
      @catalog_repair = CatalogRepair.new(catalog_repair_params)
      if !params[:catalog_repair][:status].present?
        @catalog_repair.status = false
        end
      respond_to do |format|
        if @catalog_repair.save
          format.html { redirect_to catalog_repairs_path, notice: 'La reparación se creo con exito.'}
          format.json { render :show, status: :created, location: @catalog_repair }
        else
          format.html { render :new }
          format.json { render json: @catalog_repair.errors, status: :unprocessable_entity }
        end
      end 
    rescue => exception
      redirect_to catalog_repairs_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_repairs/1
  # PATCH/PUT /catalog_repairs/1.json
  def update
    begin
      if !params[:catalog_repair][:status].present?
        params[:catalog_repair][:status] = false
        else
        params[:catalog_repair][:status] = true
        end
      respond_to do |format|
        if @catalog_repair.update(catalog_repair_params)
          format.html { redirect_to catalog_repairs_path, notice: 'La reparación se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @catalog_repair }
        else
          format.html { render :edit }
          format.json { render json: @catalog_repair.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_repairs_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_repairs/1
  # DELETE /catalog_repairs/1.json
  def destroy
    @catalog_repair.destroy
    respond_to do |format|
      format.html { redirect_to catalog_repairs_url, notice: 'La reparación se elimino con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_repair
      @catalog_repair = CatalogRepair.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_repair_params
      params.require(:catalog_repair).permit(:clave, :categoria, :subcategoria, :status,:abreviatura)
    end

    def invalid_foreign_key
      redirect_to catalog_repairs_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
