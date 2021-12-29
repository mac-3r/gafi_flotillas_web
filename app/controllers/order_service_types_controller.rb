class OrderServiceTypesController < ApplicationController
  before_action :set_order_service_type, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  before_action :validacion_menu
  # GET /order_service_types
  # GET /order_service_types.json
  def index
    @order_service_types = OrderServiceType.order(nombre: :asc)
    #@order_service_types = OrderServiceType.where(status: true)
  end

  # GET /order_service_types/1
  # GET /order_service_types/1.json
  def show
  end

  # GET /order_service_types/new
  def new
    @order_service_type = OrderServiceType.new
  end

  # GET /order_service_types/1/edit
  def edit
  end

  # POST /order_service_types
  # POST /order_service_types.json
  def create
    begin
      @order_service_type = OrderServiceType.new(order_service_type_params)
      if !params[:order_service_type][:status].present?
        @order_service_type.status = false
        end
      respond_to do |format|
        if @order_service_type.save
          format.html { redirect_to order_service_types_path, notice: 'Se creó correctamente' }
          format.json { render :show, status: :created, location: @order_service_type }
        else
          format.html { render :new }
          format.json { render json: @order_service_type.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to order_service_types_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /order_service_types/1
  # PATCH/PUT /order_service_types/1.json
  def update
    begin
      if !params[:order_service_type][:status].present?
        params[:order_service_type][:status] = false
        else
        params[:order_service_type][:status] = true
        end
      respond_to do |format|
        if @order_service_type.update(order_service_type_params)
          format.html { redirect_to order_service_types_path, notice: 'Se actualizo correctamente' }
          format.json { render :show, status: :ok, location: @order_service_type }
        else
          format.html { render :edit }
          format.json { render json: @order_service_type.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to order_service_types_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /order_service_types/1
  # DELETE /order_service_types/1.json
  def destroy
    @order_service_type.destroy
    respond_to do |format|
      format.html { redirect_to order_service_types_url, notice: 'Se eliminó correctamente' }
      format.json { head :no_content }
    end
    # order_service_type = @order_service_type
    # if  order_service_type.update(status: 0)
    #   flash[:notice] = "Se eliminó correctamente"
    #    redirect_to   order_service_types_path
    #  else
    #    flash[:alert] = "Se eliminó correctamente"
    #    redirect_to   order_service_types_path
    #  end
     
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_order_service_type
      @order_service_type = OrderServiceType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_service_type_params
      params.require(:order_service_type).permit(:nombre, :descripcion, :origen, :status,:tipo)
    end

    def invalid_foreign_key
      redirect_to order_service_types_path, alert: 'Este registro esta siendo usado.'
    end
end
