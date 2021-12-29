class CatalogLicencesController < ApplicationController
  before_action :set_catalog_licence, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /catalog_licences
  # GET /catalog_licences.json
  def index
    session["usuario"] = ""
    session["vehiculo"] = ""
    @catalog_licences = CatalogLicence.consulta_licencias(session["usuario"],session["vehiculo"])
  end
 
  def filtrado_licencias
    session["usuario"] = params[:user_id]
    session["vehiculo"] = params[:vehicle_id]
    @catalog_licences = CatalogLicence.consulta_licencias(session["usuario"],session["vehiculo"])
    respond_to do |format|
      format.js
    end
  end
  # GET /catalog_licences/1
  # GET /catalog_licences/1.json
  def show
  end

  # GET /catalog_licences/new
  def new
    @catalog_licence = CatalogLicence.new
  end

  # GET /catalog_licences/1/edit
  def edit
  end

  # POST /catalog_licences
  # POST /catalog_licences.json
  def create
    begin
      @catalog_licence = CatalogLicence.new(catalog_licence_params)
      params[:catalog_licence][:vehicle_id] = params[:catalog_licence][:vehicle_id]
      respond_to do |format|
        if @catalog_licence.save
          #byebug
          #adjuntar_anverso = LicencesPicture.create(catalog_licence_id:  @catalog_licence.id,imagen: ruta,tipo:"Anverso",user_id: @catalog_licence.user_id,vehicle_id:  @catalog_licence.vehicle_id)
          format.html { redirect_to catalog_licences_path, notice: 'La licencia se creó con exito, favor de adjuntar las fotografias.' }
          format.json { render :show, status: :created, location: @catalog_licence }
        else
          format.html { render :new }
          format.json { render json: @catalog_licence.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_licences_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # PATCH/PUT /catalog_licences/1
  # PATCH/PUT /catalog_licences/1.json
  def update
    begin
      respond_to do |format|
        if @catalog_licence.update(catalog_licence_params)
          format.html { redirect_to catalog_licences_path, notice: 'La licencia se actualizó con exito.' }
          format.json { render :show, status: :ok, location: @catalog_licence }
        else
          format.html { render :edit }
          format.json { render json: @catalog_licence.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      redirect_to catalog_licences_path
      flash[:alert] = "Ocurrio un error, favor de contactar soporte. Error: #{exception}"
    end
  end

  # DELETE /catalog_licences/1
  # DELETE /catalog_licences/1.json
  def destroy
    @catalog_licence.destroy
    respond_to do |format|
      format.html { redirect_to catalog_licences_url, notice: 'La licencia se eliminó con exito.' }
      format.json { head :no_content }
    end
  end

  def fotos_anverso
    @documentos = CatalogLicence.where(id: params[:id])
    @documento = CatalogLicence.new
    @licencia_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_fotos_anverso
    id_partida = params[:catalog_licence][:id]
    @documento = CatalogLicence.adjuntar_fotos_anverso(params, id_partida)
    @resultados = @documento
    @documentos = CatalogLicence.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to catalog_licences_url
    else
      @bandera_error = @documento[1]
      flash[:alert] = @documento[0]
      redirect_to catalog_licences_url
    end
  end
  def fotos_reverso
    @documentos = CatalogLicence.where(id: params[:id])
    @documento = CatalogLicence.new
    @licencia_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_fotos_reverso
    id_partida = params[:catalog_licence][:id]
    @documento = CatalogLicence.adjuntar_fotos_reverso(params, id_partida)
    @resultados = @documento
    @documentos = CatalogLicence.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to catalog_licences_url
    else
      @bandera_error = @documento[1]
      flash[:alert] = @documento[0]
      redirect_to catalog_licences_url
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_licence
      @catalog_licence = CatalogLicence.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_licence_params
      params.require(:catalog_licence).permit(:clave, :descripcion,:numero_licencia,:fecha_vencimiento,:vehicle_id,:user_id)
    end
end
