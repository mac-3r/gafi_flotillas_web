class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    #byebug
    begin
      if  params[:question][:estatus] == "on"
       params[:question][:estatus] = 0
      else
       params[:question][:estatus] = 1
      end 
       @question = Question.new(question_params)
       if !params[:question][:estatus].present?
         @question.estatus = 1
       end
       respond_to do |format|
         if @question.save
           format.html { redirect_to questions_path, notice: 'Question was successfully created.' }
           format.json { render :show, status: :created, location: @question }
         else
           format.html { render :new }
           format.json { render json: @question.errors, status: :unprocessable_entity }
         end
       end
    rescue => exception
      redirect_to questions_url
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    begin
      if  params[:question][:estatus] == "on"
        params[:question][:estatus] = 0
       else
        params[:question][:estatus] = 1
      end 
      respond_to do |format|
        if @question.update(question_params)
          format.html { redirect_to questions_path, notice: 'Se actualizó la pregunta con éxito.' }
          format.json { render :show, status: :ok, location: @question }
        else
          format.html { render :edit }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to questions_url
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Se eliminó la pregunta con éxito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:descripcion, :estatus)
    end
end
