class TuningPricesController < ApplicationController
  before_action :set_tuning_price, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /tuning_prices
  # GET /tuning_prices.json
  def index
    session["linea"] = ""
    session["cedis"] = ""
    session["taller_precios"] = ""
    @tuning_prices = TuningPrice.consulta_precios(session["linea"],session["cedis"], session["taller_precios"])
  end
 
  def filtrado_precios
    session["linea"] = params[:catalog_brand_id]
    session["cedis"] = params[:catalog_branch_id]
    session["taller_precios"] = params[:catalog_workshop_id]
    @tuning_prices = TuningPrice.consulta_precios(session["linea"],session["cedis"], session["taller_precios"])
  
    respond_to do |format|
      format.js
    end
  end

  # GET /tuning_prices/1
  # GET /tuning_prices/1.json
  def show
  end

  # GET /tuning_prices/new
  def new
    @tuning_price = TuningPrice.new
  end

  # GET /tuning_prices/1/edit
  def edit
  end

  # POST /tuning_prices
  # POST /tuning_prices.json
  def create
    begin
      if !params[:tuning_price][:status].present?
        params[:tuning_price][:status] = false
      else
        params[:tuning_price][:status] = true
      end
      @tuning_price = TuningPrice.new(tuning_price_params)
      respond_to do |format|
        if @tuning_price.save
          format.html { redirect_to tuning_prices_path, notice: 'El precio de afilación se agregó con exito.' }
          format.json { render :show, status: :created, location: @tuning_price }
        else
          format.html { render :new }
          format.json { render json: @tuning_price.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to tuning_prices_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /tuning_prices/1
  # PATCH/PUT /tuning_prices/1.json
  def update
    begin
      if !params[:tuning_price][:status].present?
        params[:tuning_price][:status] = false
        else
        params[:tuning_price][:status] = true
      end
      respond_to do |format|
        params[:tuning_price][:catalog_branch_id] = params[:tuning_price][:catalog_branch_id]
        params[:tuning_price][:catalog_brand_id] = params[:tuning_price][:catalog_brand_id]
        params[:tuning_price][:catalog_workshop_id] = params[:tuning_price][:catalog_workshop_id]
  
        if @tuning_price.update(tuning_price_params)
          format.html { redirect_to tuning_prices_path, notice: 'El precio de afilación se actualizo con exito.' }
          format.json { render :show, status: :ok, location: @tuning_price }
        else
          format.html { render :edit }
          format.json { render json: @tuning_price.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to tuning_prices_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  def tuning_log
    @tuning_log = TuningPricesLog.all.order(created_at: :desc)
  end
  
  # DELETE /tuning_prices/1
  # DELETE /tuning_prices/1.json
  def destroy
    if historico = TuningPricesLog.where(tuning_price_id:@tuning_price.id).destroy_all
      @tuning_price.destroy
      respond_to do |format|
        format.html { redirect_to tuning_prices_url, notice: 'El precio de afilación se eliminó.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to tuning_prices_url, notice: 'Ocurrió un error.' }
        format.json { head :no_content }
      end
    end
  end

  def importar_precios
    @tuning_price = TuningPrice.importar_precios(params[:file])
		respond_to do |format|
			if @tuning_price.count == 0
				format.html { redirect_to tuning_prices_path, notice: "Plantilla cargada con éxito." }
			else
				format.html { render :import_prices_errors }
				format.json { render json: @concepts }
			end
		end
  end
  
  def descargar_plantilla_precios
		send_file "#{Rails.root}/public/packs/Importaciones/layout_precios_afinaciones.xlsx"
	end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_tuning_price
      @tuning_price = TuningPrice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tuning_price_params
      params.require(:tuning_price).permit(:catalog_branch_id, :catalog_brand_id, :catalog_workshop_id, :precio_menor, :precio_mayor, :status, :clave,:anio,:precio_mayor_sin)
    end
end
