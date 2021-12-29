class VehicleItemsController < ApplicationController
  before_action :set_vehicle_item, only: [:show, :edit, :update, :destroy]

  # GET /vehicle_items
  # GET /vehicle_items.json
  def index
    @vehicle_items = VehicleItem.all
  end

  # GET /vehicle_items/1
  # GET /vehicle_items/1.json
  def show
  end

  # GET /vehicle_items/new
  def new
    @vehicle_item = VehicleItem.new
  end

  # GET /vehicle_items/1/edit
  def edit
  end

  # POST /vehicle_items
  # POST /vehicle_items.json
  def create
    @vehicle_item = VehicleItem.new(vehicle_item_params)

    respond_to do |format|
      if @vehicle_item.save
        format.html { redirect_to @vehicle_item, notice: 'Vehicle item was successfully created.' }
        format.json { render :show, status: :created, location: @vehicle_item }
      else
        format.html { render :new }
        format.json { render json: @vehicle_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicle_items/1
  # PATCH/PUT /vehicle_items/1.json
  def update
    respond_to do |format|
      if @vehicle_item.update(vehicle_item_params)
        format.html { redirect_to @vehicle_item, notice: 'Vehicle item was successfully updated.' }
        format.json { render :show, status: :ok, location: @vehicle_item }
      else
        format.html { render :edit }
        format.json { render json: @vehicle_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_items/1
  # DELETE /vehicle_items/1.json
  def destroy
    @vehicle_item.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_items_url, notice: 'Vehicle item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_item
      @vehicle_item = VehicleItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_item_params
      params.require(:vehicle_item).permit(:codigo, :vehicle_id, :tipo, :fecha_compra, :estatus, :km_inicio, :km_fin)
    end
end
