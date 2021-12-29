class ReasonsController < ApplicationController
  before_action :set_reason, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /reasons
  # GET /reasons.json
  def index
    @reasons = Reason.all.order(descripcion: :asc)
  end

  # GET /reasons/1
  # GET /reasons/1.json
  def show
  end

  # GET /reasons/new
  def new
    @reason = Reason.new
  end

  # GET /reasons/1/edit
  def edit
  end

  # POST /reasons
  # POST /reasons.json
  def create
    begin
      @reason = Reason.new(reason_params)
  
      respond_to do |format|
        if @reason.save
          format.html { redirect_to reasons_path, notice: 'El motivo se creo con exito.' }
          format.json { render :show, status: :created, location: @reason }
        else
          format.html { render :new }
          format.json { render json: @reason.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to reasons_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /reasons/1
  # PATCH/PUT /reasons/1.json
  def update
    begin
      respond_to do |format|
        if @reason.update(reason_params)
          format.html { redirect_to reasons_path, notice: 'El motivo se actualizo con exito.' }
          format.json { render :show, status: :ok, location: @reason }
        else
          format.html { render :edit }
          format.json { render json: @reason.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to reasons_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /reasons/1
  # DELETE /reasons/1.json
  def destroy
    @reason.destroy
    respond_to do |format|
      format.html { redirect_to reasons_url, notice: 'El motivo se elimino con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_reason
      @reason = Reason.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reason_params
      params.require(:reason).permit(:descripcion)
    end

    def invalid_foreign_key
      redirect_to reasons_path, alert: 'Este registro esta siendo usado.'
    end
end
