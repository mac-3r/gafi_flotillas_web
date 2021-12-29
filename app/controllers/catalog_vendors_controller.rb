class CatalogVendorsController < ApplicationController
  before_action :set_catalog_vendor, only: [:show, :edit, :update, :destroy, :convertir_a_taller, :modal_convertir_a_taller]
  before_action :validacion_menu
  # GET /catalog_vendors
  # GET /catalog_vendors.json
  def index
    @catalog_vendors = CatalogVendor.order(razonsocial: :asc)
  end

  # GET /catalog_vendors/1
  # GET /catalog_vendors/1.json
  def show
  end

  # GET /catalog_vendors/new
  def new
    @catalog_vendor = CatalogVendor.new
  end

  # GET /catalog_vendors/1/edit
  def edit
  end

  # POST /catalog_vendors
  # POST /catalog_vendors.json
  def create
    @catalog_vendor = CatalogVendor.new(catalog_vendor_params)

    respond_to do |format|
      if @catalog_vendor.save
        format.html { redirect_to catalog_vendors_path, notice: 'El proveedor se creo con exito.' }
        format.json { render :show, status: :created, location: @catalog_vendor }
      else
        format.html { render :new }
        format.json { render json: @catalog_vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalog_vendors/1
  # PATCH/PUT /catalog_vendors/1.json
  def update
    respond_to do |format|
      if @catalog_vendor.update(catalog_vendor_params)
        format.html { redirect_to catalog_vendor_path, notice: 'El proveedor se actualizo con exito.' }
        format.json { render :show, status: :ok, location: @catalog_vendor }
      else
        format.html { render :edit }
        format.json { render json: @catalog_vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalog_vendors/1
  # DELETE /catalog_vendors/1.json
  def destroy
    @catalog_vendor.destroy
    respond_to do |format|
      format.html { redirect_to catalog_vendors_url, notice: 'El proveedor se elimino con exito.' }
      format.json { head :no_content }
    end
  end

  def modal_convertir_a_taller
   @catalog_workshop = CatalogWorkshop.new 
  end
  
  def convertir_a_taller
    @catalog_vendor = CatalogVendor.find_by(id: params[:id])
    @mensaje = ""
    @respuesta_error = true
    if @catalog_vendor
      @catalog_workshop = CatalogWorkshop.new(clave: @catalog_vendor.clave, catalog_branch_id: params[:catalog_workshop][:catalog_branch_id], nombre_taller: params[:catalog_workshop][:nombre_taller], razonsocial: @catalog_vendor.razonsocial, especialidad: params[:catalog_workshop][:especialidad], responsable: params[:catalog_workshop][:responsable], telefono: params[:catalog_workshop][:telefono], domicilio: @catalog_vendor.direccion, correo: params[:catalog_workshop][:correo], vigente: true, user_id: @catalog_vendor.user_id, catalog_vendor_id: @catalog_vendor.id)
      if @catalog_workshop.save
        @catalog_vendor.update(es_taller: true)
        @mensaje = "Taller registrado con éxito."
        @respuesta_error = false
      else
        @catalog_workshop.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @mensaje = "No se encontró el proveedor seleccionado."
    end
  end
  

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_vendor
      @catalog_vendor = CatalogVendor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_vendor_params
      params.require(:catalog_vendor).permit(:clave, :nombre,:contacto,:direccion,:rfc,:correo,:estatus,:razonsocial)
    end
end
