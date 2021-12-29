class BilledCompaniesController < ApplicationController
  before_action :set_billed_company, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::NotNullViolation, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /billed_companies
  # GET /billed_companies.json
  def index
    @billed_companies = BilledCompany.order(nombre: :asc)
  end

  # GET /billed_companies/1
  # GET /billed_companies/1.json
  def show
  end

  # GET /billed_companies/new
  def new
    @billed_company = BilledCompany.new
  end

  # GET /billed_companies/1/edit
  def edit
  end

  # POST /billed_companies
  # POST /billed_companies.json
  def create
    begin
      @billed_company = BilledCompany.new(billed_company_params)
      if !params[:billed_company][:status].present?
        @billed_company.status = false
        end
      respond_to do |format|
        if @billed_company.save
          format.html { redirect_to billed_companies_path, notice: 'La empresa facturable se creó con exito.' }
          format.json { render :show, status: :created, location: @billed_company }
        else
          format.html { render :new }
          format.json { render json: @billed_company.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to billed_companies_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /billed_companies/1
  # PATCH/PUT /billed_companies/1.json
  def update
    begin
      if !params[:billed_company][:status].present?
        params[:billed_company][:status] = false
        else
        params[:billed_company][:status] = true
        end
      respond_to do |format|
        if @billed_company.update(billed_company_params)
          format.html { redirect_to billed_companies_path, notice: 'La empresa facturable se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @billed_company }
        else
          format.html { render :edit }
          format.json { render json: @billed_company.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to billed_companies_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /billed_companies/1
  # DELETE /billed_companies/1.json
  def destroy
    @billed_company.destroy
    respond_to do |format|
      format.html { redirect_to billed_companies_url, notice: 'La empresa facturable se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_billed_company
      @billed_company = BilledCompany.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def billed_company_params
      params.require(:billed_company).permit(:clave_jd, :nombre,:domicilio,:rfc,:telefono, :status)
    end
    def invalid_foreign_key
      redirect_to billed_companies_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
