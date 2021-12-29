class CatalogConsiderationsController < ApplicationController
  before_action :set_catalog_consideration, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /catalog_considerations
  # GET /catalog_considerations.json
  def index
    @catalog_considerations = CatalogConsideration.all
  end

  # GET /catalog_considerations/1
  # GET /catalog_considerations/1.json
  def show
  end

  # GET /catalog_considerations/new
  def new
    @catalog_consideration = CatalogConsideration.new
  end

  # GET /catalog_considerations/1/edit
  def edit
  end

  # POST /catalog_considerations
  # POST /catalog_considerations.json
  def create
    begin
      @catalog_consideration = CatalogConsideration.new(catalog_consideration_params)
      respond_to do |format|
        if @catalog_consideration.save
          format.html { redirect_to catalog_considerations_path, notice: 'La consideración se creo con exito.' }
          format.json { render :show, status: :created, location: @catalog_consideration }
        else
          format.html { render :new }
          format.json { render json: @catalog_consideration.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_considerations_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_considerations/1
  # PATCH/PUT /catalog_considerations/1.json
  def update
    begin
      respond_to do |format|
        if @catalog_consideration.update(catalog_consideration_params)
          format.html { redirect_to catalog_considerations_path, notice: 'La consideración se actualizo con exito.' }
          format.json { render :show, status: :ok, location: @catalog_consideration }
        else
          format.html { render :edit }
          format.json { render json: @catalog_consideration.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_considerations_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_considerations/1
  # DELETE /catalog_considerations/1.json
  def destroy
    @catalog_consideration.destroy
    respond_to do |format|
      format.html { redirect_to catalog_considerations_url, notice: 'La consideración se elimino con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_consideration
      @catalog_consideration = CatalogConsideration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_consideration_params
      params.require(:catalog_consideration).permit(:clave, :catalog_brand_id, :descripcion)
    end
end
