class AccumulatedFuelsController < ApplicationController
  before_action :set_accumulated_fuel, only: [:show, :edit, :update, :destroy]

  # GET /accumulated_fuels
  # GET /accumulated_fuels.json
  def index
    @accumulated_fuels = AccumulatedFuel.all
  end

  # GET /accumulated_fuels/1
  # GET /accumulated_fuels/1.json
  def show
  end

  # GET /accumulated_fuels/new
  def new
    @accumulated_fuel = AccumulatedFuel.new
  end

  # GET /accumulated_fuels/1/edit
  def edit
  end

  # POST /accumulated_fuels
  # POST /accumulated_fuels.json
  def create
    @accumulated_fuel = AccumulatedFuel.new(accumulated_fuel_params)

    respond_to do |format|
      if @accumulated_fuel.save
        format.html { redirect_to @accumulated_fuel, notice: 'Accumulated fuel was successfully created.' }
        format.json { render :show, status: :created, location: @accumulated_fuel }
      else
        format.html { render :new }
        format.json { render json: @accumulated_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accumulated_fuels/1
  # PATCH/PUT /accumulated_fuels/1.json
  def update
    respond_to do |format|
      if @accumulated_fuel.update(accumulated_fuel_params)
        format.html { redirect_to @accumulated_fuel, notice: 'Accumulated fuel was successfully updated.' }
        format.json { render :show, status: :ok, location: @accumulated_fuel }
      else
        format.html { render :edit }
        format.json { render json: @accumulated_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accumulated_fuels/1
  # DELETE /accumulated_fuels/1.json
  def destroy
    @accumulated_fuel.destroy
    respond_to do |format|
      format.html { redirect_to accumulated_fuels_url, notice: 'Accumulated fuel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accumulated_fuel
      @accumulated_fuel = AccumulatedFuel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def accumulated_fuel_params
      params.require(:accumulated_fuel).permit(:no_economico, :cedis, :tipo_vehicu, :linea, :area, :responsable, :fecha_carga, :fecha_inicio, :fecha_fin, :n_factura, :litros_consumidos, :importe_base, :importe_total, :km_inicial, :km_actual, :gasto, :km_recorrido, :presupuesto)
    end
end
