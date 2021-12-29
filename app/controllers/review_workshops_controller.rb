class ReviewWorkshopsController < ApplicationController
  before_action :set_review_workshop, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /review_workshops
  # GET /review_workshops.json
  def index
    revision = "#{params[:revision]}"
    if revision != ""
      @review_workshops = ReviewWorkshop.where("descripcion LIKE '%#{revision}%'").order(descripcion: :asc)
    else
      @review_workshops = ReviewWorkshop.all.order(descripcion: :asc)
    end
    
  end

  # GET /review_workshops/1
  # GET /review_workshops/1.json
  def show
  end

  # GET /review_workshops/new
  def new
    @review_workshop = ReviewWorkshop.new
  end

  # GET /review_workshops/1/edit
  def edit
  end

  # POST /review_workshops
  # POST /review_workshops.json
  def create
    begin
      @review_workshop = ReviewWorkshop.new(review_workshop_params)
      if !params[:review_workshop][:status].present?
        @review_workshop.status = false
      end
      respond_to do |format|
        if @review_workshop.save
          format.html { redirect_to review_workshops_path, notice: 'La revisión se creo con exito.' }
          format.json { render :show, status: :created, location: @review_workshop }
        else
          format.html { render :new }
          format.json { render json: @review_workshop.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to review_workshops_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /review_workshops/1
  # PATCH/PUT /review_workshops/1.json
  def update
    begin
      if !params[:review_workshop][:status].present?
        params[:review_workshop][:status] = false
      else
        params[:review_workshop][:status] = true
      end
      respond_to do |format|
        if @review_workshop.update(review_workshop_params)
          format.html { redirect_to review_workshops_path, notice: 'La revisión se actualizo con exito.' }
          format.json { render :show, status: :ok, location: @review_workshop }
        else
          format.html { render :edit }
          format.json { render json: @review_workshop.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to review_workshops_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /review_workshops/1
  # DELETE /review_workshops/1.json
  def destroy
    @review_workshop.destroy
    respond_to do |format|
      format.html { redirect_to review_workshops_url, notice: 'La revisión se elimino con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_review_workshop
      @review_workshop = ReviewWorkshop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_workshop_params
      params.require(:review_workshop).permit(:clave, :descripcion, :status)
    end

    def invalid_foreign_key
      redirect_to review_workshops_path, alert: 'No se puede eliminar ya que esta relacionado con otro registro.'
    end
end
