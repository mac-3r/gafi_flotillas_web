class CatalogRoutesController < ApplicationController
  before_action :set_catalog_route, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_routes
  # GET /catalog_routes.json
  def index
    @catalog_routes = CatalogRoute.all.order(descripcion: :asc)
  end

  # GET /catalog_routes/1
  # GET /catalog_routes/1.json
  def show
  end

  # GET /catalog_routes/new
  def new
    @catalog_route = CatalogRoute.new
  end

  # GET /catalog_routes/1/edit
  def edit
  end

  # POST /catalog_routes
  # POST /catalog_routes.json
  def create
    begin
      @catalog_route = CatalogRoute.new(catalog_route_params)
      if !params[:catalog_route][:status].present?
        @catalog_route.status = false
        end
      respond_to do |format|
        if @catalog_route.save
          format.html { redirect_to catalog_routes_path, notice: 'La ruta se creó con exito.' }
          format.json { render :show, status: :created, location: @catalog_route }
        else
          format.html { render :new }
          format.json { render json: @catalog_route.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_routes_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_routes/1
  # PATCH/PUT /catalog_routes/1.json
  def update
    begin
      if !params[:catalog_route][:status].present?
        params[:catalog_route][:status] = false
        else
        params[:catalog_route][:status] = true
        end
      respond_to do |format|
        if @catalog_route.update(catalog_route_params)
          format.html { redirect_to catalog_routes_path, notice: 'La ruta se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @catalog_route }
        else
          format.html { render :edit }
          format.json { render json: @catalog_route.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_routes_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_routes/1
  # DELETE /catalog_routes/1.json
  def destroy
    @catalog_route.destroy
    respond_to do |format|
      format.html { redirect_to catalog_routes_url, notice: 'La ruta se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_route
      @catalog_route = CatalogRoute.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_route_params
      params.require(:catalog_route).permit(:clave, :descripcion, :status)
    end
    def invalid_foreign_key
      redirect_to catalog_routes_path, notice: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
