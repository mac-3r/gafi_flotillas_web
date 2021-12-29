class ConceptServicesController < ApplicationController
  before_action :set_concept_service, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  before_action :validacion_menu
  # GET /concept_services
  # GET /concept_services.json
  def index
    @concept_services = ConceptService.all.order(descripcion: :asc)
  end

  # GET /concept_services/1
  # GET /concept_services/1.json
  def show
  end

  # GET /concept_services/new
  def new
    @concept_service = ConceptService.new
  end

  # GET /concept_services/1/edit
  def edit
  end

  # POST /concept_services
  # POST /concept_services.json
  def create
    begin
      if  params[:concept_service][:estatus] == "on"
        params[:concept_service][:estatus] = 0
      else
        params[:concept_service][:estatus] = 1
      end 
      @concept_service = ConceptService.new(concept_service_params)
      respond_to do |format|
        if @concept_service.save
          format.html { redirect_to concept_services_path, notice: 'Se creo el servicio con éxito.' }
          format.json { render :show, status: :created, location: @concept_service }
        else
          format.html { render :new }
          format.json { render json: @concept_service.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to concept_services_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /concept_services/1
  # PATCH/PUT /concept_services/1.json
  def update
    begin
      if  params[:concept_service][:estatus] == "on"
        params[:concept_service][:estatus] = 0
      else
        params[:concept_service][:estatus] = 1
      end 
      respond_to do |format|
        if @concept_service.update(concept_service_params)
          format.html { redirect_to concept_services_path, notice: 'Se actualizó el servicio con éxito.' }
          format.json { render :show, status: :ok, location: @concept_service }
        else
          format.html { render :edit }
          format.json { render json: @concept_service.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to concept_services_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /concept_services/1
  # DELETE /concept_services/1.json
  def destroy
    @concept_service.destroy
    respond_to do |format|
      format.html { redirect_to concept_services_url, notice: 'Se eliminó el servicio con éxito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_concept_service
      @concept_service = ConceptService.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def concept_service_params
      params.require(:concept_service).permit(:descripcion, :estatus)
    end

    def invalid_foreign_key
      redirect_to concept_services_path, alert: 'Este registro esta siendo usado.'
    end
end
