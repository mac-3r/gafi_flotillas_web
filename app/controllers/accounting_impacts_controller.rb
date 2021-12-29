class AccountingImpactsController < ApplicationController
  before_action :set_accounting_impact, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /accounting_impacts
  # GET /accounting_impacts.json
  def index
    session["area"] = ""
    session["cedis"] = ""
    session["tipo"] = ""
    @accounting_impacts = AccountingImpact.consulta_afectaciones(session["area"],session["cedis"], session["tipo"])
  end
  
  def filtrado_afectaciones
    session["area"] = params[:catalog_area_id]
    session["cedis"] = params[:catalog_branch_id]
    session["tipo"] = params[:tipo]
    @accounting_impacts = AccountingImpact.consulta_afectaciones(session["area"],session["cedis"], session["tipo"])
    respond_to do |format|
      format.js
    end
  end
  
  # GET /accounting_impacts/1
  # GET /accounting_impacts/1.json
  def show
  end

  # GET /accounting_impacts/new
  def new
    @accounting_impact = AccountingImpact.new
  end

  # GET /accounting_impacts/1/edit
  def edit
  end

  # POST /accounting_impacts
  # POST /accounting_impacts.json
  def create
    begin
      @accounting_impact = AccountingImpact.new(accounting_impact_params)
      params[:accounting_impact][:catalog_branch_id] = params[:accounting_impact][:catalog_branch_id]
      if !params[:accounting_impact][:status].present?
        @accounting_impact.status = false
      end
      respond_to do |format|
        if @accounting_impact.save
          format.html { redirect_to accounting_impacts_path, notice: 'Se creó correctamente.' }
          format.json { render :show, status: :created, location: @accounting_impact }
        else
          format.html { render :new }
          format.json { render json: @accounting_impact.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to accounting_impacts_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /accounting_impacts/1
  # PATCH/PUT /accounting_impacts/1.json
  def update
    begin
      if !params[:accounting_impact][:status].present?
        params[:accounting_impact][:status] = false
      else
        params[:accounting_impact][:status] = true
      end
    respond_to do |format|
      if @accounting_impact.update(accounting_impact_params)
        format.html { redirect_to accounting_impacts_path, notice: 'Se actualizó correctamente' }
        format.json { render :show, status: :ok, location: @accounting_impact }
      else
        format.html { render :edit }
        format.json { render json: @accounting_impact.errors, status: :unprocessable_entity }
      end
    end
    rescue => exception
      redirect_to accounting_impacts_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /accounting_impacts/1
  # DELETE /accounting_impacts/1.json
  def destroy
    @accounting_impact.destroy
    respond_to do |format|
      format.html { redirect_to accounting_impacts_url, notice: 'Se eliminó correctamente' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_accounting_impact
      @accounting_impact = AccountingImpact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def accounting_impact_params
      params.require(:accounting_impact).permit(:catalog_branch_id, :nombre, :cuenta_contable, :status,:catalog_area_id)
    end
end
