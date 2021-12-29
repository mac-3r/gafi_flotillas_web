class InsuranceBeneficiariesController < ApplicationController
  before_action :set_insurance_beneficiary, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /insurance_beneficiaries
  # GET /insurance_beneficiaries.json
  def index
    #@insurance_beneficiaries = InsuranceBeneficiary.all
    @insurance_beneficiaries = InsuranceBeneficiary.order(descripcion: :asc) #muetsra solo los activos 
  end

  # GET /insurance_beneficiaries/1
  # GET /insurance_beneficiaries/1.json
  def show
  end

  # GET /insurance_beneficiaries/new
  def new
    @insurance_beneficiary = InsuranceBeneficiary.new
  end

  # GET /insurance_beneficiaries/1/edit
  def edit
  end

  # POST /insurance_beneficiaries
  # POST /insurance_beneficiaries.json
  def create
    begin
      @insurance_beneficiary = InsuranceBeneficiary.new(insurance_beneficiary_params)
      if !params[:insurance_beneficiary][:status].present?
        @insurance_beneficiary.status = false
        end
      respond_to do |format|
        if @insurance_beneficiary.save
          format.html { redirect_to insurance_beneficiaries_path, notice: 'El beneficiario se creó con éxito.' }
          format.json { render :show, status: :created, location: @insurance_beneficiary }
        else
          format.html { render :new }
          format.json { render json: @insurance_beneficiary.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to insurance_beneficiaries_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /insurance_beneficiaries/1
  # PATCH/PUT /insurance_beneficiaries/1.json
  def update
    begin
      if !params[:insurance_beneficiary][:status].present?
        params[:insurance_beneficiary][:status] = false
        else
        params[:insurance_beneficiary][:status] = true
        end
      respond_to do |format|
        if @insurance_beneficiary.update(insurance_beneficiary_params)
          format.html { redirect_to insurance_beneficiaries_path, notice: 'El beneficiario se actualizó con éxito.' }
          format.json { render :show, status: :ok, location: @insurance_beneficiary }
        else
          format.html { render :edit }
          format.json { render json: @insurance_beneficiary.errors, status: :unprocessable_entity }
        end
      end  
    rescue => exception
      redirect_to insurance_beneficiaries_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /insurance_beneficiaries/1
  # DELETE /insurance_beneficiaries/1.json
  def destroy
    @insurance_beneficiary.destroy
    respond_to do |format|
      format.html { redirect_to insurance_beneficiaries_url, notice: 'El beneficiario se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_insurance_beneficiary
      @insurance_beneficiary = InsuranceBeneficiary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def insurance_beneficiary_params
      params.require(:insurance_beneficiary).permit(:clave, :descripcion, :status)
    end
    def invalid_foreign_key
      redirect_to insurance_beneficiaries_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
