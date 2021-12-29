class CompetitionTablesController < ApplicationController
  before_action :set_competition_table, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /competition_tables
  # GET /competition_tables.json
  def index
    session["rol"] = ""
    session["cedis"] = ""
    session["tipo"] = ""
    @competition_tables = CompetitionTable.consulta_competencias(session["rol"],session["cedis"],session["tipo"])
  end
 
  def filtrado_competencias
    session["rol"] = params[:rol_id]
    session["cedis"] = params[:catalog_branch_id]
    session["tipo"] = params[:tipo]
    @competition_tables = CompetitionTable.consulta_competencias(session["rol"],session["cedis"],session["tipo"])
    respond_to do |format|
      format.js
    end
  end
  # GET /competition_tables/1
  # GET /competition_tables/1.json
  def show
  end

  # GET /competition_tables/new
  def new
    @competition_table = CompetitionTable.new
    @cedis = CatalogBranch.all
  end

  # GET /competition_tables/1/edit
  def edit
  end

  # POST /competition_tables
  # POST /competition_tables.json
  def create
    begin
    params[:competition_table][:catalog_branch_id] = params[:competition_table][:catalog_branch_id]
    params[:competition_table][:catalog_role_id] = params[:competition_table][:catalog_role_id]

    @competition_table = CompetitionTable.new(competition_table_params)

    respond_to do |format|
      if @competition_table.save
        format.html { redirect_to competition_tables_path, notice: 'Se creó correctamente' }
        format.json { render :show, status: :created, location: @competition_table }
      else
        format.html { render :new }
        format.json { render json: @competition_table.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
        format.html { redirect_to competition_tables_path, alert: 'Ya existe esta competencia' }
      end
    end
  end

  # PATCH/PUT /competition_tables/1
  # PATCH/PUT /competition_tables/1.json
  def update
    begin
    respond_to do |format|
      if @competition_table.update(competition_table_params)
        format.html { redirect_to competition_tables_path, notice: 'Se actualizó correctamente' }
        format.json { render :show, status: :ok, location: @competition_table }
      else
        format.html { render :edit }
        format.json { render json: @competition_table.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
        format.html { redirect_to competition_tables_path, alert: 'Ya existe esta competencia' }
      end
    end
  end

  # DELETE /competition_tables/1
  # DELETE /competition_tables/1.json
  def destroy
    @competition_table.destroy
    respond_to do |format|
      format.html { redirect_to competition_tables_url, notice: 'Se eliminó correctamente' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_competition_table
      @competition_table = CompetitionTable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def competition_table_params
      params.require(:competition_table).permit(:catalog_branch_id, :catalog_role_id,:monto,:tipo)
    end
end