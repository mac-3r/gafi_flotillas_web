class DamagedPercentageIndicatorsController < ApplicationController
	authorize_resource :class => false
	before_action :validacion_menu
	def index
	end

	def filtrado_indicadores_porcentaje
		@bandera_error = false
		# if params[:catalog_company_id].nil? or params[:catalog_company_id] == ""
		# 	@bandera_error = true
		# 	@mensaje = "Selecciona la empresa."
		# else
		 	session["area_dvp"] = params[:area_id]
			session["vehiculo_dvp"] = params[:vehicle_id]
		 	session["empresa_dvp"] = params[:catalog_company_id]
		# end
		session["cedis_dvp"] = params[:catalog_branch_id]
		session["tipo_dvp"] = params[:tipo]
		if (params[:start_date].nil? or params[:start_date] == "") and (params[:anio].nil? or params[:anio] == "")
			@bandera_error = true
			@mensaje = "Selecciona las fechas correctamente."
		else
			session["fechaini_dvp"] = params[:start_date]
			session["fechaanio_dvp"] = params[:anio]
		end
		if !@bandera_error
			@grafica = DamagedPercentage.grafica_porcentaje(session["empresa_dvp"], session["cedis_dvp"], session["fechaini_dvp"], session["fechaanio_dvp"], session["tipo_dvp"], session["area_dvp"], session["vehiculo_dvp"])
			@tabla2 = TableDamagedIndicator.tabla(session["empresa_dvp"], session["cedis_dvp"], session["fechaini_dvp"], session["fechaanio_dvp"], session["tipo_dvp"], session["area_dvp"], session["vehiculo_dvp"])
			@tabla = []
			@tabla2.each do |tab|
				@tabla.push({sucursal:tab["sucursal"],total_siniestros:tab["total_siniestros"],total_v:tab["calculo"]})
			end
			if !@grafica or @grafica.length == 0 
				@mensaje = "No se encontró información en la empresa y/o cedis seleccionado(s)."
				@bandera_error = true
			end
		end
		respond_to do |format|
			format.js
		end
	end

	def indicadores_porcentaje_excel
		require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		tabla = TableDamagedIndicator.tabla(session["empresa_dvp"], session["cedis_dvp"], session["fechaini_dvp"], session["fechaanio_dvp"], session["tipo_dvp"], session["area_dvp"], session["vehiculo_dvp"])
		workbook.styles do |s|
			miles_decimal = s.add_style(:format_code => "$###,###.00")
			workbook.add_worksheet(name: "Porc. Flotilla siniestrada") do |sheet|
                sheet.add_row [""]
				sheet.add_row ["Indicador porcentaje siniestralidad"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
                sheet.add_row [""]
                sheet.add_row [""]
				sheet.add_row ["Cedis", "No. siniestros", "Cant. responsabilidad si", "Cant. responsabilidad no", "Total siniestros"]
				tabla.each do |resp|
					sheet.add_row [resp["sucursal"], resp["num_siniestros"], resp["resp_si"], resp["resp_no"], resp["total_siniestros"]], :style => [nil,nil,nil,nil,miles_decimal]
				end
			end

		end
        send_data package.to_stream.read, type: "application/xlsx", filename: "Porcentaje flotilla siniestrada.xlsx"
	end

	private
		def validacion_menu
			session["menu1"] = "Siniestralidad"
			session["menu2"] = "Indicador porcentaje siniestralidad"
		end
end
