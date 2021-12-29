class MaintenanceAppointmentsController < ApplicationController
  before_action :set_maintenance_appointment, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /maintenance_appointments
  # GET /maintenance_appointments.json
  def index
    session["vehiculo_ci"] = ""
    session["empresa_ci"] = ""
    session["cedis_ci"] = ""
    session["user_ci"] = ""
    session["tipo_ci"] = ""
    session["linea_ci"] = ""
    session["area_ci"] = ""
    @maintenance_appointments = MaintenanceAppointment.consulta_citas(session["vehiculo_ci"],session["empresa_ci"],session["cedis_ci"], session["user_ci"], session["tipo_ci"], session["linea_ci"], session["area_ci"])
  end
 
  def filtrado_citas
    session["vehiculo_ci"] = params[:vehicle_id]
    session["empresa_ci"] = params[:catalog_company_id]
    session["cedis_ci"] = params[:catalog_branch_id]
    session["user_ci"] = params[:catalog_personal_id]
    session["tipo_ci"] = params[:vehicle_type_id]
    session["linea_ci"] = params[:catalog_brand_id]
    session["area_ci"] = params[:catalog_area_id]
    @maintenance_appointments = MaintenanceAppointment.consulta_citas(session["vehiculo_ci"],session["empresa_ci"],session["cedis_ci"], session["user_ci"], session["tipo_ci"], session["linea_ci"], session["area_ci"])
    respond_to do |format|
      format.js
    end
  end

  def generar_excel_citas
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    col_widths= [30,30,3,30,3,30,3,30,3] 
    resultados =  MaintenanceAppointment.consulta_citas(session["vehiculo_ci"],session["empresa_ci"],session["cedis_ci"], session["user_ci"], session["tipo_ci"], session["linea_ci"], session["area_ci"])
    workbook.styles do |s|
      miles_decimal = s.add_style(:format_code => "$###,###.00")
      centered = { alignment: { horizontal: :center } }
      workbook.add_worksheet(name: "Citas") do |sheet|
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["","Citas"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["Empresa","CEDIS","No. Económico","Línea","Modelo","Usuario", "Fecha cita","Taller","Estatus"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
        sheet.column_widths *col_widths
        
        resultados.all.each do |resultado|
          sheet.add_row [resultado.vehicle.catalog_company_id ? resultado.vehicle.catalog_company.nombre : "No se asignó",resultado.vehicle.catalog_branch_id ? resultado.vehicle.catalog_branch.decripcion : "No se asignó",resultado.vehicle.numero_economico,resultado.vehicle.catalog_brand_id ? resultado.vehicle.catalog_brand.descripcion : "No se asignó",resultado.vehicle.catalog_model_id ? resultado.vehicle.catalog_model.descripcion : "No se asignó",resultado.vehicle.catalog_personal_id ? resultado.vehicle.catalog_personal.nombre : "No se asignó",resultado.fecha_cita, resultado.catalog_workshop_id ? resultado.catalog_workshop.nombre_taller : "No se asignó",resultado.status]
        end
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Citas.xlsx"
  end


  # GET /maintenance_appointments/1
  # GET /maintenance_appointments/1.json
  def show
  end

  # GET /maintenance_appointments/new
  def new
    @maintenance_appointment = MaintenanceAppointment.new
  end

  # GET /maintenance_appointments/1/edit
  def edit
  end

  # POST /maintenance_appointments
  # POST /maintenance_appointments.json
  def create
    params[:maintenance_appointment][:vehicle_id] = params[:maintenance_appointment][:vehicle_id]
    params[:maintenance_appointment][:fecha_cita] = params[:maintenance_appointment][:fecha_cita].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
    params[:maintenance_appointment][:status] = 0
    @maintenance_appointment = MaintenanceAppointment.new(maintenance_appointment_params)

    respond_to do |format|
      if @maintenance_appointment.save
        format.html { redirect_to maintenance_appointments_path, notice: 'Se registro la cita con exito.' }
        format.json { render :show, status: :created, location: @maintenance_appointment }
      else
        format.html { render :new }
        format.json { render json: @maintenance_appointment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /maintenance_appointments/1
  # PATCH/PUT /maintenance_appointments/1.json
  def update
    if @maintenance_appointment.status == "Cita confirmada"
      params[:maintenance_appointment][:status] = 2
    else
      params[:maintenance_appointment][:status] = 0
    end
    #byebug
    respond_to do |format|
      if @maintenance_appointment.update(maintenance_appointment_params)
        if @maintenance_appointment.status == "Cita reasignada"
          format.html { redirect_to maintenance_appointments_path, notice: 'Cita reasignada con exito.' }
        end
        format.html { redirect_to maintenance_appointments_path, notice: 'Cita editada con exito.' }
        format.json { render :show, status: :ok, location: @maintenance_appointment }
      else
        format.html { render :edit }
        format.json { render json: @maintenance_appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maintenance_appointments/1
  # DELETE /maintenance_appointments/1.json
  def destroy
    @maintenance_appointment.destroy
    respond_to do |format|
      format.html { redirect_to maintenance_appointments_url, notice: 'Maintenance appointment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validacion_menu
      session["menu1"] = "Mantenimiento"
      session["menu2"] = "Citas"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_appointment
      @maintenance_appointment = MaintenanceAppointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def maintenance_appointment_params
      params.require(:maintenance_appointment).permit(:fecha_cita, :status, :vehicle_id, :catalog_workshop_id)
    end
end
