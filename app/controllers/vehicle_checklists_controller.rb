class VehicleChecklistsController < ApplicationController
  before_action :set_vehicle_checklist, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /vehicle_checklists
  # GET /vehicle_checklists.json
  def index
    tipo = "#{params[:vehicle_type_id]}"
    if tipo != ""
      @vehicle_checklists = VehicleChecklist.where(vehicle_type_id: tipo).order(:clasificacionvehiculo)
    else
      @vehicle_checklists = VehicleChecklist.order(:clasificacionvehiculo)
    end
  end


  def ver_evidencia_bimonthly
    @evidencias = []
    vehicle_evidences = BimonthlyImg.where(bimonthly_verification_id: params[:bimonthly_verification_id]) 
    vehicle_evidences.each do |ve|
        hash_evidencias = Hash.new
        hash_evidencias["id"] = ve.id
        if ve.imagen.attachment
            hash_evidencias["imagen"] = Rails.application.routes.url_helpers.rails_blob_url(ve.imagen, only_path: true)
        else
            hash_evidencias["imagen"] =nil
        end
        hash_evidencias["tipo"] = ve.tipo
        hash_evidencias["bimonthly_verification_id"] = ve.bimonthly_verification_id
        hash_evidencias["vehicles_id"] = ve.vehicles_id
        @evidencias << hash_evidencias
    end

end

  def ver_evidencia_imagenes
    @evidencias = []
    vehicle_evidences = VehicleEvidence.where(checklist_response_id: params[:checklist_response_id]) 
    vehicle_evidences.each do |ve|
        hash_evidencias = Hash.new
        hash_evidencias["id"] = ve.id
        if ve.imagen.attachment
            hash_evidencias["imagen"] = Rails.application.routes.url_helpers.rails_blob_url(ve.imagen, only_path: true)
        else
            hash_evidencias["imagen"] =nil
        end
        hash_evidencias["tipo"] = ve.tipo
        hash_evidencias["checklist_response_id"] = ve.checklist_response_id
        hash_evidencias["vehicles_id"] = ve.vehicles_id
        @evidencias << hash_evidencias
    end

end

  # GET /vehicle_checklists/1
  # GET /vehicle_checklists/1.json
  def show
  end

  # GET /vehicle_checklists/new
  def new
    @vehicle_checklist = VehicleChecklist.new
    @types= VehicleType.all
  end

  # GET /vehicle_checklists/1/edit
  def edit
  end

  # POST /vehicle_checklists
  # POST /vehicle_checklists.json
  def create
    begin
      @vehicle_checklist = VehicleChecklist.new(vehicle_checklist_params)
      params[:vehicle_checklist][:vehicle_type_id] = params[:vehicle_checklist][:vehicle_type_id]
  
      respond_to do |format|
        if @vehicle_checklist.save
          format.html { redirect_to vehicle_checklists_path, notice: 'La entrega de vehículo se creó con exito.' }
          format.json { render :show, status: :created, location: @vehicle_checklist }
        else
          format.html { render :new }
          format.json { render json: @vehicle_checklist.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to vehicle_checklists_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /vehicle_checklists/1
  # PATCH/PUT /vehicle_checklists/1.json
  def update
    begin
      respond_to do |format|
        if @vehicle_checklist.update(vehicle_checklist_params)
          format.html { redirect_to vehicle_checklists_path, notice: 'La entrega de vehículo se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @vehicle_checklist }
        else
          format.html { render :edit }
          format.json { render json: @vehicle_checklist.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to vehicle_checklists_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /vehicle_checklists/1
  # DELETE /vehicle_checklists/1.json
  def destroy
    @vehicle_checklist.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_checklists_url, notice: 'La entrega de vehículo se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_checklist
      @vehicle_checklist = VehicleChecklist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_checklist_params
      params.require(:vehicle_checklist).permit(:clasificacionvehiculo, :conceptovehiculo, :vehicle_type_id)
    end

    def invalid_foreign_key
      redirect_to vehicle_checklists_path, alert: 'Este registro esta siendo usado.'
    end
end
