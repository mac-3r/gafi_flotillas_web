class DamagedVehicleAmmountIndicatorsController < ApplicationController
	before_action :validacion_menu
	authorize_resource :class => false
	def index
	end

	def filtrado_indicadores_monto
		@bandera_error = false
		# if params[:catalog_company_id].nil? or params[:catalog_company_id] == ""
		# 	@bandera_error = true
		# 	@mensaje = "Selecciona la empresa."
		# else
		 	session["area_dva"] = params[:area_id]
			session["vehiculo_dva"] = params[:vehicle_id]
			session["empresa_dva"] = params[:catalog_company_id]
		# end
		#if params[:catalog_branch_id].nil? or params[:catalog_branch_id] == ""
		#	@bandera_error = true
		#	@mensaje = "Selecciona el cedis."
		#else
			session["cedis_dva"] = params[:catalog_branch_id]
		#end
		if (params[:start_date].nil? or params[:start_date] == "") and (params[:end_date].nil? or params[:end_date] == "")
			@bandera_error = true
			@mensaje = "Selecciona las fechas correctamente."
		else
			session["fechaini_dva"] = params[:start_date]
			session["fechafin_dva"] = params[:end_date]
		end
		if !@bandera_error
			#@grafica = DamagedVehicle.grafica_indicadores_monto(session["empresa_dva"], session["cedis_dva"], session["fechaini_dva"], session["fechafin_dva"])
			@grafica = DamagedVehicleAmmount.grafica_indicadores_monto(session["empresa_dva"], session["cedis_dva"], session["fechaini_dva"], session["fechafin_dva"], session["area_dva"], session["vehiculo_dva"])
			@tabla = DamagedVehicleResponsible.tabla_indicadores_monto(session["empresa_dva"], session["cedis_dva"], session["fechaini_dva"], session["fechafin_dva"], session["area_dva"], session["vehiculo_dva"])
			if @grafica.length == 0 
				@mensaje = "No se encontró información en la empresa y/o cedis seleccionado(s)."
				@bandera_error = true
			end
			#byebug
		end
		respond_to do |format|
			format.js
		end
	end

	def indicadores_monto_excel
		require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		tabla = DamagedVehicleResponsible.tabla_indicadores_monto(session["empresa_dva"], session["cedis_dva"], session["fechaini_dva"], session["fechafin_dva"], session["area_dva"], session["vehiculo_dva"])
		workbook.styles do |s|
			miles_decimal = s.add_style(:format_code => "$###,###.00")
			workbook.add_worksheet(name: "Flotilla siniestrada") do |sheet|
                sheet.add_row [""]
				sheet.add_row ["Indicador monto flotilla siniestrada"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
                sheet.add_row [""]
                sheet.add_row [""]
				sheet.add_row ["No. económico", "Chofer", "Total siniestros", "Fecha siniestro", "Monto siniestro"]
				tabla.each do |resp|
					sheet.add_row [resp.num_economico, resp.responsable, resp.total_siniestros, resp.fecha, resp.monto_sin], :style => [nil,nil,nil,nil,miles_decimal]
				end
			end

		end
        send_data package.to_stream.read, type: "application/xlsx", filename: "Monto flotilla siniestrada.xlsx"
	end

	private
		def validacion_menu
			session["menu1"] = "Siniestralidad"
			session["menu2"] = "Indicador monto flotilla siniestrada"
		end
end
