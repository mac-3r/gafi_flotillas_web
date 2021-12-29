class CatalogBrandsController < ApplicationController
  before_action :set_catalog_brand, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_brands
  # GET /catalog_brands.json
  def index
    linea = "#{params[:linea]}"
    if linea !=""
      @catalog_brands = CatalogBrand.where("descripcion LIKE '%#{linea}%'").order(descripcion: :asc)
    else
      @catalog_brands = CatalogBrand.all.order(descripcion: :asc)
    end
  end

  # GET /catalog_brands/1
  # GET /catalog_brands/1.json
  def show
  end

  # GET /catalog_brands/new
  def new
    @catalog_brand = CatalogBrand.new
  end

  # GET /catalog_brands/1/edit
  def edit
  end

  # POST /catalog_brands
  # POST /catalog_brands.json
  def create
    begin
      @catalog_brand = CatalogBrand.new(catalog_brand_params)
      if !params[:catalog_brand][:status].present?
        @catalog_brand.status = false
        end
      respond_to do |format|
        if @catalog_brand.save
          format.html { redirect_to catalog_brands_path, notice: 'Se registro correctamente' }
          format.json { render :show, status: :created, location: @catalog_brand }
        else
          format.html { render :new }
          format.json { render json: @catalog_brand.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_brands_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_brands/1
  # PATCH/PUT /catalog_brands/1.json
  def update
    begin
      if !params[:catalog_brand][:status].present?
        params[:catalog_brand][:status] = false
        else
        params[:catalog_brand][:status] = true
        end
      respond_to do |format|
        if @catalog_brand.update(catalog_brand_params)
          format.html { redirect_to catalog_brands_path, notice: 'Se actualizo correctamente' }
          format.json { render :show, status: :ok, location: @catalog_brand }
        else
          format.html { render :edit }
          format.json { render json: @catalog_brand.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_brands_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_brands/1
  # DELETE /catalog_brands/1.json
  def destroy
    # catalog_brand = @catalog_brand
    # if  catalog_brand.update(status: 0)
    #   flash[:notice] = "Se eliminó correctamente"
    #    redirect_to  catalog_brands_path
    #  else
    #    flash[:alert] = "Se eliminó correctamente"
    #    redirect_to  catalog_brands_path
    #  end
     @catalog_brand.destroy
     respond_to do |format|
       format.html { redirect_to catalog_brands_url, notice: 'Se eliminó correctamente' }
       format.json { head :no_content }
     end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
      # Use callbacks to share common setup or constraints between actions.
    def set_catalog_brand
      @catalog_brand = CatalogBrand.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_brand_params
      params.require(:catalog_brand).permit(:clave, :descripcion, :status)
    end
    def invalid_foreign_key
      redirect_to catalog_brands_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
