class WorkshopCertificationsController < ApplicationController
  before_action :set_workshop_certification, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /workshop_certifications
  # GET /workshop_certifications.json
  def index
    ticket = "#{params[:numero]}"
    fecha_inicio = "#{params[:start_date]}"
    fecha_final = "#{params[:end_date]}"
    estatus = "#{params[:status]}"
    if ticket !=""
      @workshop_certifications = WorkshopCertification.where(numero_ticket: ticket)
    elsif fecha_inicio !=""
      @workshop_certifications = WorkshopCertification.where(fecha: fecha_inicio..fecha_final)
    elsif estatus !=""
      @workshop_certifications = WorkshopCertification.busqueda_status(estatus)
    elsif
      @workshop_certifications = WorkshopCertification.all.order(numero_ticket: :asc)
    end 
  end

  # GET /workshop_certifications/1
  # GET /workshop_certifications/1.json
  def show
  end

  # GET /workshop_certifications/new
  def new
    @workshop_certification = WorkshopCertification.new
  end

  # GET /workshop_certifications/1/edit
  def edit
  end

  # POST /workshop_certifications
  # POST /workshop_certifications.json
  def create
    @workshop_certification = WorkshopCertification.new(workshop_certification_params)

    respond_to do |format|
      if @workshop_certification.save
        format.html { redirect_to @workshop_certification, notice: 'Workshop certification was successfully created.' }
        format.json { render :show, status: :created, location: @workshop_certification }
      else
        format.html { render :new }
        format.json { render json: @workshop_certification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workshop_certifications/1
  # PATCH/PUT /workshop_certifications/1.json
  def update
    respond_to do |format|
      if @workshop_certification.update(workshop_certification_params)
        format.html { redirect_to workshop_certifications_path, notice: 'Se actualizaron los datos con exito.' }
        format.json { render :show, status: :ok, location: @workshop_certification }
      else
        format.html { render :edit }
        format.json { render json: @workshop_certification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workshop_certifications/1
  # DELETE /workshop_certifications/1.json
  def destroy
    @workshop_certification.destroy
    respond_to do |format|
      format.html { redirect_to workshop_certifications_url, notice: 'Workshop certification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def crear_ticket_taller
    
  end

  def guardar_ticket_taller
    taller = CatalogWorkshop.create(clave:params[:clave],catalog_branch_id:params[:catalog_branch_id],nombre_taller: params[:nombre_taller],razonsocial:params[:razonsocial],especialidad:params[:especialidad],responsable:params[:responsable],telefono:params[:telefono],domicilio:params[:domicilio],correo:params[:correo],vigente:true)
    if taller.save
      numero_consecutivo = WorkshopCertification.last
      numero_consecutivo ? nuevo_numero = numero_consecutivo.numero_ticket.to_i + 1 : nuevo_numero = 1
      ticket = WorkshopCertification.new(numero_ticket:nuevo_numero ,fecha: params[:fecha],condiciones:params[:condicion],catalog_workshop_id:taller.id,estatus:0)
      if ticket.save
        flash[:notice] = "Se registró el taller con éxito."
        redirect_to workshop_certifications_path
      else
        flash[:alert] = "Ocurrio un error al registrar el ticket."
        redirect_to workshop_certifications_path
      end
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to workshop_certifications_path
    end
  end

  def fotos_taller
    @documentos = WorkshopCertification.where(id: params[:id])
    @documento = WorkshopCertification.new
    @taller_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_fotos_taller
    id_partida = params[:workshop_certification][:id]
    @documento = WorkshopCertification.adjuntar_fotos(params, id_partida)
    @resultados = @documento
    @documentos = WorkshopCertification.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to workshop_certifications_url
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end

  def comprobante_taller
    @documentos = WorkshopCertification.where(id: params[:id])
    @documento = WorkshopCertification.new
    @taller_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_comprobante_taller
    id_partida = params[:workshop_certification][:id]
    @documento = WorkshopCertification.adjuntar_comprobante(params, id_partida)
    @resultados = @documento
    @documentos = WorkshopCertification.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to workshop_certifications_url
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end

  def caratulas_taller
    @documentos = WorkshopCertification.where(id: params[:id])
    @documento = WorkshopCertification.new
    @taller_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_caratulas_taller
    id_partida = params[:workshop_certification][:id]
    @documento = WorkshopCertification.adjuntar_caratulas(params, id_partida)
    @resultados = @documento
    @documentos = WorkshopCertification.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to workshop_certifications_url
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end
  def constancia_taller
    @documentos = WorkshopCertification.where(id: params[:id])
    @documento = WorkshopCertification.new
    @taller_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_constancia_taller
    id_partida = params[:workshop_certification][:id]
    @documento = WorkshopCertification.adjuntar_constancia(params, id_partida)
    @resultados = @documento
    @documentos = WorkshopCertification.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to workshop_certifications_url
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end

  def rfc_taller
    @documentos = WorkshopCertification.where(id: params[:id])
    @documento = WorkshopCertification.new
    @taller_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_rfc_taller
    id_partida = params[:workshop_certification][:id]
    @documento = WorkshopCertification.adjuntar_rfc(params, id_partida)
    @resultados = @documento
    @documentos = WorkshopCertification.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to workshop_certifications_url
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      respond_to do |format|
        format.js
      end
    end
  end

  def imprimir_formato_alta
    @workshop_certification =  WorkshopCertification.find_by(id: params[:workshop_certification_id])
    respond_to do |format|
			format.html
			format.pdf do
			render pdf: "imprimir",
			template: "workshop_certifications/formato_alta.html.erb",
			layout: 'formato_alta.html',
			orientation: 'Portrait'
			end
		end
  end


  private
    def validacion_menu
      session["menu1"] = "Certificación de talleres"
      session["menu2"] = ""
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_workshop_certification
      @workshop_certification = WorkshopCertification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def workshop_certification_params
      params.require(:workshop_certification).permit(:numero_ticket, :fecha, :estatus, :condiciones, :catalog_workshop_id)
    end
end
