class TypeSinistersController < ApplicationController
  before_action :set_type_sinister, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /type_sinisters
  # GET /type_sinisters.json
  def index
    tipo = "#{params[:tipo_siniestro]}"

    if tipo != ""
      @type_sinisters = TypeSinister.where(nombreSiniestro:tipo)
    else
      @type_sinisters = TypeSinister.all.order(nombreSiniestro: :asc)
    end
  end

  # GET /type_sinisters/1
  # GET /type_sinisters/1.json
  def show
  end

  # GET /type_sinisters/new
  def new
    @type_sinister = TypeSinister.new
  end

  # GET /type_sinisters/1/edit
  def edit
  end

  # POST /type_sinisters
  # POST /type_sinisters.json
  def create
    begin
      @type_sinister = TypeSinister.new(type_sinister_params)
      if !params[:type_sinister][:status].present?
        @type_sinister.status = false
        end
      respond_to do |format|
        if @type_sinister.save
          format.html { redirect_to type_sinisters_path, notice: 'El tipo siniestro se creó con exito.' }
          format.json { render :show, status: :created, location: @type_sinister }
        else
          format.html { render :new }
          format.json { render json: @type_sinister.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to type_sinisters_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /type_sinisters/1
  # PATCH/PUT /type_sinisters/1.json
  def update
    begin
      if !params[:type_sinister][:status].present?
        params[:type_sinister][:status] = false
        else
        params[:type_sinister][:status] = true
        end
      respond_to do |format|
        if @type_sinister.update(type_sinister_params)
          format.html { redirect_to type_sinisters_path, notice: 'El tipo siniestro se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @type_sinister }
        else
          format.html { render :edit }
          format.json { render json: @type_sinister.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to type_sinisters_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /type_sinisters/1
  # DELETE /type_sinisters/1.json
  def destroy
    @type_sinister.destroy
    respond_to do |format|
      format.html { redirect_to type_sinisters_url, notice: 'El tipo siniestro se actualizó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_type_sinister
      @type_sinister = TypeSinister.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def type_sinister_params
      params.require(:type_sinister).permit(:nombreSiniestro, :status)
    end

    def invalid_foreign_key
      redirect_to type_sinisters_path, alert: 'Este registro esta siendo usado.'
    end

end
