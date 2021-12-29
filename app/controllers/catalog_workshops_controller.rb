class CatalogWorkshopsController < ApplicationController
  before_action :set_catalog_workshop, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_workshops
  # GET /catalog_workshops.json
  def index
    session["nombre"] = ""
    session["cedis"] = ""
    @catalog_workshops = CatalogWorkshop.consulta_talleres(session["cedis"],session["nombre"])
  end
 
  def filtrado_talleres
    session["nombre"] = params[:nombre_taller]
    session["cedis"] = params[:catalog_branch_id]
    @catalog_workshops = CatalogWorkshop.consulta_talleres(session["cedis"],session["nombre"])
    respond_to do |format|
      format.js
    end
  end

  # GET /catalog_workshops/1
  # GET /catalog_workshops/1.json
  def show
  end

  # GET /catalog_workshops/new
  def new
    @catalog_workshop = CatalogWorkshop.new
  end

  # GET /catalog_workshops/1/edit
  def edit
  end

  # POST /catalog_workshops
  # POST /catalog_workshops.json
  def create
    begin
      @catalog_workshop = CatalogWorkshop.new(catalog_workshop_params)
      if !params[:catalog_workshop][:vigente].present?
        @catalog_workshop.vigente = false
        end
      params[:catalog_workshop][:catalog_branch_id] = params[:catalog_workshop][:catalog_branch_id]
      respond_to do |format|
        if @catalog_workshop.save
          format.html { redirect_to catalog_workshops_path, notice: 'El taller se creo con exito.' }
          format.json { render :show, status: :created, location: @catalog_workshop }
        else
          format.html { render :new }
          format.json { render json: @catalog_workshop.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_workshops_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_workshops/1
  # PATCH/PUT /catalog_workshops/1.json
  def update
    begin
      if !params[:catalog_workshop][:vigente].present?
        params[:catalog_workshop][:vigente] = false
        else
        params[:catalog_workshop][:vigente] = true
        end
      respond_to do |format|
        if @catalog_workshop.update(catalog_workshop_params)
          format.html { redirect_to catalog_workshops_path, notice: 'El taller se actualizo con exito.' }
          format.json { render :show, status: :ok, location: @catalog_workshop }
        else
          format.html { render :edit }
          format.json { render json: @catalog_workshop.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_workshops_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_workshops/1
  # DELETE /catalog_workshops/1.json
  def destroy
    @catalog_workshop.destroy
    respond_to do |format|
      format.html { redirect_to catalog_workshops_url, notice: 'El taller se elimino con exito.' }
      format.json { head :no_content }
    end
  end
  
  def taller_x_cedis
    @taller = CatalogWorkshop.where(vigente: true, catalog_branch_id: params[:cedis])
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
    def set_catalog_workshop
      @catalog_workshop = CatalogWorkshop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_workshop_params
      params.require(:catalog_workshop).permit(:clave, :catalog_branch_id, :nombre_taller, :razonsocial, :especialidad, :responsable, :telefono, :domicilio, :correo, :vigente,:user_id,:catalog_vendor_id)
    end
    def invalid_foreign_key
      redirect_to catalog_workshop, alert: 'Este registro esta siendo usado.'
    end
end
