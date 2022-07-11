class EmergencyQuerysController < ApplicationController
    skip_forgery_protection only: [:upload_documents_emergency] 
	def index

	end

    def importa_consumos
        redirect_to emergency_querys_path, notice: "Finalizo el proceso de importacion de historicos de consumos de combustible."
    end

    def eliminar_consumos
        fecha_inicio = '2021-05-01'
        fecha_fin = '2021-05-31'
        consumption = Consumption.where(fecha_inicio: fecha_inicio..fecha_fin ,fecha_fin:fecha_inicio..fecha_fin)
        consumption.each do |con|
            limpiar_detalle = VehicleConsumption.where(consumption_id: con.id).destroy_all
            limpiar_encabezado = con.destroy
        end
        redirect_to emergency_querys_path, notice: "Finalizo el proceso de eliminacion de consumos."
    end

    def importa_siniestros
        require 'axlsx'
        spreadsheet = Roo::Spreadsheet.open("public/packs/Importaciones/siniestros.xlsx")
        arreglo_siniestros = Array.new()
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            if row["numero_siniestro"] == "" or row["numero_siniestro"] == nil
                arreglo_siniestros.push(fila: row, error: "El número de siniestro está vacío")
                next
            end
            if row["Inciso"] == "" or row["Inciso"] == nil
                arreglo_siniestros.push(fila: row, error: "El inciso está vacío")
                next
            end
            if row["Fecha_ocurrio"] == "" or row["Fecha_ocurrio"] == nil
                arreglo_siniestros.push(fila: row, error: "La fecha que ocurrió está vacía")
                next
            end
            if row["fecha_reporte"] == "" or row["fecha_reporte"] == nil
                arreglo_siniestros.push(fila: row, error: "La fecha de reporte está vacía")
                next
            end
            if row["numero_serie"] == "" or row["numero_serie"] == nil
                arreglo_siniestros.push(fila: row, error: "El número de serie está vacío")
                next
            end
            if row["numero_poliza"] == "" or row["numero_poliza"] == nil
                arreglo_siniestros.push(fila: row, error: "El número de poliza está vacío")
                next
            end
            if row["cedis"] == "" or row["cedis"] == nil
                arreglo_siniestros.push(fila: row, error: "El cedis está vacío")
                next
            end
            if row["numero_economico"] == "" or row["numero_economico"] == nil
                arreglo_siniestros.push(fila: row, error: "el número económico está vacío")
                next
            end
            if row["tipo_siniestro"] == "" or row["tipo_siniestro"] == nil
                arreglo_siniestros.push(fila: row, error: "El tipo de siniestro está vacío")
                next
            end
            if row["responsable"] == "" or row["responsable"] == nil
                arreglo_siniestros.push(fila: row, error: "El responsable está vacío")
                next
            end
            if row["monto_siniestro"] == "" or row["monto_siniestro"] == nil
                arreglo_siniestros.push(fila: row, error: "El monto del siniestro está vacío")
                next
            end
            if row["estatus_responsabilidad_gafi"] == "" or row["estatus_responsabilidad_gafi"] == nil
                arreglo_siniestros.push(fila: row, error: "El estatus de responsabilidad de GAFI está vacío")
                next
            end
            if row["estatus_responsabilidad_aseguradora"] == "" or row["estatus_responsabilidad_aseguradora"] == nil
                arreglo_siniestros.push(fila: row, error: "El estatus de responsibilidad de la aseguradora está vacío")
                next
            end
            if row["coincide"] == "" or row["coincide"] == nil
                arreglo_siniestros.push(fila: row, error: "Coincide está vacío")
                next
            end
            if row["catalog_area_id"] == "" or row["catalog_area_id"] == nil
                arreglo_siniestros.push(fila: row, error: "El área del vehículo está vacío")
                next
            end
            begin
                #byebug
                #fecha_ocurrio = Date.strptime(row["Fecha_ocurrio"], "%d/%m/%Y")
                #fecha_reporte = Date.strptime(row["fecha_reporte"], "%d/%m/%Y")
                fecha_ocurrio = row["Fecha_ocurrio"]
                fecha_reporte = row["fecha_reporte"]
                cedis = CatalogBranch.find_by("decripcion iLike ?", "%#{row["cedis"].to_s}%" )
                if !cedis
                    arreglo_siniestros.push(fila: row, error: "No se encontró el cedis ingresado")
                    next
                end
                vehicle = Vehicle.find_by(numero_economico: row["numero_economico"])
                if !vehicle
                    arreglo_siniestros.push(fila: row, error: "No se encontró el vehículo ingresado")
                    next
                end
                tipo_siniestro = TypeSinister.find_by(nombreSiniestro: row["tipo_siniestro"].to_s )
                if !tipo_siniestro
                    arreglo_siniestros.push(fila: row, error: "No se encontró el tipo de siniestro ingresado")
                    next
                end
                responsable = CatalogPersonal.find_by("nombre iLike ?", "%#{row["responsable"].to_s}%")
                if !responsable
                    arreglo_siniestros.push(fila: row, error: "No se encontró el responsable de siniestro ingresado")
                    next
                end
                area = CatalogArea.find_by(id: row["catalog_area_id"])
                if !area
                    arreglo_siniestros.push(fila: row, error: "No se encontró el área ingresada")
                    next
                end
                
                registro = InsuranceReportTicket.create(
                    numero_siniestro:                   row["numero_siniestro"],
                    inciso:                              row["Inciso"],
                    fecha_ocurrio:                      fecha_ocurrio,
                    fecha_reporte:                      fecha_reporte,
                    vehicle_id:                          vehicle.id,
                    numero_serie:                       row["numero_serie"],
                    numero_poliza:                      row["numero_poliza"],
                    cedis:                               cedis.decripcion,
                    numero_economico:                  vehicle.numero_economico,
                    vehiculo:                            vehicle.catalog_brand.descripcion,
                    modelo:                             vehicle.catalog_model.descripcion,
                    estatus_vehiculo:                    vehicle.vehicle_status.descripcion,
                    type_sinisters_id:                    tipo_siniestro.id,
                    tipo_siniestro:                       tipo_siniestro.nombreSiniestro,
                    responsable:                         responsable.nombre,
                    estatus:                              2,
                    monto_siniestro:                      row["monto_siniestro"],
                    cargo_deducible_empresa:            row["cargo_deducible_empresa"],
                    cargo_deducible_empleado:           row["cargo_deducible_empleado"],
                    declaracion:                          row["declaracion"],
                    estatus_responsabilidad_gafi:         row["estatus_responsabilidad_gafi"],
                    estatus_responsabilidad_aseguradora: row["estatus_responsabilidad_aseguradora"],
                    coincide:                             row["coincide"].to_i,
                    comentarios_adicionales:              row["comentarios_adicionales"],
                    folio:                                 row["folio"],
                    registro:                             current_user.id,
                    catalog_area_id:                     area.id
                )
            rescue Exception => e
                arreglo_siniestros.push(fila: row, error: e)
                next
            end
        end
        if arreglo_siniestros.length > 0
            package = Axlsx::Package.new
            workbook = package.workbook
            workbook.styles do |s|
                workbook.add_worksheet(name: "registros") do |sheet|
                    sheet.add_row ["numero_siniestro","Inciso","Fecha_ocurrio","fecha_reporte","vehicle_id", "numero_serie",  "numero_poliza", "cedis", "numero_economico", "vehiculo", "modelo", "tipo","estatus_vehiculos", "type_sinisters_id", "tipo_siniestro", "responsable", "monto_siniestro", "cargo_deducible_empresa", "cargo_deducible_empleado", "declaracion", "estatus_responsabilidad_gafi", "estatus_responsabilidad_aseguradora", "coincide", "comentarios_adicionales", "folio", "contacto", "estatus", "registro", "catalog_area_id", "error"]
                    arreglo_siniestros.each do |siniestro|
                        sheet.add_row [siniestro[:fila]["numero_siniestro"],siniestro[:fila]["Inciso"],siniestro[:fila]["Fecha_ocurrio"],siniestro[:fila]["fecha_reporte"],siniestro[:fila]["vehicle_id"],siniestro[:fila]["numero_serie"],siniestro[:fila]["numero_poliza"],siniestro[:fila]["cedis"],siniestro[:fila]["numero_economico"],siniestro[:fila]["vehiculo"],siniestro[:fila]["modelo"],siniestro[:fila]["tipo"],siniestro[:fila]["estatus_vehiculos"],siniestro[:fila]["type_sinisters_id"],siniestro[:fila]["tipo_siniestro"],siniestro[:fila]["responsable"],siniestro[:fila]["monto_siniestro"],siniestro[:fila]["cargo_deducible_empresa"],siniestro[:fila]["cargo_deducible_empleado"],siniestro[:fila]["declaracion"],siniestro[:fila]["estatus_responsabilidad_gafi"],siniestro[:fila]["estatus_responsabilidad_aseguradora"],siniestro[:fila]["coincide"],siniestro[:fila]["comentarios_adicionales"],siniestro[:fila]["folio"],siniestro[:fila]["contacto"],siniestro[:fila]["estatus"],siniestro[:fila]["registro"], siniestro[:fila]["catalog_area_id"], siniestro[:error]]
                    end
                end
            end
            send_data package.to_stream.read, type: "application/xlsx", filename: "Errores carga siniestralidad.xlsx"
        else
            redirect_to emergency_querys_path, notice: "Finalizo el proceso de importacion de historicos de siniestros."
        end
    end

    def importa_concept_brands
        require 'axlsx'
        spreadsheet = Roo::Spreadsheet.open("public/packs/Importaciones/concept_brands.xlsx")
        arreglo = Array.new()
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            begin
                concept_brands = ConceptBrand.find_by(catalog_brand_id: row["catalog_brand_id"], concept_description_id: row["concept_description_id"], estatus: true)
                if !concept_brands
                    registro = ConceptBrand.create(id:row["id"],catalog_brand_id: row["catalog_brand_id"], concept_description_id: row["concept_description_id"],estatus:true)
                end
            rescue => exception
                arreglo.push(fila: row, error: exception)
                next
            end 
        end
        if arreglo.length > 0
            redirect_to emergency_querys_path, alert: "Ocurrio un error."
        else

            redirect_to emergency_querys_path, notice: "Finalizo el proceso de importacion."
        end
    end

    def importa_gastos_mmto
        require 'axlsx'
        spreadsheet = Roo::Spreadsheet.open("public/packs/Importaciones/ene22.xlsx")
        arreglo = Array.new()
        header = spreadsheet.row(1)
        #byebug
            (2..spreadsheet.last_row).each do |i|
                #if i == 0
                #    byebug
                #end
                row = Hash[[header, spreadsheet.row(i)].transpose]
                vehicle = Vehicle.find_by(numero_economico: row["vehicle_id"])
                if !vehicle
                    arreglo.push(fila: row, error: "No se encontró el vehículo ingresado #{row["vehicle_id"]}")
                    next
                end
                proveedor = CatalogVendor.find_by(clave:row["clave taller"])
                if !proveedor
                    arreglo.push(fila: row, error: "No se encontró el proveedor ingresado")
                    next
                else
                    taller = CatalogWorkshop.find_by(catalog_vendor_id: proveedor.id)
                    if !taller
                        arreglo.push(fila: row, error: "No se encontró el taller ingresado")
                        next
                    end
                end
                reparacion = CatalogRepair.find_by(clave:row["clave repair"])
                if !reparacion
                    arreglo.push(fila: row, error: "No se encontró la reparación ingresada")
                    next
                end
                begin
                    busqueda = MaintenanceControl.find_by(vehicle_id:vehicle.id,catalog_workshop_id:taller.id,catalog_repair_id:reparacion.id,mes_pago:row["mes_pago"],observaciones:row["observaciones"],fecha_factura:row["fecha_factura"],año:row["año"],importe:row["importe"],importe_iva:row["importe_iva"],ciudad:row["ciudad"],km_actual:row["km_actual"],dias_taller:row["dias_taller"])
                    if !busqueda
                        registro = MaintenanceControl.create(vehicle_id:vehicle.id,catalog_workshop_id:taller.id,catalog_repair_id:reparacion.id,mes_pago:row["mes_pago"],observaciones:row["observaciones"],fecha_factura:row["fecha_factura"],año:row["año"],importe:row["importe"],importe_iva:row["importe_iva"],ciudad:row["ciudad"],km_actual:row["km_actual"],dias_taller:row["dias_taller"])         
                    end
                rescue => exception
                    arreglo.push(fila: row, error: exception)
                    next
                end
            end
        if arreglo.length > 0
            package = Axlsx::Package.new
            workbook = package.workbook
            workbook.styles do |s|
                workbook.add_worksheet(name: "registros") do |sheet|
                    sheet.add_row ["vehicle_id","clave taller","clave repair","error"]
                     arreglo.each do |dato|
                        sheet.add_row [dato[:fila]["vehicle_id"],dato[:fila]["clave taller"],dato[:fila]["clave repair"], dato[:error]]
                    end
                end
            end
            send_data package.to_stream.read, type: "application/xlsx", filename: "Errores carga.xlsx"
        else
            redirect_to emergency_querys_path, notice: "Finalizo el proceso de importacion"
        end
    end

    def importa_presupuesto_combustible
        require 'axlsx'
        spreadsheet = Roo::Spreadsheet.open("public/packs/Importaciones/presupuesto_combustible.xlsx")
        arreglo = Array.new()
        header = spreadsheet.row(1)
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header, spreadsheet.row(i)].transpose]
                vehicle = Vehicle.find_by(numero_economico: row["vehicle_id"])
                if !vehicle
                    arreglo.push(fila: row, error: "No se encontró el vehículo ingresado")
                    next
                end
                begin
                    busqueda = FuelBudget.find_by(vehicle_id:vehicle.id)
                    if !busqueda
                        registro = FuelBudget.create(vehicle_id:vehicle.id,litros:row["litros"],precio_litro:row["precio_litro"])         
                    end
                rescue => exception
                    arreglo.push(fila: row, error: exception)
                    next
                end
            end
        if arreglo.length > 0
            package = Axlsx::Package.new
            workbook = package.workbook
            workbook.styles do |s|
                workbook.add_worksheet(name: "registros") do |sheet|
                    sheet.add_row ["vehicle_id","error"]
                     arreglo.each do |dato|
                        sheet.add_row [dato[:fila]["vehicle_id"], dato[:error]]
                    end
                end
            end
            send_data package.to_stream.read, type: "application/xlsx", filename: "Errores carga.xlsx"
        else
            redirect_to emergency_querys_path, notice: "Finalizo el proceso de importacion"
        end
    end

    def programa_mtto
        #busca todos los vehiculos
        bandera_error = 0
        fecha_actual = Date.today
        @vehicles = Vehicle.all
        @vehicles.each do |veh|
            programa_mmto = MaintenanceProgram.find_by(vehicle_id: veh.id)
            frecuencia = MaintenanceFrecuency.find_by(vehicle_type_id: veh.vehicle_type_id,catalog_model_id:veh.catalog_model_id)
            #si no encuentra el registro en programa mmto y encuentra la frecuencia
            if programa_mmto.nil? and frecuencia
                registro = MaintenanceProgram.create(vehicle_id: veh.id, km_inicio_ano:0,km_recorrido_curso:0,promedio_mensual:0,frecuencia_mantenimiento:frecuencia.frecuencia,fecha_ultima_afinacion:fecha_actual,kms_ultima_afinacion:0,kms_proximo_servicio:frecuencia.frecuencia,km_actual:0,fecha_proximo:fecha_actual + 6.months ,maintenance_frecuency_id:frecuencia.id)
            #elsif programa_mmto.nil?
            #    registro = MaintenanceProgram.create(vehicle_id: veh.id, km_inicio_ano:0,km_recorrido_curso:0,promedio_mensual:0,frecuencia_mantenimiento:0,fecha_ultima_afinacion:fecha_actual,kms_ultima_afinacion:0,kms_proximo_servicio:0,km_actual:0,fecha_proximo:fecha_actual + 6.months)
            end 
            #byebug
        end 
        redirect_to emergency_querys_path, notice: "Finalizo el proceso de generacion de programas de mtto."

    end

    def importa_tipos_permiso_remolque
        require 'axlsx'
        spreadsheet = Roo::Spreadsheet.open("public/packs/Importaciones/Tipos permiso.xlsx")
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            
            registro = PermissionType.create(
                clave:                      row["Clave"],
                descripcion:                row["Descripción"],
                clave_transporte:           row["Clave transporte"],
                fecha_inicio_vigencia:       row["Fecha de inicio de vigencia"]
            )
        end
        redirect_to emergency_querys_path, notice: "Finalizó el proceso de importación de tipos de permiso de remolque."
    end

    def importa_subtipo_remolque
        require 'axlsx'
        spreadsheet = Roo::Spreadsheet.open("public/packs/Importaciones/Subtipos remolque.xlsx")
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
                
            registro = TrailerSubtype.create(
                clave:                      row["Clave tipo remolque"],
                nombre:                    row["Remolque o semirremolque"],
                fecha_inicio_vigencia:       row["Fecha de inicio de vigencia"]
            )
        end
        redirect_to emergency_querys_path, notice: "Finalizó el proceso de importación de subtipos de remolque."
    end

    def importa_configuracion_vehiculo
        require 'axlsx'
        spreadsheet = Roo::Spreadsheet.open("public/packs/Importaciones/Configuracion autotransporte.xlsx")
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
                
            registro = VehicleConfiguration.create(
                clave:                      row["Clave nomenclatura"],
                descripcion:                row["Descripción"],
                numero_ejes:               row["Número de ejes"],
                numero_llantas:             row["Número de llantas"],
                fecha_inicio_vigencia:       row["Fecha de inicio de vigencia"]
            )
        end
        redirect_to emergency_querys_path, notice: "Finalizó el proceso de importación de tipos de configuraciones de autotransporte."
    end

    def upload_documents_emergency
        separacion = params[:file].original_filename.split(" ")
        @vehicle = Vehicle.find_by(numero_economico: separacion[0])
        if separacion[1].nil?
            tipo_documento = nil
        else
            tipo_documento = separacion[1]
        end
        # existe = VehicleFile.find_by(nombre_archivo: params[:file].original_filename)
        # if existe
        #     fecha_vigencia = existe.fecha_vencimiento
        # else
        #     fecha_vigencia = nil
        # end
        
        if separacion[2].nil?
            fecha_vigencia = nil
        else
            begin
                fecha_vigencia = Date.strptime(separacion[2], "%d_%m_%Y")
            rescue Exception => e
                fecha_vigencia = nil
            end
        end
        if @vehicle
            archivo = VehicleFile.new(documento: params[:file], vehicle_id: @vehicle.id, nombre_archivo: params[:file].original_filename, tipo_archivo: VehicleFile.cambio_tipo(tipo_documento), fecha_vencimiento: fecha_vigencia)
        
            if archivo.save
        
                @bandera_error = false
            else
                @mensaje = ""
                archivo.errors.full_messages.each do |error|
                    @mensaje += "#{error}. "
                end
                @bandera_error = true
            end
        end
    end
    
    def actualiza_programa_mtto
        vehicle_consumption = MaintenanceProgram.importar_programa(params[:file])
        if vehicle_consumption == nil
            redirect_to emergency_querys_path, notice: "Finalizó el proceso de importación de programas de mantenimiento."
        else
            require 'axlsx'
            package = Axlsx::Package.new
            workbook = package.workbook
            workbook.styles do |s|
                celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
                celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
                workbook.add_worksheet(name: "Errores") do |sheet|
                    sheet.add_row ["", "Línea", "Error"], :style => [nil,celda_cabecera,celda_cabecera]
                    vehicle_consumption.each do |vc|
                        sheet.add_row ["", vc[:linea], vc[:error]], :style => [nil,celda_tabla_td,celda_tabla_td]
                    end
                end
            end
            send_data package.to_stream.read, type: "application/xlsx", filename: "Errores importación.xlsx"
        end
    end

    def actualiza_km_programa_mtto
        bandera_error = false
        arreglo_errores = Array.new
        vehiculos = Vehicle.find_by_sql("SELECT v.id, v.numero_economico,mi.km_actual, MAX( x.date)
        FROM vehicles v
        JOIN (
            SELECT vehicle_id, MAX( fecha ) date
            FROM mileage_indicators
            GROUP BY vehicle_id
        ) x 
        ON ( vehicle_id=v.id )
        join mileage_indicators mi on (mi.vehicle_id=x.vehicle_id )
        where mi.fecha =x.date
        GROUP BY v.id, v.numero_economico,mi.km_actual")
        vehiculos.each do |veh|
            begin
                programas = MaintenanceProgram.where(vehicle_id: veh.id)
                if programas.update_all(km_actual: veh.km_actual)
                    control_mantenimientos = MaintenanceControl.where(vehicle_id: veh.id).order(km_actual: :asc) 
                    if control_mantenimientos.length == 0

                    elsif control_mantenimientos.length == 1
                        control_mantenimientos.first.update(km_actual: veh.km_actual)
                    else   
                        control_mantenimientos.last.update(km_actual: veh.km_actual)
                    end
                    next
                else
                    programas.errors.full_messages.each do |error|
                        arreglo_errores.push(vehiculo: veh.numero_economico, error: error)
                    end
                end
            rescue Exception => e
                arreglo_errores.push(vehiculo: veh.numero_economico, error: e)
            end
        end
        if arreglo_errores.length > 0
            require 'axlsx'
            package = Axlsx::Package.new
            workbook = package.workbook
            workbook.styles do |s|
                celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
                celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
                workbook.add_worksheet(name: "Errores") do |sheet|
                    sheet.add_row ["", "Vehículo", "Error"], :style => [nil,celda_cabecera,celda_cabecera]
                    arreglo_errores.each do |vc|
                        sheet.add_row ["", vc[:vehiculo], vc[:error]], :style => [nil,celda_tabla_td,celda_tabla_td]
                    end
                end
            end
            send_data package.to_stream.read, type: "application/xlsx", filename: "Errores kilometraje.xlsx"
        else
            redirect_to emergency_querys_path, notice: "Kilometraje actual en programas de mantenimiento actualizado correctamente."
        end
    end
    
    def primera_carga_transfer_veh
        vehiculos = Vehicle.where.not(vehicle_status_id: ["3", "8"])
        vehiculos.each do |vehicle|
            VehicleTransferLog.create(vehicle_id: vehicle.id, catalog_branch_id: vehicle.catalog_branch_id, user_id: User.current_user.id, fecha: Time.zone.now)
        end
        redirect_to emergency_querys_path, notice: "Bitácora cargada correctamente."
    end

    def cedis_consumo_combustible
        consumos = VehicleConsumption.where("vehicle_id is not null")
        consumos.each do |cons|
            cons.update(catalog_branch_id: cons.vehicle.catalog_branch_id) if cons.vehicle
        end
        redirect_to emergency_querys_path, notice: "Consumos actualizados correctamente."
    end
    
    def importar_usuarios
        usuarios = User.importar_usuarios(params[:file])

        require 'axlsx'
        package = Axlsx::Package.new
        workbook = package.workbook
        workbook.styles do |s|
            celda_cabecera= s.add_style :bg_color => "919191", :fg_color => "ff", :height => 20 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :center}
            celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
            if usuarios[0] != nil
                workbook.add_worksheet(name: "Errores") do |sheet|
                    sheet.add_row ["", "Línea", "Error"], :style => [nil,celda_cabecera,celda_cabecera]
                    usuarios[0].each do |vc|
                        sheet.add_row ["", vc[:linea], vc[:error]], :style => [nil,celda_tabla_td,celda_tabla_td]
                    end
                end
            end
            workbook.add_worksheet(name: "Operaciones") do |sheet|
                sheet.add_row ["", "Línea", "Detalle"], :style => [nil,celda_cabecera,celda_cabecera]
                usuarios[1].each do |vc|
                    sheet.add_row ["", vc[:linea], vc[:error]], :style => [nil,celda_tabla_td,celda_tabla_td]
                end
            end
        end
        send_data package.to_stream.read, type: "application/xlsx", filename: "Información importación.xlsx"

    end

    def corregir_economicos_siniestralidad
        todos = InsuranceReportTicket.all
        todos.each do |irt|
            irt.update(numero_economico: irt.vehicle.numero_economico)
        end
        redirect_to emergency_querys_path, notice: "Números económicos de siniestralidad actualizados correctamente."
    end
    
    
end
