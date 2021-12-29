class ExpenseVehicleTypesController < ApplicationController
  before_action :set_expense_vehicle_type, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /expense_vehicle_types
  # GET /expense_vehicle_types.json
  def index
    @expense_vehicle_types = ExpenseVehicleType.all
  end

  # GET /expense_vehicle_types/1
  # GET /expense_vehicle_types/1.json
  def show
  end

  # GET /expense_vehicle_types/new
  def new
    @expense_vehicle_type = ExpenseVehicleType.new
  end

  # GET /expense_vehicle_types/1/edit
  def edit
  end

  # POST /expense_vehicle_types
  # POST /expense_vehicle_types.json
  def create
    begin
      @expense_vehicle_type = ExpenseVehicleType.new(expense_vehicle_type_params)
  
      respond_to do |format|
        if @expense_vehicle_type.save
          format.html { redirect_to expense_vehicle_types_url, notice: 'El gasto ideal se agrego con éxito.' }
          format.json { render :show, status: :created, location: @expense_vehicle_type }
        else
          format.html { render :new }
          format.json { render json: @expense_vehicle_type.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to expense_vehicle_types_url
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /expense_vehicle_types/1
  # PATCH/PUT /expense_vehicle_types/1.json
  def update
    begin
      respond_to do |format|
        if @expense_vehicle_type.update(expense_vehicle_type_params)
          format.html { redirect_to expense_vehicle_types_url, notice: 'Expense vehicle type was successfully updated.' }
          format.json { render :show, status: :ok, location: @expense_vehicle_type }
        else
          format.html { render :edit }
          format.json { render json: @expense_vehicle_type.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to expense_vehicle_types_url
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /expense_vehicle_types/1
  # DELETE /expense_vehicle_types/1.json
  def destroy
    @expense_vehicle_type.destroy
    respond_to do |format|
      format.html { redirect_to expense_vehicle_types_url, notice: 'Expense vehicle type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_expense_vehicle_type
      @expense_vehicle_type = ExpenseVehicleType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_vehicle_type_params
      params.require(:expense_vehicle_type).permit(:catalog_branch_id, :catalog_brand_id, :gasto, :clave)
    end
end
