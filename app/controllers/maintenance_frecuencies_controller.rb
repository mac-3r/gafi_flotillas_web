class MaintenanceFrecuenciesController < ApplicationController
  before_action :set_maintenance_frecuency, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /maintenance_frecuencies
  # GET /maintenance_frecuencies.json
  def index
    session["tipo"] = ""
    session["modelo"] = ""
    @maintenance_frecuencies = MaintenanceFrecuency.consulta_frecuencias(session["tipo"], session["modelo"])
  end
  
  def filtrado_frecuencias
    session["tipo"] = params[:vehicle_type_id]
    session["modelo"] = params[:catalog_model_id]
    @maintenance_frecuencies = MaintenanceFrecuency.consulta_frecuencias(session["tipo"], session["modelo"])
    respond_to do |format|
      format.js
    end
  end
  
  # GET /maintenance_frecuencies/1
  # GET /maintenance_frecuencies/1.json
  def show
  end

  # GET /maintenance_frecuencies/new
  def new
    @maintenance_frecuency = MaintenanceFrecuency.new
  end

  # GET /maintenance_frecuencies/1/edit
  def edit
  end

  # POST /maintenance_frecuencies
  # POST /maintenance_frecuencies.json
  def create
    begin
      busqueda = MaintenanceFrecuency.find_by(vehicle_type_id: params[:maintenance_frecuency][:vehicle_type_id],catalog_model_id:params[:maintenance_frecuency][:catalog_model_id])
      if !busqueda
        @maintenance_frecuency = MaintenanceFrecuency.new(maintenance_frecuency_params)
        respond_to do |format|
          if @maintenance_frecuency.save
            format.html { redirect_to maintenance_frecuencies_path, notice: 'La frecuencia de mantenimiento se creo con éxito.' }
            format.json { render :show, status: :created, location: @maintenance_frecuency }
          else
            format.html { render :new }
            format.json { render json: @maintenance_frecuency.errors, status: :unprocessable_entity }
          end
        end
      else
        redirect_to maintenance_frecuencies_path
        flash[:alert] = "Ya existe este registro"
      end
    rescue => exception
      redirect_to maintenance_frecuencies_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /maintenance_frecuencies/1
  # PATCH/PUT /maintenance_frecuencies/1.json
  def update
    begin
        respond_to do |format|
          if @maintenance_frecuency.update(maintenance_frecuency_params)
            format.html { redirect_to maintenance_frecuencies_path, notice: 'La frecuencia de mantenimiento se actualizo con éxito.' }
            format.json { render :show, status: :ok, location: @maintenance_frecuency }
          else
            format.html { render :edit }
            format.json { render json: @maintenance_frecuency.errors, status: :unprocessable_entity }
          end
        end
    rescue => exception
      redirect_to maintenance_frecuencies_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /maintenance_frecuencies/1
  # DELETE /maintenance_frecuencies/1.json
  def destroy
    @maintenance_frecuency.destroy
    respond_to do |format|
      format.html { redirect_to maintenance_frecuencies_url, notice: 'La frencuencia de mantenimiento se elimino con éxito.' }
      format.json { head :no_content }
    end
  end

  def importar_frecuencias
    if params[:commit]
      frec = MaintenanceFrecuency.importar_frecuencias(params[:file])
      puts frec
      redirect_to importar_frecuencias_path
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_frecuency
      @maintenance_frecuency = MaintenanceFrecuency.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def maintenance_frecuency_params
      params.require(:maintenance_frecuency).permit(:mensual_recorrido, :frecuencia, :vehicle_type_id,:catalog_model_id,:tipo,:dias)
    end
end
