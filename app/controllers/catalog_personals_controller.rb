class CatalogPersonalsController < ApplicationController
  before_action :set_catalog_personal, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_personals
  # GET /catalog_personals.json
  def index
    keyword = "#{params[:keyword]}"
    if keyword !=""
      @catalog_personals = CatalogPersonal.where("nombre LIKE '%#{keyword}%'").order(nombre: :asc)
    else
      @catalog_personals = CatalogPersonal.all.order(nombre: :asc)
    end 
  end

  # GET /catalog_personals/1
  # GET /catalog_personals/1.json
  def show
  end

  # GET /catalog_personals/new
  def new
    @catalog_personal = CatalogPersonal.new
  end

  # GET /catalog_personals/1/edit
  def edit
  end

  # POST /catalog_personals
  # POST /catalog_personals.json
  def create
    begin
      @catalog_personal = CatalogPersonal.new(catalog_personal_params)
      #byebug
      if !params[:catalog_personal][:estatus].present?
        @catalog_personal.estatus = 0
      else
        @catalog_personal.estatus = 1
      end
      respond_to do |format|
        if @catalog_personal.save
          format.html { redirect_to catalog_personals_path, notice: 'Se agregó empleado con éxito.' }
          format.json { render :show, status: :created, location: @catalog_personal }
        else
          format.html { render :new }
          format.json { render json: @catalog_personal.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_personals_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_personals/1
  # PATCH/PUT /catalog_personals/1.json
  def update
    begin
      if !params[:catalog_personal][:estatus].present?
        params[:catalog_personal][:estatus] = 0
      else
        params[:catalog_personal][:estatus] = 1
      end
      respond_to do |format|
        if @catalog_personal.update(catalog_personal_params)
          format.html { redirect_to catalog_personals_path, notice: 'Se actualizó el empleado con éxito.' }
          format.json { render :show, status: :ok, location: @catalog_personal }
        else
          format.html { render :edit }
          format.json { render json: @catalog_personal.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_personals_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_personals/1
  # DELETE /catalog_personals/1.json
  def destroy
    @catalog_personal.destroy
    respond_to do |format|
      format.html { redirect_to catalog_personals_url, notice: 'Se eliminó el empleado con éxito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_personal
      @catalog_personal = CatalogPersonal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_personal_params
      params.require(:catalog_personal).permit(:clave, :nombre, :rfc,:celular,:direccion,:correo,:estatus,:user_id)
    end

    def invalid_foreign_key
      redirect_to catalog_personals_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
