class ClaimReportController < ApplicationController
	before_action :validacion_menu
	authorize_resource :class => false
	def index
		session["anio_informe_sin"] = ""
	end

	def filtro_informe_sin
		session["anio_informe_sin"] = params[:anio]
		session["sucursal_sin"] = params[:catalog_branch_id]
		session["empresa_sin"] = params[:catalog_company_id]
		session["area_sin"] = params[:area_id]
		session["vehiculo_sin"] = params[:vehicle_id]
		@consulta = InsuranceReportTicket.consulta_informe_sin(params[:anio], params[:anio].to_i + 1, session["sucursal_sin"], session["empresa_sin"], session["area_sin"], session["vehiculo_sin"])
		@ciclo = AnnualAmountsPaid.find_by(anio_inicio: params[:anio], anio_fin: params[:anio].to_i + 1)
		#byebug
		respond_to do |format|
			format.js
		end
	end

	def filtro_informe_sin_comparativo
		session["anio_informe_sin_com"] = params[:anio]
		session["sucursal_sin_com"] = params[:catalog_branch_id]
		session["empresa_sin_com"] = params[:catalog_company_id]
		session["area_sin_com"] = params[:area_id]
		session["vehiculo_sin_com"] = params[:vehicle_id]
		@consulta = InsuranceReportTicket.consulta_informe_sin(params[:anio], params[:anio].to_i + 1, session["sucursal_sin_com"], session["empresa_sin_com"], session["area_sin_com"], session["vehiculo_sin_com"])
		@ciclo = AnnualAmountsPaid.find_by(anio_inicio: params[:anio], anio_fin: params[:anio].to_i + 1)
		respond_to do |format|
			format.js
		end
	end

	def excel_informe_sin
		require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		consulta = InsuranceReportTicket.consulta_informe_sin(session["anio_informe_sin"], session["anio_informe_sin"].to_i + 1, session["sucursal_sin"], session["empresa_sin"], session["area_sin"], session["vehiculo_sin"])
		ciclo = AnnualAmountsPaid.find_by(anio_inicio: session["anio_informe_sin"], anio_fin: session["anio_informe_sin"].to_i + 1)
		workbook.styles do |s|
			miles_decimal = s.add_style(:format_code => "$###,###.00")
			titulo1 = s.add_style(:height => 15, :sz => 15, :font_name => 'Arial', :alignment => { :horizontal => :center, :vertical => :center, :wrap_text => true})
			titulo2 = s.add_style(:height => 12, :sz => 12, :font_name => 'Arial', :alignment => { :horizontal => :center, :vertical => :center, :wrap_text => true})
			workbook.add_worksheet(name: "Informe") do |sheet|
                sheet.add_row [""]
				sheet.add_row ["Informe de Siniestralidad"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
				if ciclo
					sheet.add_row ["Año inicio: #{ciclo.anio_inicio}"]
					sheet.add_row ["Año fin: #{ciclo.anio_fin}"]
					fecha_uno = "#{session["anio_informe_sin"]}-11-01".to_date
					prima_octubre = ciclo.cantidad/365*17
					prima_noviembre = ciclo.cantidad/365*(fecha_uno.end_of_month.day.to_i)
					prima_diciembre = ciclo.cantidad/365*((fecha_uno + 1.month).end_of_month.day.to_i)
					prima_enero = ciclo.cantidad/365*((fecha_uno + 2.month).end_of_month.day.to_i)
					prima_febrero = ciclo.cantidad/365*((fecha_uno + 3.month).end_of_month.day.to_i)
					prima_marzo = ciclo.cantidad/365*((fecha_uno + 4.month).end_of_month.day.to_i)
					prima_abril = ciclo.cantidad/365*((fecha_uno + 5.month).end_of_month.day.to_i)
					prima_mayo = ciclo.cantidad/365*((fecha_uno + 6.month).end_of_month.day.to_i)
					prima_junio = ciclo.cantidad/365*((fecha_uno + 7.month).end_of_month.day.to_i)
					prima_julio = ciclo.cantidad/365*((fecha_uno + 8.month).end_of_month.day.to_i)
					prima_agosto = ciclo.cantidad/365*((fecha_uno + 9.month).end_of_month.day.to_i)
					prima_septiembre = ciclo.cantidad/365*14
					costo_octubre = 0
					costo_noviembre = 0
					costo_diciembre = 0
					costo_enero = 0
					costo_febrero = 0
					costo_marzo = 0
					costo_abril = 0
					costo_mayo = 0
					costo_junio = 0
					costo_julio = 0
					costo_agosto = 0
					costo_septiembre = 0
					porc_octubre = 0
					porc_noviembre = 0
					porc_diciembre = 0
					porc_enero = 0
					porc_febrero = 0
					porc_marzo = 0
					porc_abril = 0
					porc_mayo = 0
					porc_junio = 0
					porc_julio = 0
					porc_agosto = 0
					porc_septiembre = 0
					sheet.add_row ["Prima anual pagada","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes",""], :style => [titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1]
					sheet.add_row [ciclo.cantidad, prima_octubre, "", prima_noviembre, "", prima_diciembre, "", prima_enero, "", prima_febrero, "", prima_marzo, "", prima_abril, "", prima_mayo, "", prima_junio, "", prima_julio, "", prima_agosto, "", prima_septiembre, ""], :style => [miles_decimal, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil]
					sheet.add_row ["Detalle","Octubre","","Noviembre","","Diciembre","","Enero","","Febrero","","Marzo","","Abril","","Mayo","","Junio","","Julio","","Agosto","","Septiembre",""], :style => [titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1]
					sheet.add_row ["CEDIS", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes"], :style => [titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2]
					consulta[12].each do |cons|
						desc_cedis = cons.decripcion
						mes = consulta[0].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_octubre += mes.costo
                            if (((mes.costo/prima_octubre)*100).round(2)) > 0
                                porc_octubre += (((mes.costo/prima_octubre)*100).round(2))
                            else
                                porc_octubre -= (((mes.costo/prima_octubre)*100).round(2))
							end
							text_cost_oct = mes.costo
							text_porc_oct = "#{((mes.costo/prima_octubre)*100).round(2)}%"
						else
							text_cost_oct = "-"
							text_porc_oct = "-"
						end
						mes = consulta[1].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_noviembre += mes.costo
                            if (((mes.costo/prima_noviembre)*100).round(2)) > 0
                                porc_noviembre += (((mes.costo/prima_noviembre)*100).round(2))
                            else
                                porc_noviembre -= (((mes.costo/prima_noviembre)*100).round(2))
							end
							text_cost_nov = mes.costo
							text_porc_nov = "#{((mes.costo/prima_noviembre)*100).round(2)}%"
						else
							text_cost_nov = ""
							text_porc_nov = ""
						end
						mes = consulta[2].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_diciembre += mes.costo
                            if (((mes.costo/prima_diciembre)*100).round(2)) > 0
                                porc_diciembre += (((mes.costo/prima_diciembre)*100).round(2))
                            else
                                porc_diciembre -= (((mes.costo/prima_diciembre)*100).round(2))
							end
							text_cost_dic = mes.costo
							text_porc_dic = "#{((mes.costo/prima_diciembre)*100).round(2)}%"
						else
							text_cost_dic = ""
							text_porc_dic = ""
						end
						mes = consulta[3].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_enero += mes.costo
                            if (((mes.costo/prima_enero)*100).round(2)) > 0
                                porc_enero += (((mes.costo/prima_enero)*100).round(2))
                            else
                                porc_enero -= (((mes.costo/prima_enero)*100).round(2))
							end
							text_cost_ene = mes.costo
							text_porc_ene = "#{((mes.costo/prima_enero)*100).round(2)}%"
						else
							text_cost_ene = ""
							text_porc_ene = ""
						end
						mes = consulta[4].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_febrero += mes.costo
                            if (((mes.costo/prima_febrero)*100).round(2)) > 0
                                porc_febrero += (((mes.costo/prima_febrero)*100).round(2))
                            else
                                porc_febrero -= (((mes.costo/prima_febrero)*100).round(2))
							end
							text_cost_feb = mes.costo
							text_porc_feb = "#{((mes.costo/prima_febrero)*100).round(2)}%"
						else
							text_cost_feb = ""
							text_porc_feb = ""
						end
						mes = consulta[5].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_marzo += mes.costo
                            if (((mes.costo/prima_marzo)*100).round(2)) > 0
                                porc_marzo += (((mes.costo/prima_marzo)*100).round(2))
                            else
                                porc_marzo -= (((mes.costo/prima_marzo)*100).round(2))
							end
							text_cost_mar = mes.costo
							text_porc_mar = "#{((mes.costo/prima_marzo)*100).round(2)}%"
						else
							text_cost_mar = ""
							text_porc_mar = ""
						end
						mes = consulta[6].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_abril += mes.costo
                            if (((mes.costo/prima_abril)*100).round(2)) > 0
                                porc_abril += (((mes.costo/prima_abril)*100).round(2))
                            else
                                porc_abril -= (((mes.costo/prima_abril)*100).round(2))
							end
							text_cost_abr = mes.costo
							text_porc_abr = "#{((mes.costo/prima_abril)*100).round(2)}%"
						else
							text_cost_abr = ""
							text_porc_abr = ""
						end
						mes = consulta[7].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_mayo += mes.costo
                            if (((mes.costo/prima_mayo)*100).round(2)) > 0
                                porc_mayo += (((mes.costo/prima_mayo)*100).round(2))
                            else
                                porc_mayo -= (((mes.costo/prima_mayo)*100).round(2))
							end
							text_cost_may = mes.costo
							text_porc_may = "#{((mes.costo/prima_mayo)*100).round(2)}%"
						else
							text_cost_may = ""
							text_porc_may = ""
						end
						mes = consulta[8].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_junio += mes.costo
                            if (((mes.costo/prima_junio)*100).round(2)) > 0
                                porc_junio += (((mes.costo/prima_junio)*100).round(2))
                            else
                                porc_junio -= (((mes.costo/prima_junio)*100).round(2))
							end
							text_cost_jun = mes.costo
							text_porc_jun = "#{((mes.costo/prima_junio)*100).round(2)}%"
						else
							text_cost_jun = ""
							text_porc_jun = ""
						end
						mes = consulta[9].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_julio += mes.costo
                            if (((mes.costo/prima_julio)*100).round(2)) > 0
                                porc_julio += (((mes.costo/prima_julio)*100).round(2))
                            else
                                porc_julio -= (((mes.costo/prima_julio)*100).round(2))
							end
							text_cost_jul = mes.costo
							text_porc_jul = "#{((mes.costo/prima_julio)*100).round(2)}%"
						else
							text_cost_jul = ""
							text_porc_jul = ""
						end
						mes = consulta[10].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_agosto += mes.costo
                            if (((mes.costo/prima_agosto)*100).round(2)) > 0
                                porc_agosto += (((mes.costo/prima_agosto)*100).round(2))
                            else
                                porc_agosto -= (((mes.costo/prima_agosto)*100).round(2))
							end
							text_cost_ago = mes.costo
							text_porc_ago = "#{((mes.costo/prima_agosto)*100).round(2)}%"
						else
							text_cost_ago = ""
							text_porc_ago = ""
						end
						mes = consulta[11].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_septiembre += mes.costo
                            if (((mes.costo/prima_septiembre)*100).round(2)) > 0
                                porc_septiembre += (((mes.costo/prima_septiembre)*100).round(2))
                            else
                                porc_septiembre -= (((mes.costo/prima_septiembre)*100).round(2))
							end
							text_cost_sep = mes.costo
							text_porc_sep = "#{((mes.costo/prima_septiembre)*100).round(2)}%"
						else
							text_cost_sep = ""
							text_porc_sep = ""
						end
						sheet.add_row [desc_cedis, text_cost_oct, text_porc_oct, text_cost_nov, text_porc_nov, text_cost_dic, text_porc_dic, text_cost_ene, text_porc_ene, text_cost_feb, text_porc_feb, text_cost_mar, text_porc_mar, text_cost_abr, text_porc_abr, text_cost_may, text_porc_may, text_cost_jun, text_porc_jun, text_cost_jul, text_porc_jul, text_cost_ago, text_porc_ago, text_cost_sep, text_porc_sep]
					end
					sheet.add_row [""]
					sheet.add_row ["Total Gafi", costo_octubre, "#{porc_octubre}%", costo_noviembre, "#{porc_noviembre}%", costo_diciembre, "#{porc_diciembre}%", costo_enero, "#{porc_enero}%", costo_febrero, "#{porc_febrero}%", costo_marzo, "#{porc_marzo}%", costo_abril, "#{porc_abril}%", costo_mayo, "#{porc_mayo}%", costo_junio, "#{porc_junio}%", costo_julio, "#{porc_julio}%", costo_agosto, "#{porc_agosto}%", costo_septiembre, "#{porc_septiembre}%"]
					sheet.merge_cells "B4:C4"
					sheet.merge_cells "D4:E4"
					sheet.merge_cells "F4:G4"
					sheet.merge_cells "H4:I4"
					sheet.merge_cells "J4:K4"
					sheet.merge_cells "L4:M4"
					sheet.merge_cells "N4:O4"
					sheet.merge_cells "P4:Q4"
					sheet.merge_cells "R4:S4"
					sheet.merge_cells "T4:U4"
					sheet.merge_cells "V4:W4"
					sheet.merge_cells "X4:Y4"
					sheet.merge_cells "B6:C6"
					sheet.merge_cells "D6:E6"
					sheet.merge_cells "F6:G6"
					sheet.merge_cells "H6:I6"
					sheet.merge_cells "J6:K6"
					sheet.merge_cells "L6:M6"
					sheet.merge_cells "N6:O6"
					sheet.merge_cells "P6:Q6"
					sheet.merge_cells "R6:S6"
					sheet.merge_cells "T6:U6"
					sheet.merge_cells "V6:W6"
					sheet.merge_cells "X6:Y6"
				end
			end
		end
        send_data package.to_stream.read, type: "application/xlsx", filename: "Informe siniestralidad.xlsx"
	end

	def excel_informe_sin_com
		require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		consulta = InsuranceReportTicket.consulta_informe_sin(session["anio_informe_sin"], session["anio_informe_sin"].to_i + 1, session["sucursal_sin"], session["empresa_sin"], session["area_sin"], session["vehiculo_sin"])
		ciclo = AnnualAmountsPaid.find_by(anio_inicio: session["anio_informe_sin"], anio_fin: session["anio_informe_sin"].to_i + 1)
		consulta2 = InsuranceReportTicket.consulta_informe_sin(session["anio_informe_sin_com"], session["anio_informe_sin_com"].to_i + 1, session["sucursal_sin_com"], session["empresa_sin_com"], session["area_sin_com"], session["vehiculo_sin_com"])
		ciclo2 = AnnualAmountsPaid.find_by(anio_inicio: session["anio_informe_sin_com"], anio_fin: session["anio_informe_sin_com"].to_i + 1)
		workbook.styles do |s|
			miles_decimal = s.add_style(:format_code => "$###,###.00")
			titulo1 = s.add_style(:height => 15, :sz => 15, :font_name => 'Arial', :alignment => { :horizontal => :center, :vertical => :center, :wrap_text => true})
			titulo2 = s.add_style(:height => 12, :sz => 12, :font_name => 'Arial', :alignment => { :horizontal => :center, :vertical => :center, :wrap_text => true})
			workbook.add_worksheet(name: "Informe") do |sheet|
                sheet.add_row [""]
				sheet.add_row ["Informe de Siniestralidad"],:height => 20, :b => true, :sz => 20, :font_name => 'Arial'
				if ciclo
					sheet.add_row ["Año inicio: #{ciclo.anio_inicio}"]
					sheet.add_row ["Año fin: #{ciclo.anio_fin}"]
					fecha_uno = "#{session["anio_informe_sin"]}-11-01".to_date
					prima_octubre = ciclo.cantidad/365*17
					prima_noviembre = ciclo.cantidad/365*(fecha_uno.end_of_month.day.to_i)
					prima_diciembre = ciclo.cantidad/365*((fecha_uno + 1.month).end_of_month.day.to_i)
					prima_enero = ciclo.cantidad/365*((fecha_uno + 2.month).end_of_month.day.to_i)
					prima_febrero = ciclo.cantidad/365*((fecha_uno + 3.month).end_of_month.day.to_i)
					prima_marzo = ciclo.cantidad/365*((fecha_uno + 4.month).end_of_month.day.to_i)
					prima_abril = ciclo.cantidad/365*((fecha_uno + 5.month).end_of_month.day.to_i)
					prima_mayo = ciclo.cantidad/365*((fecha_uno + 6.month).end_of_month.day.to_i)
					prima_junio = ciclo.cantidad/365*((fecha_uno + 7.month).end_of_month.day.to_i)
					prima_julio = ciclo.cantidad/365*((fecha_uno + 8.month).end_of_month.day.to_i)
					prima_agosto = ciclo.cantidad/365*((fecha_uno + 9.month).end_of_month.day.to_i)
					prima_septiembre = ciclo.cantidad/365*14
					costo_octubre = 0
					costo_noviembre = 0
					costo_diciembre = 0
					costo_enero = 0
					costo_febrero = 0
					costo_marzo = 0
					costo_abril = 0
					costo_mayo = 0
					costo_junio = 0
					costo_julio = 0
					costo_agosto = 0
					costo_septiembre = 0
					porc_octubre = 0
					porc_noviembre = 0
					porc_diciembre = 0
					porc_enero = 0
					porc_febrero = 0
					porc_marzo = 0
					porc_abril = 0
					porc_mayo = 0
					porc_junio = 0
					porc_julio = 0
					porc_agosto = 0
					porc_septiembre = 0
					sheet.add_row ["Prima anual pagada","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes",""], :style => [titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1]
					sheet.add_row [ciclo.cantidad, prima_octubre, "", prima_noviembre, "", prima_diciembre, "", prima_enero, "", prima_febrero, "", prima_marzo, "", prima_abril, "", prima_mayo, "", prima_junio, "", prima_julio, "", prima_agosto, "", prima_septiembre, ""], :style => [miles_decimal, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil]
					sheet.add_row ["Detalle","Octubre","","Noviembre","","Diciembre","","Enero","","Febrero","","Marzo","","Abril","","Mayo","","Junio","","Julio","","Agosto","","Septiembre",""], :style => [titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1]
					sheet.add_row ["CEDIS", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes"], :style => [titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2]
					consulta[12].each do |cons|
						desc_cedis = cons.decripcion
						mes = consulta[0].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_octubre += mes.costo
                            if (((mes.costo/prima_octubre)*100).round(2)) > 0
                                porc_octubre += (((mes.costo/prima_octubre)*100).round(2))
                            else
                                porc_octubre -= (((mes.costo/prima_octubre)*100).round(2))
							end
							text_cost_oct = mes.costo
							text_porc_oct = "#{((mes.costo/prima_octubre)*100).round(2)}%"
						else
							text_cost_oct = "-"
							text_porc_oct = "-"
						end
						mes = consulta[1].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_noviembre += mes.costo
                            if (((mes.costo/prima_noviembre)*100).round(2)) > 0
                                porc_noviembre += (((mes.costo/prima_noviembre)*100).round(2))
                            else
                                porc_noviembre -= (((mes.costo/prima_noviembre)*100).round(2))
							end
							text_cost_nov = mes.costo
							text_porc_nov = "#{((mes.costo/prima_noviembre)*100).round(2)}%"
						else
							text_cost_nov = ""
							text_porc_nov = ""
						end
						mes = consulta[2].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_diciembre += mes.costo
                            if (((mes.costo/prima_diciembre)*100).round(2)) > 0
                                porc_diciembre += (((mes.costo/prima_diciembre)*100).round(2))
                            else
                                porc_diciembre -= (((mes.costo/prima_diciembre)*100).round(2))
							end
							text_cost_dic = mes.costo
							text_porc_dic = "#{((mes.costo/prima_diciembre)*100).round(2)}%"
						else
							text_cost_dic = ""
							text_porc_dic = ""
						end
						mes = consulta[3].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_enero += mes.costo
                            if (((mes.costo/prima_enero)*100).round(2)) > 0
                                porc_enero += (((mes.costo/prima_enero)*100).round(2))
                            else
                                porc_enero -= (((mes.costo/prima_enero)*100).round(2))
							end
							text_cost_ene = mes.costo
							text_porc_ene = "#{((mes.costo/prima_enero)*100).round(2)}%"
						else
							text_cost_ene = ""
							text_porc_ene = ""
						end
						mes = consulta[4].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_febrero += mes.costo
                            if (((mes.costo/prima_febrero)*100).round(2)) > 0
                                porc_febrero += (((mes.costo/prima_febrero)*100).round(2))
                            else
                                porc_febrero -= (((mes.costo/prima_febrero)*100).round(2))
							end
							text_cost_feb = mes.costo
							text_porc_feb = "#{((mes.costo/prima_febrero)*100).round(2)}%"
						else
							text_cost_feb = ""
							text_porc_feb = ""
						end
						mes = consulta[5].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_marzo += mes.costo
                            if (((mes.costo/prima_marzo)*100).round(2)) > 0
                                porc_marzo += (((mes.costo/prima_marzo)*100).round(2))
                            else
                                porc_marzo -= (((mes.costo/prima_marzo)*100).round(2))
							end
							text_cost_mar = mes.costo
							text_porc_mar = "#{((mes.costo/prima_marzo)*100).round(2)}%"
						else
							text_cost_mar = ""
							text_porc_mar = ""
						end
						mes = consulta[6].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_abril += mes.costo
                            if (((mes.costo/prima_abril)*100).round(2)) > 0
                                porc_abril += (((mes.costo/prima_abril)*100).round(2))
                            else
                                porc_abril -= (((mes.costo/prima_abril)*100).round(2))
							end
							text_cost_abr = mes.costo
							text_porc_abr = "#{((mes.costo/prima_abril)*100).round(2)}%"
						else
							text_cost_abr = ""
							text_porc_abr = ""
						end
						mes = consulta[7].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_mayo += mes.costo
                            if (((mes.costo/prima_mayo)*100).round(2)) > 0
                                porc_mayo += (((mes.costo/prima_mayo)*100).round(2))
                            else
                                porc_mayo -= (((mes.costo/prima_mayo)*100).round(2))
							end
							text_cost_may = mes.costo
							text_porc_may = "#{((mes.costo/prima_mayo)*100).round(2)}%"
						else
							text_cost_may = ""
							text_porc_may = ""
						end
						mes = consulta[8].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_junio += mes.costo
                            if (((mes.costo/prima_junio)*100).round(2)) > 0
                                porc_junio += (((mes.costo/prima_junio)*100).round(2))
                            else
                                porc_junio -= (((mes.costo/prima_junio)*100).round(2))
							end
							text_cost_jun = mes.costo
							text_porc_jun = "#{((mes.costo/prima_junio)*100).round(2)}%"
						else
							text_cost_jun = ""
							text_porc_jun = ""
						end
						mes = consulta[9].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_julio += mes.costo
                            if (((mes.costo/prima_julio)*100).round(2)) > 0
                                porc_julio += (((mes.costo/prima_julio)*100).round(2))
                            else
                                porc_julio -= (((mes.costo/prima_julio)*100).round(2))
							end
							text_cost_jul = mes.costo
							text_porc_jul = "#{((mes.costo/prima_julio)*100).round(2)}%"
						else
							text_cost_jul = ""
							text_porc_jul = ""
						end
						mes = consulta[10].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_agosto += mes.costo
                            if (((mes.costo/prima_agosto)*100).round(2)) > 0
                                porc_agosto += (((mes.costo/prima_agosto)*100).round(2))
                            else
                                porc_agosto -= (((mes.costo/prima_agosto)*100).round(2))
							end
							text_cost_ago = mes.costo
							text_porc_ago = "#{((mes.costo/prima_agosto)*100).round(2)}%"
						else
							text_cost_ago = ""
							text_porc_ago = ""
						end
						mes = consulta[11].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_septiembre += mes.costo
                            if (((mes.costo/prima_septiembre)*100).round(2)) > 0
                                porc_septiembre += (((mes.costo/prima_septiembre)*100).round(2))
                            else
                                porc_septiembre -= (((mes.costo/prima_septiembre)*100).round(2))
							end
							text_cost_sep = mes.costo
							text_porc_sep = "#{((mes.costo/prima_septiembre)*100).round(2)}%"
						else
							text_cost_sep = ""
							text_porc_sep = ""
						end
						sheet.add_row [desc_cedis, text_cost_oct, text_porc_oct, text_cost_nov, text_porc_nov, text_cost_dic, text_porc_dic, text_cost_ene, text_porc_ene, text_cost_feb, text_porc_feb, text_cost_mar, text_porc_mar, text_cost_abr, text_porc_abr, text_cost_may, text_porc_may, text_cost_jun, text_porc_jun, text_cost_jul, text_porc_jul, text_cost_ago, text_porc_ago, text_cost_sep, text_porc_sep]
					end
					sheet.add_row [""]
					sheet.add_row ["Total Gafi", costo_octubre, "#{porc_octubre}%", costo_noviembre, "#{porc_noviembre}%", costo_diciembre, "#{porc_diciembre}%", costo_enero, "#{porc_enero}%", costo_febrero, "#{porc_febrero}%", costo_marzo, "#{porc_marzo}%", costo_abril, "#{porc_abril}%", costo_mayo, "#{porc_mayo}%", costo_junio, "#{porc_junio}%", costo_julio, "#{porc_julio}%", costo_agosto, "#{porc_agosto}%", costo_septiembre, "#{porc_septiembre}%"]
					sheet.merge_cells "B5:C5"
					sheet.merge_cells "D5:E5"
					sheet.merge_cells "F5:G5"
					sheet.merge_cells "H5:I5"
					sheet.merge_cells "J5:K5"
					sheet.merge_cells "L5:M5"
					sheet.merge_cells "N5:O5"
					sheet.merge_cells "P5:Q5"
					sheet.merge_cells "R5:S5"
					sheet.merge_cells "T5:U5"
					sheet.merge_cells "V5:W5"
					sheet.merge_cells "X5:Y5"
					sheet.merge_cells "B7:C7"
					sheet.merge_cells "D7:E7"
					sheet.merge_cells "F7:G7"
					sheet.merge_cells "H7:I7"
					sheet.merge_cells "J7:K7"
					sheet.merge_cells "L7:M7"
					sheet.merge_cells "N7:O7"
					sheet.merge_cells "P7:Q7"
					sheet.merge_cells "R7:S7"
					sheet.merge_cells "T7:U7"
					sheet.merge_cells "V7:W7"
					sheet.merge_cells "X7:Y7"
				end
				sheet.add_row [""]
				sheet.add_row [""]
				if ciclo2
					sheet.add_row ["Año inicio: #{ciclo2.anio_inicio}"]
					sheet.add_row ["Año fin: #{ciclo2.anio_fin}"]
					fecha_uno = "#{session["anio_informe_sin_com"]}-11-01".to_date
					prima_octubre = ciclo2.cantidad/365*17
					prima_noviembre = ciclo2.cantidad/365*(fecha_uno.end_of_month.day.to_i)
					prima_diciembre = ciclo2.cantidad/365*((fecha_uno + 1.month).end_of_month.day.to_i)
					prima_enero = ciclo2.cantidad/365*((fecha_uno + 2.month).end_of_month.day.to_i)
					prima_febrero = ciclo2.cantidad/365*((fecha_uno + 3.month).end_of_month.day.to_i)
					prima_marzo = ciclo2.cantidad/365*((fecha_uno + 4.month).end_of_month.day.to_i)
					prima_abril = ciclo2.cantidad/365*((fecha_uno + 5.month).end_of_month.day.to_i)
					prima_mayo = ciclo2.cantidad/365*((fecha_uno + 6.month).end_of_month.day.to_i)
					prima_junio = ciclo2.cantidad/365*((fecha_uno + 7.month).end_of_month.day.to_i)
					prima_julio = ciclo2.cantidad/365*((fecha_uno + 8.month).end_of_month.day.to_i)
					prima_agosto = ciclo2.cantidad/365*((fecha_uno + 9.month).end_of_month.day.to_i)
					prima_septiembre = ciclo2.cantidad/365*14
					costo_octubre = 0
					costo_noviembre = 0
					costo_diciembre = 0
					costo_enero = 0
					costo_febrero = 0
					costo_marzo = 0
					costo_abril = 0
					costo_mayo = 0
					costo_junio = 0
					costo_julio = 0
					costo_agosto = 0
					costo_septiembre = 0
					porc_octubre = 0
					porc_noviembre = 0
					porc_diciembre = 0
					porc_enero = 0
					porc_febrero = 0
					porc_marzo = 0
					porc_abril = 0
					porc_mayo = 0
					porc_junio = 0
					porc_julio = 0
					porc_agosto = 0
					porc_septiembre = 0
					sheet.add_row ["Prima anual pagada","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes","","Prima Devengada en el mes",""], :style => [titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1]
					sheet.add_row [ciclo2.cantidad, prima_octubre, "", prima_noviembre, "", prima_diciembre, "", prima_enero, "", prima_febrero, "", prima_marzo, "", prima_abril, "", prima_mayo, "", prima_junio, "", prima_julio, "", prima_agosto, "", prima_septiembre, ""], :style => [miles_decimal, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil, miles_decimal, nil]
					sheet.add_row ["Detalle","Octubre","","Noviembre","","Diciembre","","Enero","","Febrero","","Marzo","","Abril","","Mayo","","Junio","","Julio","","Agosto","","Septiembre",""], :style => [titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1, titulo1]
					sheet.add_row ["CEDIS", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes", "Costo", "% Prima devengada del mes"], :style => [titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2, titulo2]
					consulta2[12].each do |cons|
						desc_cedis = cons.decripcion
						mes = consulta2[0].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_octubre += mes.costo
                            if (((mes.costo/prima_octubre)*100).round(2)) > 0
                                porc_octubre += (((mes.costo/prima_octubre)*100).round(2))
                            else
                                porc_octubre -= (((mes.costo/prima_octubre)*100).round(2))
							end
							text_cost_oct = mes.costo
							text_porc_oct = "#{((mes.costo/prima_octubre)*100).round(2)}%"
						else
							text_cost_oct = "-"
							text_porc_oct = "-"
						end
						mes = consulta2[1].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_noviembre += mes.costo
                            if (((mes.costo/prima_noviembre)*100).round(2)) > 0
                                porc_noviembre += (((mes.costo/prima_noviembre)*100).round(2))
                            else
                                porc_noviembre -= (((mes.costo/prima_noviembre)*100).round(2))
							end
							text_cost_nov = mes.costo
							text_porc_nov = "#{((mes.costo/prima_noviembre)*100).round(2)}%"
						else
							text_cost_nov = ""
							text_porc_nov = ""
						end
						mes = consulta2[2].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_diciembre += mes.costo
                            if (((mes.costo/prima_diciembre)*100).round(2)) > 0
                                porc_diciembre += (((mes.costo/prima_diciembre)*100).round(2))
                            else
                                porc_diciembre -= (((mes.costo/prima_diciembre)*100).round(2))
							end
							text_cost_dic = mes.costo
							text_porc_dic = "#{((mes.costo/prima_diciembre)*100).round(2)}%"
						else
							text_cost_dic = ""
							text_porc_dic = ""
						end
						mes = consulta2[3].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_enero += mes.costo
                            if (((mes.costo/prima_enero)*100).round(2)) > 0
                                porc_enero += (((mes.costo/prima_enero)*100).round(2))
                            else
                                porc_enero -= (((mes.costo/prima_enero)*100).round(2))
							end
							text_cost_ene = mes.costo
							text_porc_ene = "#{((mes.costo/prima_enero)*100).round(2)}%"
						else
							text_cost_ene = ""
							text_porc_ene = ""
						end
						mes = consulta2[4].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_febrero += mes.costo
                            if (((mes.costo/prima_febrero)*100).round(2)) > 0
                                porc_febrero += (((mes.costo/prima_febrero)*100).round(2))
                            else
                                porc_febrero -= (((mes.costo/prima_febrero)*100).round(2))
							end
							text_cost_feb = mes.costo
							text_porc_feb = "#{((mes.costo/prima_febrero)*100).round(2)}%"
						else
							text_cost_feb = ""
							text_porc_feb = ""
						end
						mes = consulta2[5].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_marzo += mes.costo
                            if (((mes.costo/prima_marzo)*100).round(2)) > 0
                                porc_marzo += (((mes.costo/prima_marzo)*100).round(2))
                            else
                                porc_marzo -= (((mes.costo/prima_marzo)*100).round(2))
							end
							text_cost_mar = mes.costo
							text_porc_mar = "#{((mes.costo/prima_marzo)*100).round(2)}%"
						else
							text_cost_mar = ""
							text_porc_mar = ""
						end
						mes = consulta2[6].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_abril += mes.costo
                            if (((mes.costo/prima_abril)*100).round(2)) > 0
                                porc_abril += (((mes.costo/prima_abril)*100).round(2))
                            else
                                porc_abril -= (((mes.costo/prima_abril)*100).round(2))
							end
							text_cost_abr = mes.costo
							text_porc_abr = "#{((mes.costo/prima_abril)*100).round(2)}%"
						else
							text_cost_abr = ""
							text_porc_abr = ""
						end
						mes = consulta2[7].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_mayo += mes.costo
                            if (((mes.costo/prima_mayo)*100).round(2)) > 0
                                porc_mayo += (((mes.costo/prima_mayo)*100).round(2))
                            else
                                porc_mayo -= (((mes.costo/prima_mayo)*100).round(2))
							end
							text_cost_may = mes.costo
							text_porc_may = "#{((mes.costo/prima_mayo)*100).round(2)}%"
						else
							text_cost_may = ""
							text_porc_may = ""
						end
						mes = consulta2[8].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_junio += mes.costo
                            if (((mes.costo/prima_junio)*100).round(2)) > 0
                                porc_junio += (((mes.costo/prima_junio)*100).round(2))
                            else
                                porc_junio -= (((mes.costo/prima_junio)*100).round(2))
							end
							text_cost_jun = mes.costo
							text_porc_jun = "#{((mes.costo/prima_junio)*100).round(2)}%"
						else
							text_cost_jun = ""
							text_porc_jun = ""
						end
						mes = consulta2[9].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_julio += mes.costo
                            if (((mes.costo/prima_julio)*100).round(2)) > 0
                                porc_julio += (((mes.costo/prima_julio)*100).round(2))
                            else
                                porc_julio -= (((mes.costo/prima_julio)*100).round(2))
							end
							text_cost_jul = mes.costo
							text_porc_jul = "#{((mes.costo/prima_julio)*100).round(2)}%"
						else
							text_cost_jul = ""
							text_porc_jul = ""
						end
						mes = consulta2[10].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_agosto += mes.costo
                            if (((mes.costo/prima_agosto)*100).round(2)) > 0
                                porc_agosto += (((mes.costo/prima_agosto)*100).round(2))
                            else
                                porc_agosto -= (((mes.costo/prima_agosto)*100).round(2))
							end
							text_cost_ago = mes.costo
							text_porc_ago = "#{((mes.costo/prima_agosto)*100).round(2)}%"
						else
							text_cost_ago = ""
							text_porc_ago = ""
						end
						mes = consulta2[11].find {|item| item.sucursal == cons.decripcion}
                        if mes
                            costo_septiembre += mes.costo
                            if (((mes.costo/prima_septiembre)*100).round(2)) > 0
                                porc_septiembre += (((mes.costo/prima_septiembre)*100).round(2))
                            else
                                porc_septiembre -= (((mes.costo/prima_septiembre)*100).round(2))
							end
							text_cost_sep = mes.costo
							text_porc_sep = "#{((mes.costo/prima_septiembre)*100).round(2)}%"
						else
							text_cost_sep = ""
							text_porc_sep = ""
						end
						sheet.add_row [desc_cedis, text_cost_oct, text_porc_oct, text_cost_nov, text_porc_nov, text_cost_dic, text_porc_dic, text_cost_ene, text_porc_ene, text_cost_feb, text_porc_feb, text_cost_mar, text_porc_mar, text_cost_abr, text_porc_abr, text_cost_may, text_porc_may, text_cost_jun, text_porc_jun, text_cost_jul, text_porc_jul, text_cost_ago, text_porc_ago, text_cost_sep, text_porc_sep]
					end
					sheet.add_row [""]
					sheet.add_row ["Total Gafi", costo_octubre, "#{porc_octubre}%", costo_noviembre, "#{porc_noviembre}%", costo_diciembre, "#{porc_diciembre}%", costo_enero, "#{porc_enero}%", costo_febrero, "#{porc_febrero}%", costo_marzo, "#{porc_marzo}%", costo_abril, "#{porc_abril}%", costo_mayo, "#{porc_mayo}%", costo_junio, "#{porc_junio}%", costo_julio, "#{porc_julio}%", costo_agosto, "#{porc_agosto}%", costo_septiembre, "#{porc_septiembre}%"]
					union1 = consulta[12].length.to_i + 15
					union2 = consulta[12].length.to_i + 17
					sheet.merge_cells "B#{union1}:C#{union1}"
					sheet.merge_cells "D#{union1}:E#{union1}"
					sheet.merge_cells "F#{union1}:G#{union1}"
					sheet.merge_cells "H#{union1}:I#{union1}"
					sheet.merge_cells "J#{union1}:K#{union1}"
					sheet.merge_cells "L#{union1}:M#{union1}"
					sheet.merge_cells "N#{union1}:O#{union1}"
					sheet.merge_cells "P#{union1}:Q#{union1}"
					sheet.merge_cells "R#{union1}:S#{union1}"
					sheet.merge_cells "T#{union1}:U#{union1}"
					sheet.merge_cells "V#{union1}:W#{union1}"
					sheet.merge_cells "X#{union1}:Y#{union1}"
					sheet.merge_cells "B#{union2}:C#{union2}"
					sheet.merge_cells "D#{union2}:E#{union2}"
					sheet.merge_cells "F#{union2}:G#{union2}"
					sheet.merge_cells "H#{union2}:I#{union2}"
					sheet.merge_cells "J#{union2}:K#{union2}"
					sheet.merge_cells "L#{union2}:M#{union2}"
					sheet.merge_cells "N#{union2}:O#{union2}"
					sheet.merge_cells "P#{union2}:Q#{union2}"
					sheet.merge_cells "R#{union2}:S#{union2}"
					sheet.merge_cells "T#{union2}:U#{union2}"
					sheet.merge_cells "V#{union2}:W#{union2}"
					sheet.merge_cells "X#{union2}:Y#{union2}"
				end
			end
		end
        send_data package.to_stream.read, type: "application/xlsx", filename: "Informe siniestralidad.xlsx"
	end
	
	def abrir_modal_comparativo_informe
		respond_to do |format|
			format.js
		end
	end

	def abrir_modal_prima
		if session["anio_informe_sin"] == "" or session["anio_informe_sin"].to_i < 2019 or session["anio_informe_sin"].to_i > (Time.zone.now + 2.years).year
			@bandera_error = true
		else
			@bandera_error = false
			@anio = session["anio_informe_sin"].to_i
			@ciclo = AnnualAmountsPaid.find_by(anio_inicio: @anio, anio_fin: @anio + 1)
			if !@ciclo
				@ciclo = AnnualAmountsPaid.new
			end
		end
		respond_to do |format|
			format.js
		end
	end

	def registrar_prima_inf
		ciclo = AnnualAmountsPaid.find_by(anio_inicio: session["anio_informe_sin"].to_i, anio_fin: session["anio_informe_sin"].to_i + 1)
		if ciclo
			if ciclo.update(cantidad: params[:annual_amounts_paid][:cantidad])
				@bandera_error = false
				@mensaje = "Prima anual capturada correctamente."
				@ciclo = AnnualAmountsPaid.find_by(anio_inicio: session["anio_informe_sin"].to_i, anio_fin: session["anio_informe_sin"].to_i + 1)
				@consulta = InsuranceReportTicket.consulta_informe_sin(params[:anio], params[:anio].to_i + 1, session["sucursal_sin_com"], session["empresa_sin"])
			else
				@mensaje = ""
				ciclo.errors.full_messages.each do |error|
					@mensaje += "#{error}. "
				end
				@bandera_error = true
			end
		else
			guardar_ciclo = AnnualAmountsPaid.create(anio_inicio: session["anio_informe_sin"].to_i, anio_fin: session["anio_informe_sin"].to_i + 1, cantidad: params[:annual_amounts_paid][:cantidad])
			if guardar_ciclo.save
				@bandera_error = false
				@mensaje = "Prima anual capturada correctamente."
				@ciclo = AnnualAmountsPaid.find_by(anio_inicio: session["anio_informe_sin"].to_i, anio_fin: session["anio_informe_sin"].to_i + 1)
				@consulta = InsuranceReportTicket.consulta_informe_sin(params[:anio], params[:anio].to_i + 1, session["sucursal_sin_com"], session["empresa_sin"])
			else
				@mensaje = ""
				guardar_ciclo.errors.full_messages.each do |error|
					@mensaje += "#{error}. "
				end
				@bandera_error = true
			end
		end
		respond_to do |format|
			format.js
		end
	end

	private
		def validacion_menu
			session["menu1"] = "Siniestralidad"
			session["menu2"] = "Informe de siniestralidad"
	  	end
end
