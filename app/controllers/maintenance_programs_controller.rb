class MaintenanceProgramsController < ApplicationController
  before_action :set_maintenance_program, only: [:show, :edit, :update, :destroy]
  before_action :validacion_menu
  # GET /maintenance_programs
  # GET /maintenance_programs.json
  def index
    session["vehiculo_pro"] = ""
    session["empresa_pro"] = ""
    session["cedis_pro"] = ""
    session["user_pro"] = ""
    session["tipo_pro"] = ""
    session["linea_pro"] = ""
    session["area_pro"] = ""
    session["inicio_pro_mt"] = Time.zone.now.beginning_of_week
    session["fin_pro_mt"] = Time.zone.now
    #vehiculos = Vehicle.where("catalog_personal_id is not null")
    @maintenance_programs = MaintenanceProgram.consulta_programas(session["vehiculo_pro"],session["empresa_pro"],session["cedis_pro"], session["user_pro"], session["tipo_pro"], session["linea_pro"], session["area_pro"])
    
    @sin_kilometraje = true
    @mostrar_btn = false
    @parametro_kilometraje = Parameter.find_by(valor: "Valor para bitacora")
    # vehiculos.each do |vh|
    #   kilometraje = MileageIndicator.where(vehicle_id:vh.id).where("fecha between ? and ?", session["inicio_pro_mt"].to_s ,session["fin_pro_mt"].to_s)
    #   if kilometraje == []
    #       @sin_kilometraje = true
    #       break
    #   end
    # end
  end
 
  def filtrado_programa
    session["vehiculo_pro"] = params[:vehicle_id]
    session["empresa_pro"] = params[:catalog_company_id]
    session["cedis_pro"] = params[:catalog_branch_id]
    session["user_pro"] = params[:catalog_personal_id]
    session["tipo_pro"] = params[:vehicle_type_id]
    session["linea_pro"] = params[:catalog_brand_id]
    session["area_pro"] = params[:catalog_area_id]
    @parametro_kilometraje = Parameter.find_by(valor: "Valor para bitacora")
    # session["fecha_ini_pro"] = params[:fecha_inicio]
    # session["fecha_fin_pro"] = params[:fecha_fin]
    # @bandera_error = false
    # if (session["fecha_ini_pro"] == "" and session["fecha_fin_pro"] == "") or (session["fecha_ini_pro"] != "" and session["fecha_fin_pro"] != "")
      @maintenance_programs = MaintenanceProgram.consulta_programas(session["vehiculo_pro"],session["empresa_pro"],session["cedis_pro"], session["user_pro"], session["tipo_pro"], session["linea_pro"], session["area_pro"])
      if session["cedis_pro"] == ""
        @branch = nil
        @sin_kilometraje = true
        @mostrar_btn = false
      else
        @arreglo_pendientes = Array.new
        @branch = CatalogBranch.find_by(id: params[:catalog_branch_id])
        @sin_kilometraje = false
        vehiculos = Vehicle.where(catalog_branch_id: @branch.id).where("catalog_personal_id is not null").where.not(vehicle_status_id: [4, 3, 8, 10, 9], vehicle_type_id: [6, 11])
        @contador = 0
        vehiculos.each do |vh|
          kilometraje = MileageIndicator.where(vehicle_id:vh.id).where("fecha between ? and ?", Time.zone.now.beginning_of_week.to_s ,Time.zone.now.end_of_week.to_s)
          if kilometraje == []
            @contador += 1
          end
        end
        if @contador > 0
          @sin_kilometraje = true
        end
        @mostrar_btn = true
      end
    # else
    #   @bandera_error = true
    #   @mensaje = "Escribe fechas válidas o deja los campos de fecha en blanco para ver el programa actual."
    # end
    respond_to do |format|
      format.js
    end
  end

  def modal_pendientes_captura_km
    @branch = CatalogBranch.find_by(id: params[:branch_id])
    vehiculos = Vehicle.where(catalog_branch_id: @branch.id).where("catalog_personal_id is not null").where.not(vehicle_status_id: [4, 3, 8, 10, 9], vehicle_type_id: [6, 11])
    @arreglo_pendientes = Array.new
    vehiculos.each do |vh|
      kilometraje = MileageIndicator.where(vehicle_id:vh.id).where("fecha between ? and ?", Time.zone.now.beginning_of_week.to_s ,Time.zone.now.end_of_week.to_s)
      if kilometraje == []
        @arreglo_pendientes.push(vh)
      end
    end
  end
  

  def generar_excel_programa
    require 'axlsx'
    package = Axlsx::Package.new
    workbook = package.workbook
    col_widths= [3,3,3,3,3,30,3,30,3,3,3,3,3,30] 
    resultados = MaintenanceProgram.consulta_programas(session["vehiculo_pro"],session["empresa_pro"],session["cedis_pro"], session["user_pro"], session["tipo_pro"], session["linea_pro"], session["area_pro"])
    workbook.styles do |s|
      img = File.expand_path("#{Rails.root}/app/assets/images/excel_logo.png", __FILE__)
			col_widths= [3,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30] 
			celda_tabla = s.add_style :bg_color => "BFBFBF", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
      celda_cabecera2= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right, :vertical => :center}
			celda_categoria = s.add_style :bg_color => "D9D9D9", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_notas = s.add_style :fg_color => "FF0000" ,:sz => 12
			celda_afi_mayor = s.add_style :bg_color => "808080", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_afi_menor = s.add_style :bg_color => "F2F2F2", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}

      workbook.add_worksheet(name: "Programa de mantenimiento") do |sheet|
        sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
				sheet.merge_cells("B1:C7")
        sheet.add_row ["","Programa de mantenimiento","","","","", "", ""], :style => [nil, celda_cabecera2, nil, nil, nil, nil,nil,nil]
        sheet.add_row ["","","","","","","",""], :style => [nil, nil, nil, nil, nil, nil]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row ["","","","","","","",""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]

        sheet.add_row ["","Km inicio año en curso","Km recorrido año en curso","Promedio mensual recorrido (kms)","Frecuencia mantenimiento", "No. Económico","Línea","Modelo","Usuario", "Cedis","Fecha última afinación","Kms última afinación","Kms próximo servicio","Fecha próximo servicio","Km actual","Observaciones"], :style => [nil,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera,celda_cabecera]
        sheet.column_widths *col_widths
        resultados.all.each do |resultado|
          sheet.add_row ["",resultado.km_inicio_ano,resultado.km_recorrido_curso,resultado.promedio_mensual,resultado.frecuencia_mantenimiento,resultado.vehicle.numero_economico,resultado.vehicle.catalog_brand_id ? resultado.vehicle.catalog_brand.descripcion : "No se asignó",resultado.vehicle.catalog_model_id ? resultado.vehicle.catalog_model.descripcion : "No se asignó",resultado.vehicle.catalog_personal_id ? resultado.vehicle.catalog_personal.nombre : "No se asignó", resultado.vehicle.catalog_branch.decripcion,resultado.fecha_ultima_afinacion,resultado.kms_ultima_afinacion,resultado.kms_proximo_servicio,resultado.fecha_proximo,resultado.km_actual,resultado.observaciones], :style => [nil,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td,
          celda_tabla_td]
        end
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Programa de mantenimiento.xlsx"
  end


  # GET /maintenance_programs/1
  # GET /maintenance_programs/1.json
  def show
  end
  
  # GET /maintenance_programs/new
  def new
    @maintenance_program = MaintenanceProgram.new
  end

  # GET /maintenance_programs/1/edit
  def edit
  end

  # POST /maintenance_programs
  # POST /maintenance_programs.json
  def create
    @maintenance_program = MaintenanceProgram.new(maintenance_program_params)

    respond_to do |format|
      if @maintenance_program.save
        format.html { redirect_to @maintenance_program, notice: 'Maintenance program was successfully created.' }
        format.json { render :show, status: :created, location: @maintenance_program }
      else
        format.html { render :new }
        format.json { render json: @maintenance_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_programs/1
  # PATCH/PUT /maintenance_programs/1.json
  def update
    respond_to do |format|
      if @maintenance_program.update(maintenance_program_params)
        format.html { redirect_to maintenance_programs_path, notice: 'Se actualizaron los datos.' }
        format.json { render :show, status: :ok, location: @maintenance_program }
      else
        format.html { render :edit }
        format.json { render json: @maintenance_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maintenance_programs/1
  # DELETE /maintenance_programs/1.json
  def destroy
    @maintenance_program.destroy
    respond_to do |format|
      format.html { redirect_to maintenance_programs_url, notice: 'Maintenance program was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def ejecutar_mantenimiento
    Notification.notificacion_captura_kilometraje_tarde(session["cedis_pro"])
    flash[:notice] = "Programa de mantenimiento ejecutado."
    redirect_to maintenance_programs_path
  end
  
  

  private
    def validacion_menu
      session["menu1"] = "Mantenimiento"
      session["menu2"] = "Programa de mantenimiento"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_program
      @maintenance_program = MaintenanceProgram.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def maintenance_program_params
      params.require(:maintenance_program).permit(:vehicle_id, :km_inicio_ano, :km_recorrido_curso, :promedio_mensual, :frecuencia_mantenimiento, :fecha_ultima_afinacion, :kms_ultima_afinacion, :kms_proximo_servicio, :fecha_proximo, :km_actual, :observaciones)
    end
end
