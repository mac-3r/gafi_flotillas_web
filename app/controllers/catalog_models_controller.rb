class CatalogModelsController < ApplicationController
  before_action :set_catalog_model, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalog_models
  # GET /catalog_models.json
  def index
    @catalog_models = CatalogModel.order(descripcion: :asc)
    #@catalog_models = CatalogModel.where(status: true)
  end

  # GET /catalog_models/1
  # GET /catalog_models/1.json
  def show
  end

  # GET /catalog_models/new
  def new
    @catalog_model = CatalogModel.new
  end

  # GET /catalog_models/1/edit
  def edit
  end

  # POST /catalog_models
  # POST /catalog_models.json
  def create
    begin
      @catalog_model = CatalogModel.new(catalog_model_params)
      if !params[:catalog_model][:status].present?
        @catalog_model.status = false
        end
      respond_to do |format|
        if @catalog_model.save
          format.html { redirect_to catalog_models_path, notice: 'Se creó correctamente' }
          format.json { render :show, status: :created, location: @catalog_model }
        else
          format.html { render :new }
          format.json { render json: @catalog_model.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_models_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_models/1
  # PATCH/PUT /catalog_models/1.json
  def update
    begin
      if !params[:catalog_model][:status].present?
        params[:catalog_model][:status] = false
        else
        params[:catalog_model][:status] = true
        end
      respond_to do |format|
        if @catalog_model.update(catalog_model_params)
          format.html { redirect_to catalog_models_path, notice: 'Se actualizo correctamente' }
          format.json { render :show, status: :ok, location: @catalog_model }
        else
          format.html { render :edit }
          format.json { render json: @catalog_model.errors, status: :unprocessable_entity }
        end
      end 
    rescue => exception
      redirect_to catalog_models_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_models/1
  # DELETE /catalog_models/1.json
  def destroy
     @catalog_model.destroy
     respond_to do |format|
       format.html { redirect_to catalog_models_url, notice: 'Se eliminó correctamente' }
       format.json { head :no_content }
     end
     
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_model
      @catalog_model = CatalogModel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_model_params
      params.require(:catalog_model).permit(:clave, :descripcion, :status)
    end
    def invalid_foreign_key
      redirect_to catalog_models_path, alert: 'No se puede eliminar ya que esta relacionado con otro catalogo.'
    end
end
