class ParametersController < ApplicationController
  before_action :set_parameter, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu

  # GET /parameters
  # GET /parameters.json
  def index
    @parameters = Parameter.all
    @signatures = UserSignature.all
    #byebug
  end

  def borrar_firma
    signature = UserSignature.find_by(id:params[:id])
    if signature.destroy
      flash[:notice] = "Se eliminó correctamente"
      redirect_to parameters_path
    else
      flash[:alert] = "Ocurrió un error"
      redirect_to parameters_path
    end
  end
  
  # GET /parameters/1
  # GET /parameters/1.json
  def show
  end

  # GET /parameters/new
  def new
    @parameter = Parameter.new
  end

  # GET /parameters/1/edit
  def edit
  end

  # POST /parameters
  # POST /parameters.json
  def create
    @parameter = Parameter.new(parameter_params)

    respond_to do |format|
      if @parameter.save
        format.html { redirect_to parameters_url, notice: 'Parámetro creado con éxito.' }
        format.json { render :show, status: :created, location: @parameter }
      else
        format.html { render :new }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  def validacion_menu
    session["menu1"] = "Seguridad"
    session["menu2"] = "Parámetros"
  end
  # PATCH/PUT /parameters/1
  # PATCH/PUT /parameters/1.json
  def update
    respond_to do |format|
      if @parameter.update(parameter_params)
        format.html { redirect_to parameters_url, notice: 'Parámetro actualizado con éxito.' }
        format.json { render :show, status: :ok, location: @parameter }
      else
        format.html { render :edit }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parameters/1
  # DELETE /parameters/1.json
  def destroy
    @parameter.destroy
    respond_to do |format|
      format.html { redirect_to parameters_url, notice: 'Parámetro eliminado con éxito.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parameter
      @parameter = Parameter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def parameter_params
      params.require(:parameter).permit(:nombre, :valor, :valor_extendido)
    end
end
