class CatalogAreasController < ApplicationController
  before_action :set_catalog_area, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_areas
  # GET /catalog_areas.json
  def index
    @catalog_areas = CatalogArea.order(descripcion: :asc)
  end

  # GET /catalog_areas/1
  # GET /catalog_areas/1.json
  def show
  end

  # GET /catalog_areas/new
  def new
    @catalog_area = CatalogArea.new
  end

  # GET /catalog_areas/1/edit
  def edit
  end

  # POST /catalog_areas
  # POST /catalog_areas.json
  def create
    begin
      @catalog_area = CatalogArea.new(catalog_area_params)
      if !params[:catalog_area][:status].present?
        @catalog_area.status = false
        end
      respond_to do |format|
        if @catalog_area.save
          format.html { redirect_to catalog_areas_path, notice: 'Se creó correctamente'  }
          format.json { render :show, status: :created, location: @catalog_area }
        else
          format.html { render :new }
          format.json { render json: @catalog_area.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_areas_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_areas/1
  # PATCH/PUT /catalog_areas/1.json
  def update
    begin
      if !params[:catalog_area][:status].present?
        params[:catalog_area][:status] = false
        else
        params[:catalog_area][:status] = true
        end
      respond_to do |format|
        if @catalog_area.update(catalog_area_params)
          format.html { redirect_to catalog_areas_path, notice: 'Se actualizó correctamente' }
          format.json { render :show, status: :ok, location: @catalog_area }
        else
          format.html { render :edit }
          format.json { render json: @catalog_area.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_areas_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_areas/1
  # DELETE /catalog_areas/1.json
  def destroy
    @catalog_area.destroy
    respond_to do |format|
      format.html { redirect_to catalog_areas_url, notice: 'Se eliminó correctamente' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_area
      @catalog_area = CatalogArea.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_area_params
      params.require(:catalog_area).permit(:descripcion, :status,:tipo,:abreviacion, :clave)
    end
    def invalid_foreign_key
      redirect_to catalog_areas_url, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
