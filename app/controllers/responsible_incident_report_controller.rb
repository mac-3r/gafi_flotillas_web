class ResponsibleIncidentReportController < ApplicationController
	authorize_resource :class => false
	before_action :validacion_menu
	def index
		@tipos_siniestro = TypeSinister.where(status: true).order(nombreSiniestro: :asc)
		@responsables = CatalogPersonal.all.order(nombre: :asc)
	end

	def filtrado_incidentes
		session["tck_resp_nec"] = params[:keyword]
		session["tck_resp_ced"] = params[:catalog_branch_id]
		session["tck_resp_com"] = params[:catalog_company_id]
		session["tck_resp_res"] = params[:responsable]
		session["tck_resp_sin"] = params[:siniestro]
		session["tck_resp_are"] = params[:area_id]
		fecha_hoy =  Date.today
		fecha_inicio = fecha_hoy - 12.months
		#si no se inserta la fecha buscara de enero a la fecha actual
		if params[:start_date] != "" and params[:end_date] != ""
			session["tck_resp_fini"] = Date.strptime(params[:start_date], "%d/%m/%Y")
			session["tck_resp_ffin"] = Date.strptime(params[:end_date], "%d/%m/%Y")
		else
			session["tck_resp_fini"] = Date.strptime(fecha_inicio.strftime("%d/%m/%Y"), "%d/%m/%Y")
			session["tck_resp_ffin"] = Date.strptime(fecha_hoy.strftime("%d/%m/%Y"), "%d/%m/%Y")
		end
		@ticket = InsuranceReportTicket.consulta_responsable(session["tck_resp_nec"],session["tck_resp_ced"],session["tck_resp_com"],session["tck_resp_fini"],session["tck_resp_ffin"],session["tck_resp_res"],session["tck_resp_sin"], session["tck_resp_are"])
		#byebug
		@responsables = ResponsibleReportResponsible.responsables_matriz(session["tck_resp_fini"],session["tck_resp_ffin"],session["tck_resp_ced"],session["tck_resp_sin"], session["tck_resp_are"])
		respond_to do |format|
			format.js
		end
	end

	def excel_incidentes
		ticket = InsuranceReportTicket.consulta_responsable(session["tck_resp_nec"],session["tck_resp_ced"],session["tck_resp_com"],session["tck_resp_fini"].to_date,session["tck_resp_ffin"].to_date,session["tck_resp_res"],session["tck_resp_sin"], session["tck_resp_are"])
		responsables = ResponsibleReportResponsible.responsables_matriz(session["tck_resp_fini"].to_date,session["tck_resp_ffin"].to_date,session["tck_resp_ced"],session["tck_resp_sin"], session["tck_resp_are"])
		require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		workbook.styles do |s|
			miles_decimal = s.add_style(:format_code => "$###,###.00")
            workbook.add_worksheet(name: "Tabla") do |sheet|
                sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Tabla"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
				sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Empresa","CEDIS","Chofer","Costo siniestro", "Total siniestros", "Costo total"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
				ticket[0].each do |responsable|
					sheet.add_row ["#{responsable["empresa"]}", "#{responsable["cedis"]}", "#{responsable["chofer"]}", "#{responsable["costo_siniestro"]}", "#{responsable["total_siniestro"]}", "#{responsable["costo_total"]}"], style: [nil, nil, nil,miles_decimal, nil, miles_decimal]
				end
			end
			workbook.add_worksheet(name: "Matríz Reponsable") do |sheet|
                sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Matríz Responsable"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
				sheet.add_row [""]
				sheet.add_row [""]
				ticket[0].each do |responsable|
					sheet.add_row ["#{responsable["mes"]}", "#{responsable["cantidad"]}"]
				end
			end
			workbook.add_worksheet(name: "Matríz todos") do |sheet|
                sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Matríz Responsable"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
				sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Conductor", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
				responsables.each do |resp|
					sheet.add_row ["#{resp["responsable"]}","#{resp["agosto"]}","#{resp["septiembre"]}","#{resp["octubre"]}","#{resp["noviembre"]}","#{resp["diciembre"]}","#{resp["enero"]}","#{resp["febrero"]}","#{resp["marzo"]}","#{resp["abril"]}","#{resp["mayo"]}","#{resp["junio"]}","#{resp["julio"]}"]
				end
			end
		end
        send_data package.to_stream.read, type: "application/xlsx", filename: "responsables.xlsx"
		#excel_1_incidentes()
		#excel_2_incidentes()
		#excel_3_incidentes()
	end

	def excel_1_incidentes()
		ticket = InsuranceReportTicket.consulta_responsable(session["tck_resp_nec"],session["tck_resp_ced"],session["tck_resp_com"],session["tck_resp_fini"],session["tck_resp_ffin"],session["tck_resp_res"],session["tck_resp_sin"], session["tck_resp_are"])
		responsables = ResponsibleReportResponsible.responsables_matriz(session["tck_resp_fini"],session["tck_resp_ffin"],session["tck_resp_ced"],session["tck_resp_sin"])
		require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		workbook.styles do |s|
			miles_decimal = s.add_style(:format_code => "$###,###.00")
            workbook.add_worksheet(name: "Tabla") do |sheet|
                sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Tabla"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
				sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Empresa","CEDIS","Chofer","Costo siniestro", "Total siniestros", "Número económico" , "Costo total"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
				ticket[0].each do |responsable|
					sheet.add_row ["#{responsable["empresa"]}", "#{responsable["cedis"]}", "#{responsable["chofer"]}", "#{responsable["costo_siniestro"]}", "#{responsable["total_siniestro"]}", "#{responsable["vehiculos"]}", "#{responsable["costo_total"]}"], style: [nil, nil, nil,miles_decimal, nil, miles_decimal]
				end
			end
			workbook.add_worksheet(name: "Matríz Reponsable") do |sheet|
                sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Matríz Responsable"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
				sheet.add_row [""]
				sheet.add_row [""]
				ticket[0].each do |responsable|
					sheet.add_row ["#{responsable["mes"]}", "#{responsable["cantidad"]}"]
				end
			end
			workbook.add_worksheet(name: "Matríz todos") do |sheet|
                sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Matríz Responsable"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
				sheet.add_row [""]
				sheet.add_row [""]
				sheet.add_row ["Conductor", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio"], :b => true, :font_name => 'Arial', :border => { :style => :thin, :color => "00" }
				responsables.each do |resp|
					sheet.add_row ["#{responsable}","#{agosto}","#{septiembre}","#{octubre}","#{noviembre}","#{diciembre}","#{enero}","#{febrero}","#{marzo}","#{abril}","#{mayo}","#{junio}","#{julio}"]
				end
			end
		end
        send_data package.to_stream.read, type: "application/xlsx", filename: "responsables.xlsx"
	end

	def excel_2_incidentes()
		ticket = InsuranceReportTicket.consulta_responsable(session["tck_resp_nec"],session["tck_resp_ced"],session["tck_resp_com"],session["tck_resp_fini"],session["tck_resp_ffin"],session["tck_resp_res"],session["tck_resp_sin"] )
	end

	def excel_3_incidentes()
		responsables = ResponsibleReportResponsible.responsables_matriz(session["tck_resp_fini"],session["tck_resp_ffin"],session["tck_resp_ced"],session["tck_resp_sin"])
	end

	private

    	def validacion_menu
			session["menu1"] = "Siniestralidad"
			session["menu2"] = "Reporte de incidencias por responsable de siniestro"
		end
end
