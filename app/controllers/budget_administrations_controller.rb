class BudgetAdministrationsController < ApplicationController
  before_action :set_budget_administration, only: [:show, :edit, :update, :destroy]

  # GET /budget_administrations
  # GET /budget_administrations.json
  def index
    cedis = "#{params[:catalog_branch_id]}"
    area = "#{params[:catalog_area_id]}"
    start_params = params[:start_date]
    
    if cedis.present?
      @budget_administrations = BudgetAdministration.where(catalog_branch_id:cedis)
    elsif area.present?
      @budget_administrations = BudgetAdministration.where(catalog_area_id:area)
    elsif start_params.present?
      @budget_administrations= BudgetAdministration.where('extract(year from fecha_compra) = ?', start_params)
    elsif
      @budget_administrations = BudgetAdministration.order(:clave)
    end
  end

  # GET /budget_administrations/1
  # GET /budget_administrations/1.json
  def show
    @budget_administration_details = @budget_administration.budget_administration_details
  end

  # GET /budget_administrations/new
  def new
    @budget_administration = BudgetAdministration.new
  end

  def nuevo_presupuesto_admin
    @budget_administration = BudgetAdministration.new
  end

  def crear_presupuesto_admin
    @budget = BudgetAdministration.crear_pres(params)
    if @budget[0] == 4
      redirect_to edit_budget_administration_path(@budget[1]) 
      flash[:notice] = "Se registro correctamente "
    else
      redirect_to budget_administrations_path
      flash[:alert] = "Ocurrio un error"
    end
  end

  def formulario_agregar_detalle_admin
    @budget_administration_detail = BudgetAdministrationDetail.new
    respond_to do |format|
    format.js
    end
  end

  def guardar_detalle_admin
    @detalle = BudgetAdministrationDetail.detalle(params,session["presupuesto"])
    if @detalle[1] == 4
      @encabezado = BudgetAdministration.find(@detalle[2])
      @budget_administration_details = @encabezado.budget_administration_details
    end
    respond_to do |format|
        format.js
    end
  end
  # GET /budget_administrations/1/edit
  def edit
    @budget_administration_details = @budget_administration.budget_administration_details
    session["presupuesto"] = @budget_administration.id
    if @budget_administration
      @budget_administration_details = @budget_administration.budget_administration_details
    else
      flash[:alert]= "No existe el registro"
      redirect_to budget_administrations_path  
    end
  end

  def borrar_presupuesto_admin
    @budget = BudgetAdministration.find_by(id: params[:id])
    @limpiar_detalle = BudgetAdministrationDetail.where(budget_administration_id: @budget.id).destroy_all
    @limpiar_encabezado = @budget.destroy
    if @limpiar_detalle and @limpiar_encabezado
      flash[:notice] = "Registro eliminado con éxito."
      redirect_to budget_administrations_path
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to budget_administrations_path
    end
  end

  def eliminar_partida_admin
    @bandera = 0
    @mensaje = ""
    detalle = BudgetAdministrationDetail.find_by(id: params[:id_partida])
    if detalle
      id_pedido = detalle.budget_administration_id            
      if detalle.destroy
        @mensaje = "Datos eliminados correctamente."
        @budget_administration_details = BudgetAdministrationDetail.where(budget_administration_id: id_pedido)
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
  # POST /budget_administrations
  # POST /budget_administrations.json
  def create
    @budget_administration = BudgetAdministration.new(budget_administration_params)

    respond_to do |format|
      if @budget_administration.save
        format.html { redirect_to @budget_administration, notice: 'Budget administration was successfully created.' }
        format.json { render :show, status: :created, location: @budget_administration }
      else
        format.html { render :new }
        format.json { render json: @budget_administration.errors, status: :unprocessable_entity }
      end
    end
  end

  def imprimir_ad
    @budget_administrations = BudgetAdministration.all
		respond_to do |format|
			format.html
			format.pdf do
			render pdf: "imprimir",
			template: "budget_administration/show.html.erb",
			layout: 'reporte_pdf.html',
			orientation: 'Portrait'
			end
		end
  end
  # PATCH/PUT /budget_administrations/1
  # PATCH/PUT /budget_administrations/1.json
  def update
    @bandera_error = 0
    @errores = ""
    @budget_administration = BudgetAdministration.find(params[:id])
    respond_to do |format|
      if @budget_administration.budget_administration_details.count > 0
        format.html { redirect_to budget_administrations_path, notice: 'Registro finalizado con éxito.' }
        format.json { render :show, status: :ok, location: @budget_administration }
      else
        format.html { redirect_to edit_budget_administration_path(@budget_administration.id), alert: 'El registro debe tener al menos un datos.' }
      end
    end
  end

  # DELETE /budget_administrations/1
  # DELETE /budget_administrations/1.json
  def destroy
    @budget_administration.destroy
    respond_to do |format|
      format.html { redirect_to budget_administrations_url, notice: 'Budget administration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def solicitar_presupuesto_admin
    @budget_administration = BudgetAdministration.find_by(id: params[:id])
    if @budget_administration
      @budget_administration.update(status: "Por autorizar")
        flash[:notice] = "Solicitud enviada con éxito"
        redirect_to budget_administrations_path
      else
        flash[:alert] = "No se encontró el registro."
        redirect_to budget_administrations_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_administration
      @budget_administration = BudgetAdministration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def budget_administration_params
      params.require(:budget_administration).permit(:clave, :catalog_branch_id, :fecha_entrega, :catalog_area_id, :fecha_compra)
    end
end
