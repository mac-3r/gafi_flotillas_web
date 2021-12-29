class PlateStatesController < ApplicationController
  before_action :set_plate_state, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /plate_states
  # GET /plate_states.json
  def index
    @plate_states = PlateState.order(descripcion: :asc)
  end

  # GET /plate_states/1
  # GET /plate_states/1.json
  def show
  end

  # GET /plate_states/new
  def new
    @plate_state = PlateState.new
  end

  # GET /plate_states/1/edit
  def edit
  end

  # POST /plate_states
  # POST /plate_states.json
  def create
    begin
      @plate_state = PlateState.new(plate_state_params)
      if !params[:plate_state][:status].present?
        @plate_state.status = false
        end
      respond_to do |format|
        if @plate_state.save
          format.html { redirect_to plate_states_path, notice: 'El estado de plaqueo se creó con exito.' }
          format.json { render :show, status: :created, location: @plate_state }
        else
          format.html { render :new }
          format.json { render json: @plate_state.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to plate_states_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /plate_states/1
  # PATCH/PUT /plate_states/1.json
  def update
    begin
      if !params[:plate_state][:status].present?
        params[:plate_state][:status] = false
        else
        params[:plate_state][:status] = true
        end
      respond_to do |format|
        if @plate_state.update(plate_state_params)
          format.html { redirect_to plate_states_path, notice: 'El estado de plaqueo se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @plate_state }
        else
          format.html { render :edit }
          format.json { render json: @plate_state.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to plate_states_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /plate_states/1
  # DELETE /plate_states/1.json
  def destroy
    @plate_state.destroy
    respond_to do |format|
      format.html { redirect_to plate_states_url, notice: 'El estado de plaqueo se eliminó exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_plate_state
      @plate_state = PlateState.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plate_state_params
      params.require(:plate_state).permit(:clave, :descripcion, :status)
    end
    def invalid_foreign_key
      redirect_to plate_states_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
