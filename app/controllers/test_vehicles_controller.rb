class TestVehiclesController < ApplicationController
  before_action :set_test_vehicle, only: %i[ show edit update destroy ]
  load_and_authorize_resource
  # GET /test_vehicles or /test_vehicles.json
  def index
    @test_vehicles = TestVehicle.all
  end

  # GET /test_vehicles/1 or /test_vehicles/1.json
  def show
  end

  def vista_prueba
    
  end
  

  # GET /test_vehicles/new
  def new
    @test_vehicle = TestVehicle.new
  end

  # GET /test_vehicles/1/edit
  def edit
  end

  # POST /test_vehicles or /test_vehicles.json
  def create
    @test_vehicle = TestVehicle.new(test_vehicle_params)

    respond_to do |format|
      if @test_vehicle.save
        format.html { redirect_to @test_vehicle, notice: "Test vehicle was successfully created." }
        format.json { render :show, status: :created, location: @test_vehicle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @test_vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_vehicles/1 or /test_vehicles/1.json
  def update
    respond_to do |format|
      if @test_vehicle.update(test_vehicle_params)
        format.html { redirect_to @test_vehicle, notice: "Test vehicle was successfully updated." }
        format.json { render :show, status: :ok, location: @test_vehicle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @test_vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_vehicles/1 or /test_vehicles/1.json
  def destroy
    @test_vehicle.destroy
    respond_to do |format|
      format.html { redirect_to test_vehicles_url, notice: "Test vehicle was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_vehicle
      @test_vehicle = TestVehicle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def test_vehicle_params
      params.require(:test_vehicle).permit(:nombre, :numero)
    end
end
