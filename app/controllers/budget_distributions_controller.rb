class BudgetDistributionsController < ApplicationController
  before_action :set_budget_distribution, only: [:show, :edit, :update, :destroy]

  # GET /budget_distributions
  # GET /budget_distributions.json
  def index
 
    cedis = "#{params[:catalog_branch_id]}"
    area = "#{params[:catalog_area_id]}"
    start_params = params[:start_date]

    if cedis.present?
      @budget_distributions = BudgetDistribution.where(catalog_branch_id:cedis)
    elsif area.present?
      @budget_distributions = BudgetDistribution.where(catalog_area_id:area)
    elsif start_params.present?
      @budget_distributions = BudgetDistribution.where('extract(year from fecha_entrega) = ?', start_params)
    elsif
      @budget_distributions = BudgetDistribution.order(:clave)
    end
  end

  # GET /budget_distributions/1
  # GET /budget_distributions/1.json
  def show
    @budget_distribution_details = @budget_distribution.budget_distribution_details
  end

  def nuevo_pres_reparto
    @budget_distribution = BudgetDistribution.new
  end

  def crear_presupuesto_reparto
    @budget = BudgetDistribution.crear_pres(params)
    if @budget[0] == 4
      redirect_to edit_budget_distribution_path(@budget[1])
      flash[:notice] = "Se registro correctamente "
    else
      redirect_to budget_concepts_path
      flash[:alert] = "Ocurrio un error"
    end
  end
  # GET /budget_distributions/new
  def new
    @budget_distribution = BudgetDistribution.new
  end

  def guardar_detalle_reparto
    @detalle = BudgetDistributionDetail.detalle(params,session["presupuesto"])
    if @detalle[1] == 4
      @encabezado = BudgetDistribution.find(@detalle[2])
      @budget_distribution_details = @encabezado.budget_distribution_details
    end
    respond_to do |format|
        format.js
    end
  end

  def formulario_agregar_detalle_reparto
    @budget_distribution_detail = BudgetDistributionDetail.new
    respond_to do |format|
    format.js
    end
  end

  # GET /budget_distributions/1/edit
  def edit
    @budget_distribution_details = @budget_distribution.budget_distribution_details
    session["presupuesto"] = @budget_distribution.id
    if @budget_distribution
      @budget_distribution_details = @budget_distribution.budget_distribution_details
    else
      flash[:alert]= "No existe el registro"
      redirect_to budget_distribution_path
      
    end
  end

  # POST /budget_distributions
  # POST /budget_distributions.json
  def create
    @budget_distribution = BudgetDistribution.new(budget_distribution_params)
      params[:budget_distribution][:catalog_branch_id] = params[:budget_distribution][:catalog_branch_id]
      params[:budget_distribution][:catalog_area_id] = params[:budget_distribution][:catalog_area_id]
    respond_to do |format|
      if @budget_distribution.save
        format.html { redirect_to budget_distributions_path, notice: 'El presupuesto se creo con exito.' }
        format.json { render :show, status: :created, location: @budget_distribution }
      else
        format.html { render :new }
        format.json { render json: @budget_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /budget_distributions/1
  # PATCH/PUT /budget_distributions/1.json
  def update
    @bandera_error = 0
    @errores = ""
    @budget_distribution = BudgetDistribution.find(params[:id])
    #byebug
    respond_to do |format|
      if @budget_distribution.budget_distribution_details.count > 0
        format.html { redirect_to budget_distributions_path, notice: 'Registro finalizado con éxito.' }
        format.json { render :show, status: :ok, location: @budget_distribution }
      else
        format.html { redirect_to edit_budget_distribution_path(@budget_distribution.id), alert:  'El registro debe tener al menos un datos.' }
      end
    end
  end

  def borrar_presupuesto_reparto
    @budget_d = BudgetDistribution.find_by(id: params[:id])
    @limpiar_detalle = BudgetDistributionDetail.where(budget_distribution_id: @budget_d.id).destroy_all
    @limpiar_encabezado = @budget_d.destroy
    if @limpiar_detalle and @limpiar_encabezado
      flash[:notice] = "Registro eliminado con éxito."
      redirect_to budget_distribution_path
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to budget_distribution_path
    end
  end

  def eliminar_partida_reparto
    @bandera = 0
    @mensaje = ""
    detalle = BudgetDistributionDetail.find_by(id: params[:id_partida])
    if detalle
      id_pedido = detalle.budget_distribution_id            
      if detalle.destroy
        @mensaje = "Datos eliminados correctamente."
        @budget_distribution_details = BudgetDistributionDetail.where(budget_distribution_id: id_pedido)
      else
        @bandera = 1
        detalle.errors.full_messages.each do |mensaje|
          @mensaje += mensaje    
        end
      end
    else
      @bandera = 2
      @mensaje += "No se encontró la partida."
    end        
    respond_to do |format|
      format.js
    end
  end

  # DELETE /budget_distributions/1
  # DELETE /budget_distributions/1.json
  def destroy
    @budget_d = BudgetDistribution.find_by(id: params[:id])
    @limpiar_detalle = BudgetDistributionDetail.where(budget_distribution_id: @budget_d.id).destroy_all
    @budget_distribution.destroy
    respond_to do |format|
      format.html { redirect_to budget_distributions_url, notice: 'Registro eliminado con éxito.' }
      format.json { head :no_content }
    end
  end

  def imprimir
    @budget_distributions = BudgetDistribution.all
		respond_to do |format|
			format.html
			format.pdf do
			render pdf: "imprimir",
			template: "budget_distributiont/show.html.erb",
			layout: 'reporte_pdf.html',
			orientation: 'Portrait'
			end
		end
  end

  def solicitar_presupuesto_reparto
    @budget_distributions = BudgetDistribution.find_by(id: params[:id])
    if @budget_distributions
      @budget_distributions.update(status: "Por autorizar")
        flash[:notice] = "Solicitud enviada con éxito"
        redirect_to budget_distributions_path
      else
        flash[:alert] = "No se encontró el registro."
        redirect_to budget_distributions_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_distribution
      @budget_distribution = BudgetDistribution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def budget_distribution_params
      params.require(:budget_distribution).permit(:clave,:catalog_branch_id, :fecha_entrega, :catalog_area_id, :fecha_compra)
    end
end
