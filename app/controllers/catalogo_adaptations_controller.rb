class CatalogoAdaptationsController < ApplicationController
  before_action :set_catalogo_adaptation, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /catalogo_adaptations
  # GET /catalogo_adaptations.json
  def index
    des = "#{params[:adaptacion]}"
    if des != ""
      @catalogo_adaptations = CatalogoAdaptation.where("descripcion LIKE '%#{des}%'").order(descripcion: :asc)
    else
      @catalogo_adaptations = CatalogoAdaptation.all.order(descripcion: :asc)
    end
  end

  # GET /catalogo_adaptations/1
  # GET /catalogo_adaptations/1.json
  def show
  end

  # GET /catalogo_adaptations/new
  def new
    @catalogo_adaptation = CatalogoAdaptation.new
  end

  # GET /catalogo_adaptations/1/edit
  def edit
  end

  # POST /catalogo_adaptations
  # POST /catalogo_adaptations.json
  def create
    begin
      @catalogo_adaptation = CatalogoAdaptation.new(catalogo_adaptation_params)
      if !params[:catalogo_adaptation][:status].present?
        @catalogo_adaptation.status = false
      end
      respond_to do |format|
        if @catalogo_adaptation.save
          format.html { redirect_to catalogo_adaptations_path, notice: 'La adaptación se creó con exito.' }
          format.json { render :show, status: :created, location: @catalogo_adaptation }
        else
          format.html { render :new }
          format.json { render json: @catalogo_adaptation.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
       redirect_to catalogo_adaptations_path
       flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalogo_adaptations/1
  # PATCH/PUT /catalogo_adaptations/1.json
  def update
    begin
      if !params[:catalogo_adaptation][:status].present?
        params[:catalogo_adaptation][:status] = false
        else
        params[:catalogo_adaptation][:status] = true
        end
      respond_to do |format|
        if @catalogo_adaptation.update(catalogo_adaptation_params)
          format.html { redirect_to catalogo_adaptations_path, notice: 'La adaptación se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @catalogo_adaptation }
        else
          format.html { render :edit }
          format.json { render json: @catalogo_adaptation.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalogo_adaptations_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalogo_adaptations/1
  # DELETE /catalogo_adaptations/1.json
  def destroy
    @catalogo_adaptation.destroy
    respond_to do |format|
      format.html { redirect_to catalogo_adaptations_url, notice: 'La adaptacion se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalogo_adaptation
      @catalogo_adaptation = CatalogoAdaptation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalogo_adaptation_params
      params.require(:catalogo_adaptation).permit(:clave, :descripcion, :status,:monto)
    end

    def invalid_foreign_key
      redirect_to catalogo_adaptations_path, alert: 'Este registro esta siendo usado.'
    end
end
