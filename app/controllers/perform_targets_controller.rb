class PerformTargetsController < ApplicationController
  before_action :set_perform_target, only: [:show, :edit, :update, :destroy]

  # GET /perform_targets
  # GET /perform_targets.json
  def index
    @perform_targets = PerformTarget.order(:clave)
  end

  # GET /perform_targets/1
  # GET /perform_targets/1.json
  def show
  end

  # GET /perform_targets/new
  def new
    @perform_target = PerformTarget.new
  end

  # GET /perform_targets/1/edit
  def edit
  end

  # POST /perform_targets
  # POST /perform_targets.json
  def create
    @perform_target = PerformTarget.new(perform_target_params)
    if !params[:perform_target][:status].present?
      @perform_target.status = false
      end
    respond_to do |format|
      begin
      if @perform_target.save
        format.html { redirect_to perform_targets_path, notice: 'Se creó correctamente' }
        format.json { render :show, status: :created, location: @perform_target }
      else
        format.html { render :new }
        format.json { render json: @perform_target.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
        format.html { redirect_to perform_targets_path, alert: 'El rendimiento ideal ya existe para este CEDIS' }
      end
    end
  end

  # PATCH/PUT /perform_targets/1
  # PATCH/PUT /perform_targets/1.json
  def update
    if !params[:perform_target][:status].present?
      params[:perform_target][:status] = false
      else
      params[:perform_target][:status] = true
      end
    respond_to do |format|
      begin
      if @perform_target.update(perform_target_params)
        format.html { redirect_to perform_targets_path, notice: 'Se actualizó correctamente' }
        format.json { render :show, status: :ok, location: @perform_target }
      else
        format.html { render :edit }
        format.json { render json: @perform_target.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
        format.html { redirect_to perform_targets_path, alert: 'El rendimiento ideal ya existe para este CEDIS' }
      end
    end
  end

  # DELETE /perform_targets/1
  # DELETE /perform_targets/1.json
  def destroy
    @perform_target.destroy
    respond_to do |format|
      format.html { redirect_to perform_targets_url, notice: 'Se eliminó correctamente' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_perform_target
      @perform_target = PerformTarget.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def perform_target_params
      params.require(:perform_target).permit(:clave, :objperform, :catalog_branch_id, :vehicle_type_id, :idealperform, :status)
    end
end
