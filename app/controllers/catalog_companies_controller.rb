class CatalogCompaniesController < ApplicationController
  before_action :set_catalog_company, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_companies
  # GET /catalog_companies.json
  def index
    @catalog_companies = CatalogCompany.order(nombre: :asc)
   # @catalog_companies = CatalogCompany.whereve(status: true)
  end

  # GET /catalog_companies/1
  # GET /catalog_companies/1.json
  def show
  end

  # GET /catalog_companies/new
  def new
    @catalog_company = CatalogCompany.new
  end

  # GET /catalog_companies/1/edit
  def edit
  end

  # POST /catalog_companies
  # POST /catalog_companies.json
  def create
    begin
      @catalog_company = CatalogCompany.new(catalog_company_params)
      if !params[:catalog_company][:status].present?
        @catalog_company.status = false
        end
      respond_to do |format|
        if @catalog_company.save
          format.html { redirect_to catalog_companies_path, notice: 'Se creó correctamente' }
          format.json { render :show, status: :created, location: @catalog_company }
        else
          format.html { render :new }
          format.json { render json: @catalog_company.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_companies_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_companies/1
  # PATCH/PUT /catalog_companies/1.json
  def update
    begin
      if !params[:catalog_company][:status].present?
        params[:catalog_company][:status] = false
        else
        params[:catalog_company][:status] = true
        end
      respond_to do |format|
        if @catalog_company.update(catalog_company_params)
          format.html { redirect_to catalog_companies_path, notice: 'Se actualizó correctamente' }
          format.json { render :show, status: :ok, location: @catalog_company }
        else
          format.html { render :edit }
          format.json { render json: @catalog_company.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_companies_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_companies/1
  # DELETE /catalog_companies/1.json
  def destroy
     @catalog_company.destroy
     respond_to do |format|
       format.html { redirect_to catalog_companies_url, notice: 'Se eliminó correctamente' }
       format.json { head :no_content }
     end
    # catalog_company = @catalog_company
    # if  catalog_company.update(status: 0)
    #   flash[:notice] = "Se eliminó correctamente"
    #    redirect_to   catalog_companies_path
    #  else
    #    flash[:alert] = "Se eliminó correctamente"
    #    redirect_to   catalog_companies_path
    #  end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_company
      @catalog_company = CatalogCompany.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_company_params
      params.require(:catalog_company).permit(:clave, :nombre, :status,:domicilio,:codigo_postal,:telefono,:rfc,:abreviatura)
    end
    #validacion de la llave foranea 
    def invalid_foreign_key
      redirect_to catalog_companies_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
