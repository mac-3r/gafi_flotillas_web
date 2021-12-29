class BudgetConceptsController < ApplicationController
  before_action :set_budget_concept, only: [:show, :edit, :update, :destroy]

  # GET /budget_concepts
  # GET /budget_concepts.json

  def index
    cedis = "#{params[:catalog_branch_id]}"
    area = "#{params[:catalog_area_id]}"
    start_params = params[:start_date]

    if cedis.present?
      @budget_concepts = BudgetConcept.where(catalog_branch_id:cedis)
    elsif area.present?
      @budget_concepts = BudgetConcept.where(catalog_area_id:area)
    elsif start_params.present?
      @budget_concepts= BudgetConcept.where('extract(year from fecha) = ?', start_params)
    elsif
      @budget_concepts = BudgetConcept.order(:clave)
    end
   
  end
  
  def imprimir_pres
    @budget_concept = BudgetConcept.all
		respond_to do |format|
			format.html
			format.pdf do
			render pdf: "imprimir",
			template: "budget_concept/show.html.erb",
			layout: 'reporte_pdf.html',
			orientation: 'Portrait'
			end
		end
  end
  # GET /budget_concepts/1
  # GET /budget_concepts/1.json
  def show
    @budget_details = @budget_concept.budget_details
  end

  # GET /budget_concepts/new
  def new
    @budget_concept = BudgetConcept.new
  end

  # GET /budget_concepts/1/edit
  def edit
    @budget_details = @budget_concept.budget_details
    session["presupuesto"] = @budget_concept.id
    if @budget_concept
      @budget_details = @budget_concept.budget_details
    else
      flash[:alert]= "No existe el registro"
      redirect_to budget_concepts_path
      
    end
  end

  def nuevo_presupuesto
     @budget_concept = BudgetConcept.new
  end

  def crear_presupuesto
    @budget = BudgetConcept.crear_pres(params)
    if @budget[0] == 4
      redirect_to edit_budget_concept_path(@budget[1])
      flash[:notice] = "Se registro correctamente "
    else
      redirect_to budget_concepts_path
      flash[:alert] = "Ocurrio un error"
    end
  end

  def guardar_detalle
    @detalle = BudgetDetail.detalle(params,session["presupuesto"])
    if @detalle[1] == 4
      @encabezado = BudgetConcept.find(@detalle[2])
      @budget_details = @encabezado.budget_details
    end
    respond_to do |format|
        format.js
    end
  end

  def formulario_agregar_detalle
    @budget_detail = BudgetDetail.new
    respond_to do |format|
    format.js
    end
  end
  # POST /budget_concepts
  # POST /budget_concepts.json
  def create
    @budget_concept = BudgetConcept.new(budget_concept_params)
    respond_to do |format|
      params[:budget_concept][:catalog_branch_id] = params[:budget_concept][:catalog_branch_id]
      params[:budget_concept][:catalog_area_id] = params[:budget_concept][:catalog_area_id]

      if @budget_concept.save
        format.html { redirect_to budget_concepts_path, notice: 'El presupuesto se creó con éxito.' }
        format.json { render :show, status: :created, location: @budget_concept }
      else
        format.html { render :new }
        format.json { render json: @budget_concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /budget_concepts/1
  # PATCH/PUT /budget_concepts/1.json
  def update
    @bandera_error = 0
    @errores = ""
    @budget_concept = BudgetConcept.find(params[:id])
    respond_to do |format|
      if @budget_concept.budget_details.count > 0
        format.html { redirect_to budget_concepts_path, notice: 'Registro finalizado con éxito.' }
        format.json { render :show, status: :ok, location: @budget_concept }
      else
        format.html { redirect_to edit_budget_concept_path(@budget_concept.id), alert:  'El registro debe tener al menos un datos.' }
      end
    end
  end

  def borrar_presupuesto_venta
    @budget = BudgetConcept.find_by(id: params[:id])
    @limpiar_detalle = BudgetDetail.where(budget_concept_id: @budget.id).destroy_all
    @limpiar_encabezado = @budget.destroy
    if @limpiar_detalle and @limpiar_encabezado
      flash[:notice] = "Registro eliminado con éxito."
      redirect_to budget_concepts_path
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to budget_concepts_path
    end
  end

  def eliminar_partida
    @bandera = 0
    @mensaje = ""
    detalle = BudgetDetail.find_by(id: params[:id_partida])
    if detalle
      id_pedido = detalle.budget_concept_id            
      if detalle.destroy
        @mensaje = "Datos eliminados correctamente."
        @budget_details = BudgetDetail.where(budget_concept_id: id_pedido)
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
  # DELETE /budget_concepts/1
  # DELETE /budget_concepts/1.json
  def destroy
    @budget_concept.destroy
    respond_to do |format|
      format.html { redirect_to budget_concepts_url, notice: 'El presupuesto se eliminó con exito.' }
      format.json { head :no_content }
    end
  end
  def solicitar_presupuesto_venta
    @budget_concept = BudgetConcept.find_by(id: params[:id])
    if @budget_concept
      @budget_concept.update(status: "Por autorizar")
        flash[:notice] = "Solicitud enviada con éxito"
        redirect_to budget_concepts_path
      else
        flash[:alert] = "No se encontró el registro."
        redirect_to budget_concept_path
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_concept
      @budget_concept = BudgetConcept.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def budget_concept_params
      params.require(:budget_concept).permit(:catalog_area_id,:fecha,:catalog_branch_id,:fecha_entrega,:clave)
    end
end
