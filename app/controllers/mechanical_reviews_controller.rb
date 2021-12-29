class MechanicalReviewsController < ApplicationController
  before_action :set_mechanical_review, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /mechanical_reviews
  # GET /mechanical_reviews.json
  def index
    @mechanical_reviews = MechanicalReview.all
  end

  # GET /mechanical_reviews/1
  # GET /mechanical_reviews/1.json
  def show
  end

  # GET /mechanical_reviews/new
  def new
    @mechanical_review = MechanicalReview.new
  end

  # GET /mechanical_reviews/1/edit
  def edit
  end

  # POST /mechanical_reviews
  # POST /mechanical_reviews.json
  def create
    begin
      @mechanical_review = MechanicalReview.new(mechanical_review_params)
      if !params[:mechanical_review][:status].present?
        @mechanical_review.status = false
      end
      respond_to do |format|
        if @mechanical_review.save
          format.html { redirect_to mechanical_reviews_path, notice: 'La revisón mecanica se creo con exito.' }
          format.json { render :show, status: :created, location: @mechanical_review }
        else
          format.html { render :new }
          format.json { render json: @mechanical_review.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to mechanical_reviews_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /mechanical_reviews/1
  # PATCH/PUT /mechanical_reviews/1.json
  def update
    begin
      if !params[:mechanical_review][:status].present?
        params[:mechanical_review][:status] = false
      else
        params[:mechanical_review][:status] = true
      end
      respond_to do |format|
        if @mechanical_review.update(mechanical_review_params)
          format.html { redirect_to mechanical_reviews_path, notice: 'La revisión mecanica se actualizo.' }
          format.json { render :show, status: :ok, location: @mechanical_review }
        else
          format.html { render :edit }
          format.json { render json: @mechanical_review.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to mechanical_reviews_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /mechanical_reviews/1
  # DELETE /mechanical_reviews/1.json
  def destroy
    @mechanical_review.destroy
    respond_to do |format|
      format.html { redirect_to mechanical_reviews_url, notice: 'La revisión mecanica se elimino con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_mechanical_review
      @mechanical_review = MechanicalReview.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mechanical_review_params
      params.require(:mechanical_review).permit(:clave, :catalog_brand_id, :descripcion, :status)
    end
end
