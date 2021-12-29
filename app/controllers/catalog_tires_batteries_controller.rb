class CatalogTiresBatteriesController < ApplicationController
  before_action :set_catalog_tires_battery, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_tires_batteries
  # GET /catalog_tires_batteries.json
  def index
    session["tipo"] = ""
    session["linea"] = ""
    @catalog_tires_batteries = CatalogTiresBattery.consulta_llantas(session["tipo"],session["linea"])
  end
 
  def filtrado_llantas
    session["tipo"] = params[:tipo]
    session["linea"] = params[:catalog_brand_id]
    @catalog_tires_batteries = CatalogTiresBattery.consulta_llantas(session["tipo"],session["linea"])
    respond_to do |format|
      format.js
    end
  end
  
  # GET /catalog_tires_batteries/1
  # GET /catalog_tires_batteries/1.json
  def show
  end

  # GET /catalog_tires_batteries/new
  def new
    @catalog_tires_battery = CatalogTiresBattery.new
  end

  # GET /catalog_tires_batteries/1/edit
  def edit
  end

  # POST /catalog_tires_batteries
  # POST /catalog_tires_batteries.json
  def create
    begin
      @catalog_tires_battery = CatalogTiresBattery.new(catalog_tires_battery_params)
  
      respond_to do |format|
        if @catalog_tires_battery.save
          format.html { redirect_to catalog_tires_batteries_path, notice: 'Se registró con éxito.' }
          format.json { render :show, status: :created, location: @catalog_tires_battery }
        else
          format.html { render :new }
          format.json { render json: @catalog_tires_battery.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_tires_batteries_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_tires_batteries/1
  # PATCH/PUT /catalog_tires_batteries/1.json
  def update
    begin
      respond_to do |format|
        if @catalog_tires_battery.update(catalog_tires_battery_params)
          format.html { redirect_to catalog_tires_batteries_path, notice: 'Se actualizó con éxito.' }
          format.json { render :show, status: :ok, location: @catalog_tires_battery }
        else
          format.html { render :edit }
          format.json { render json: @catalog_tires_battery.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_tires_batteries_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_tires_batteries/1
  # DELETE /catalog_tires_batteries/1.json
  def destroy
    @catalog_tires_battery.destroy
    respond_to do |format|
      format.html { redirect_to catalog_tires_batteries_url, notice: 'Se eliminó con éxito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_tires_battery
      @catalog_tires_battery = CatalogTiresBattery.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_tires_battery_params
      params.require(:catalog_tires_battery).permit(:catalog_brand_id, :medida, :modelo, :precio, :tipo, :moneda, :dls)
    end

    def invalid_foreign_key
      redirect_to catalog_tires_batteries_path, alert: 'Este registro esta siendo usado.'
    end
end
