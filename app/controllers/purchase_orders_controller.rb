class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /purchase_orders
  # GET /purchase_orders.json
  def index
    session["status"] = "Todos"
    session["rango"] = "Todos"
    session["orden_fini"] = Time.zone.now.to_date
    session["orden_ffin"] = Time.zone.now.to_date

    @purchase_orders = PurchaseOrder.consulta_ordenes(session["status"],session["orden_fini"], session["orden_ffin"], session["rango"]).order(created_at: :desc)
  end

  def filtrado_ordenes
    session["status"] = params[:registro]
    session["rango"] = params[:rango]
    if params[:start_date] != "" and params[:end_date] != ""
      session["orden_fini"] = Date.strptime(params[:start_date], "%d/%m/%Y")
      session["orden_ffin"] = Date.strptime(params[:end_date], "%d/%m/%Y")
    else
      session["orden_fini"] = ""
      session["orden_ffin"] = ""
    end
    
    @purchase_orders = PurchaseOrder.consulta_ordenes(session["status"],session["orden_fini"], session["orden_ffin"],session["rango"]).order(created_at: :desc)
    respond_to do |format|
      format.js
    end
  end
  # GET /purchase_orders/1
  # GET /purchase_orders/1.json
  def show
    @tipo_orden = @purchase_order #Se agregó en los métodos que se usa para registrar una orden de compra para identificar el tipo de orden
    @purchase_details = @purchase_order.purchase_details
    @firma = UserSignature.find_by(user_id: @purchase_order.user_id)
    @usuario = User.find_by(id: @purchase_order.usuario_creador)
  end

  def nueva_orden
    @purchase_order = PurchaseOrder.new
  end

  def crear_orden
    @purchase = PurchaseOrder.crear_ord(params)
    if @purchase[0] == 4
      redirect_to edit_purchase_order_path(@purchase[1])
      flash[:notice] = @purchase[2]
    else
      redirect_to purchase_orders_path
      flash[:alert] = @purchase[2]
    end
  end

  def formulario_agregar_detalle_orden
    @tipo_orden = PurchaseOrder.find_by(id: session["orden"]) #Se agregó en los métodos que se usa para registrar una orden de compra para identifucar el tipo de orden
    @purchase_detail = PurchaseDetail.new
    respond_to do |format|
    format.js
    end
  end

  def guardar_detalle_orden
    @detalle = PurchaseDetail.detalle(params,session["orden"])
    @tipo_orden = PurchaseOrder.find_by(id: session["orden"]) #Se agregó en los métodos que se usa para registrar una orden de compra para identifucar el tipo de orden

    if @detalle[1] == 4
      @encabezado = PurchaseOrder.find(@detalle[2])
      @purchase_details = @encabezado.purchase_details
    end
    respond_to do |format|
        format.js
    end
  end

  # GET /purchase_orders/new
  def new
    @purchase_order = PurchaseOrder.new
  end

  # GET /purchase_orders/1/edit
  def edit
    @purchase_details = @purchase_order.purchase_details
    session["orden"] = @purchase_order.id
    @tipo_orden = PurchaseOrder.find_by(id: session["orden"]) #Se agregó en los métodos que se usa para registrar una orden de compra para identifucar el tipo de orden
    if @purchase_order
      @purchase_details = @purchase_order.purchase_details
    else
      flash[:alert]= "No existe el registro"
      redirect_to purchase_orders_path
      
    end
  end

  # POST /purchase_orders
  # POST /purchase_orders.json
  def create
    params[:purchase_order][:status] = 0
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    params[:purchase_order][:catalog_company_id] = params[:purchase_order][:catalog_company_id]
    params[:purchase_order][:cost_center_id] = params[:purchase_order][:cost_center_id]
    params[:purchase_order][:catalog_vendor_id] = params[:purchase_order][:catalog_vendor_id]
    params[:purchase_order][:vehicle_type_id] = params[:purchase_order][:vehicle_type_id]
    params[:purchase_order][:catalog_brand_id] = params[:purchase_order][:catalog_brand_id]
    params[:purchase_order][:catalog_model_id] = params[:purchase_order][:catalog_model_id]
    respond_to do |format|
      if @purchase_order.save
        format.html { redirect_to  purchase_orders_url, notice: 'La orden de compra se creo con exito.' }
        format.json { render :show, status: :created, location: @purchase_order }
      else
        format.html { render :new }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_orders/1
  # PATCH/PUT /purchase_orders/1.json
  def update
    @bandera_error = 0
    @errores = ""
    @purchase_order = PurchaseOrder.find(params[:id])
    respond_to do |format|
      if @purchase_order.purchase_details.count > 0
        @busqueda = PurchaseDetail.where(purchase_order_id:@purchase_order.id).sum(:total_detalle)
        if @busqueda
            subtotal = @busqueda.to_f
            monto_iva = subtotal * 0.16
            total = subtotal + monto_iva
            @purchase_order.update(subtotal:subtotal,monto_iva:monto_iva,total:total)
            format.html { redirect_to purchase_orders_path, notice: 'Registro finalizado con éxito.' }
            format.json { render :show, status: :ok, location: @purchase_order }
        else
          format.html { redirect_to purchase_orders_path, alert: 'Ocurrio un error en el registro.' }

        end
      else
        format.html { redirect_to edit_purchase_order_path(@purchase_order.id), alert:  'El registro debe tener al menos un datos.' }
      end
    end
  end
  def eliminar_partida_orden
    @tipo_orden = PurchaseOrder.find_by(id: session["orden"]) #Se agregó en los métodos que se usa para registrar una orden de compra para identifucar el tipo de orden
    @bandera = 0
    @mensaje = ""
    detalle = PurchaseDetail.find_by(id: params[:id_partida])
    if detalle
      id_pedido = detalle.purchase_order_id            
      if detalle.destroy

        # Calculando de nuevo los totales de la orden -----------------------------------------
        nuevo_subtotal = @tipo_orden.purchase_details.sum(:total_detalle)
        nuevo_iva = (nuevo_subtotal*0.16)
        nuevo_total = (nuevo_subtotal+nuevo_iva)
        @tipo_orden.update(subtotal: nuevo_subtotal, monto_iva: nuevo_iva, total: nuevo_total )
        # Calculando de nuevo los totales de la orden -----------------------------------------
        
        @mensaje = "Datos eliminados correctamente."
        @purchase_details = PurchaseDetail.where(purchase_order_id: id_pedido)
      else
        @bandera = 1
        detalle.errors.full_messages.each do |mensaje|
          @mensaje += mensaje    
        end
      end
    else
      @bandera = 2
      @mensaje += "No se encontró la partida."
    end        
    respond_to do |format|
      format.js
    end
  end
  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.json
  def destroy
    @purchase_order.destroy
    respond_to do |format|
      format.html { redirect_to purchase_orders_url, notice: 'Purchase order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def imprimir_orden
		@purchase_order = PurchaseOrder.find_by(id: params[:id])
      respond_to do |format|
        format.html
        format.pdf do
        render pdf: "impresion",
        template: "purchase_order/show.html.erb",
        layout: 'impresion.html',
        orientation: 'Portrait'
       end
		end
  end

  def documentos_orden
    @documentos = PurchaseOrder.where(id: params[:id])
    @documento = PurchaseOrder.new
    @orden_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def factura_orden
    @documentos = PurchaseOrder.where(id: params[:id])
    @documento = PurchaseOrder.new
    @orden_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  #CARGAR PDF
  def cargar_documento_orden
    id_partida = params[:purchase_order][:id]
    @documento = PurchaseOrder.crear_pdf(params, id_partida)
    #byebug
    @resultados = @documento
    @documentos = PurchaseOrder.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to purchase_orders_path
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end
    #CARGAR FACTURA XML
  def cargar_factura_orden
    id_partida = params[:purchase_order][:id]
    @documento = PurchaseOrder.crear_factura(params, id_partida)
    orden = PurchaseOrder.find_by(id: id_partida)
    #byebug
    @resultados = @documento
    @documentos = PurchaseOrder.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      orden.update(status:"Autorizado")
      flash[:notice] = @documento[0]
      redirect_to edit_vehicle_path(@documento[2])
    else
      @bandera_error = @documento[1]
      flash[:alert] = @documento[0]
      redirect_to purchase_orders_path
    end
  end  

  def get_modelos_articulos
    tipo = ""
    if params[:tipo] == "Compra de llantas"
        tipo = "Llanta"
      elsif params[:tipo] == "Compra de baterías"
        tipo = "Batería"
      elsif params[:tipo] == "Compra de extintores"
        tipo = "Extintor"
    end
    
    @modelos_articulos = CatalogTiresBattery.listado_articulos(params[:brand_id], tipo)
  end
  
  def get_precios_articulos
    @articulo = CatalogTiresBattery.find_by(id: params[:catalog_tires_battery_id])
    # byebug
  end
  

  private
    def validacion_menu
      session["menu1"] = "Maestro de vehículos"
      session["menu2"] = "Orden de compra"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_order
      @purchase_order = PurchaseOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchase_order_params
      params.require(:purchase_order).permit(:catalog_company_id, :fecha, :cost_center_id, :vehicle_type_id, :catalog_brand_id, :monto, :catalog_vendor_id,:condicion,:catalog_model_id,:cantidad,:subtotal,:monto_iva,:total,:status,:plazo_dias)
    end
end
