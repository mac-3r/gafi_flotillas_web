class DamagedVehicleIndicatorsController < ApplicationController
	before_action :validacion_menu
	authorize_resource :class => false
	def index
	end

	def filtrado_indicadores_daniado
		@bandera_error = false
		# if params[:catalog_company_id].nil? or params[:catalog_company_id] == ""
		# 	@bandera_error = true
		# 	@mensaje = "Selecciona la empresa."
		# else
		 	session["area_dvi"] = params[:area_id]
			session["vehiculo_dvi"] = params[:vehicle_id]
			session["empresa_dvi"] = params[:catalog_company_id]
		# end
		#if params[:catalog_branch_id].nil? or params[:catalog_branch_id] == ""
		#	@bandera_error = true
		#	@mensaje = "Selecciona el cedis."
		#else
			session["cedis_dvi"] = params[:catalog_branch_id]
		#end
		if (params[:start_date].nil? or params[:start_date] == "") and (params[:end_date].nil? or params[:end_date] == "")
			@bandera_error = true
			@mensaje = "Selecciona las fechas correctamente."
		else
			session["fechaini_dvi"] = params[:start_date]
			session["fechafin_dvi"] = params[:end_date]
		end
		if !@bandera_error
			@grafica = DamagedVehicle.grafica_indicadores_daniados(session["empresa_dvi"], session["cedis_dvi"], session["fechaini_dvi"], session["fechafin_dvi"], session["area_dvi"], session["vehiculo_dvi"])
			@tabla2 = DamagedVehicleResponsible.tabla_indicadores_daniados(session["empresa_dvi"], session["cedis_dvi"], session["fechaini_dvi"], session["fechafin_dvi"], session["area_dvi"], session["vehiculo_dvi"])
			#byebug
			arreglo = []
			@tabla = []
	
			@tabla2.each do |tab|
				hash_ren = {}
				hash_ren = Vehicle.joins(:catalog_branch).where(catalog_branches:{decripcion: tab.sucursal}).count
				calculo = tab.total * 100 / hash_ren
				arreglo << hash_ren
				#byebug
				@tabla.push({sucursal: tab.sucursal,cantidad: tab.cantidad,total:tab.total,vehiculos:hash_ren,total_v:calculo})
			end

			if @grafica[0].length == 0 
				@mensaje = "No se encontró información en la empresa y/o cedis seleccionado(s)."
				@bandera_error = true
			end
			#byebug
		end
		respond_to do |format|
			format.js
		end
	end

	def indicadores_daniado_excel
		require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		tabla = DamagedVehicleResponsible.tabla_indicadores_daniados(session["empresa_dvi"], session["cedis_dvi"], session["fechaini_dvi"], session["fechafin_dvi"], session["area_dvi"], session["vehiculo_dvi"])
		workbook.styles do |s|
			miles_decimal = s.add_style(:format_code => "$###,###.00")
			workbook.add_worksheet(name: "Flotilla siniestrada") do |sheet|
                sheet.add_row [""]
				sheet.add_row ["Indicador flotilla siniestrada"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
                sheet.add_row [""]
                sheet.add_row [""]
				sheet.add_row ["No. económico", "Chofer", "Total siniestros", "Fecha siniestro"]
				tabla.each do |resp|
					sheet.add_row [resp.num_economico, resp.responsable, resp.total_siniestros, resp.fecha]
				end
			end

		end
        send_data package.to_stream.read, type: "application/xlsx", filename: "Indicador flotilla siniestrada.xlsx"
	end

	private
		def validacion_menu
			session["menu1"] = "Siniestralidad"
			session["menu2"] = "Indicador flotilla siniestrada"
		end
end
