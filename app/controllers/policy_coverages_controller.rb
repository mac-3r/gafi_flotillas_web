class PolicyCoveragesController < ApplicationController
  before_action :set_policy_coverage, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /policy_coverages
  # GET /policy_coverages.json
  def index
    @policy_coverages = PolicyCoverage.order(descripcion: :asc)
  end

  # GET /policy_coverages/1
  # GET /policy_coverages/1.json
  def show
  end

  # GET /policy_coverages/new
  def new
    @policy_coverage = PolicyCoverage.new
  end

  # GET /policy_coverages/1/edit
  def edit
  end

  # POST /policy_coverages
  # POST /policy_coverages.json
  def create
    begin
      @policy_coverage = PolicyCoverage.new(policy_coverage_params)
      if !params[:policy_coverage][:status].present?
        @policy_coverage.status = false
        end
      respond_to do |format|
        if @policy_coverage.save
          format.html { redirect_to policy_coverages_path, notice: 'La cobertura de póliza se creó con exito.' }
          format.json { render :show, status: :created, location: @policy_coverage }
        else
          format.html { render :new }
          format.json { render json: @policy_coverage.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to policy_coverages_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /policy_coverages/1
  # PATCH/PUT /policy_coverages/1.json
  def update
    begin
      if !params[:policy_coverage][:status].present?
        params[:policy_coverage][:status] = false
        else
        params[:policy_coverage][:status] = true
        end
      respond_to do |format|
        if @policy_coverage.update(policy_coverage_params)
          format.html { redirect_to policy_coverages_path, notice: 'La cobertura de póliza se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @policy_coverage }
        else
          format.html { render :edit }
          format.json { render json: @policy_coverage.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to policy_coverages_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /policy_coverages/1
  # DELETE /policy_coverages/1.json
  def destroy
    @policy_coverage.destroy
    respond_to do |format|
      format.html { redirect_to policy_coverages_url, notice: 'La cobertura de póliza se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_policy_coverage
      @policy_coverage = PolicyCoverage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def policy_coverage_params
      params.require(:policy_coverage).permit(:clave, :descripcion, :status)
    end
    def invalid_foreign_key
      redirect_to policy_coverages_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
