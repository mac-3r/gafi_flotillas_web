class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all.order(descripcion: :asc)
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    begin
      if  params[:answer][:estatus] == "on"
        params[:answer][:estatus] = 0
      else
        params[:answer][:estatus] = 1
      end 
      @answer = Answer.new(answer_params)
      respond_to do |format|
        if @answer.save
          format.html { redirect_to answers_path, notice: 'La respuesta se creo con éxito.' }
          format.json { render :show, status: :created, location: @answer }
        else
          format.html { render :new }
          format.json { render json: @answer.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to answers_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    begin
      if  params[:answer][:estatus] == "on"
        params[:answer][:estatus] = 0
      else
        params[:answer][:estatus] = 1
      end 
      respond_to do |format|
        if @answer.update(answer_params)
          format.html { redirect_to answers_path, notice: 'La respuesta con actualizó con éxito.' }
          format.json { render :show, status: :ok, location: @answer }
        else
          format.html { render :edit }
          format.json { render json: @answer.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to answers_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to answers_url, notice: 'La respuesta se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def answer_params
      params.require(:answer).permit(:descripcion, :estatus)
    end
end
