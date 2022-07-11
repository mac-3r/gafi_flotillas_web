class InsuranceReportTicket < ApplicationRecord
    belongs_to :vehicle
	#belongs_to :type_sinister
	enum estatus: {"Cancelado": 0,"Abierto": 1, "Cerrado": 2, "En Captura": 3}
	enum coincide: {"Falso": 0, "Verdadero": 1}
	enum registro: {"Aseguradora": 1, "Administrador": 2}
	#enum estatus_responsabilidad_gafi: {"Responsable": 1, "Afectado": 2}
	#enum estatus_responsabilidad_aseguradora: {"Responsablee": 1, "Afectadoo": 2}
	#has_rich_text :declaracion
	has_one_attached :imagen_antes
	has_one_attached :imagen_despues
	after_create :vehicle_log_create
	#after_update :vehicle_log_update
	before_update :log_actualizar


    def self.insertar_imagen(params)
        @bandera = true
		begin
			params[:imagenes].each_with_index do |img, index|
				insurance_report_ticket_id = params[:insurance_report_ticket_id]
				ticket = InsuranceReportTicket.find_by(id: insurance_report_ticket_id)
				bas64 = img[:imagen].gsub(' ', '+')
				decoded_data = Base64.decode64(bas64.split(',')[1])
				imagen = { 
					io: StringIO.new(decoded_data),
					filename: "evidencia_#{ticket.id}_#{img[:valor]}.png",
					content_type: 'image/png'
				}
				if img[:valor] == "antes"
					if ticket.update(imagen_antes: imagen)
						next
					else
						mensaje = ""
						ticket.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						puts "------------------- Inicia error imagenes siniestralidad ----------------------"
						puts mensaje
						puts "------------------- Termina error imagenes siniestralidad ----------------------"
						@bandera = false
						break
					end
				elsif img[:valor] == "despues"
					if ticket.update(imagen_despues: imagen)
						next
					else
						mensaje = ""
						ticket.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						puts "------------------- Inicia error imagenes siniestralidad ----------------------"
						puts mensaje
						puts "------------------- Termina error imagenes siniestralidad ----------------------"
						@bandera = false
						break
					end
				end
			end
		rescue Exception => e
			puts "------------------- Inicia error imagenes siniestralidad ----------------------"
			puts e
			puts "------------------- Termina error imagenes siniestralidad ----------------------"
			@bandera = false
		end
        return @bandera
    end
	
	def self.crear_ticket(params)
		#byebug
		# bandera_error = 0
		# begin
		# 	vehiculo = Vehicle.consulta_x_serie(params[:numero_serie])
		# 	if vehiculo
		# 		siniestro = TypeSinister.find_by(id: params[:type_sinisters_id], status: true)
		# 		if siniestro
		# 			params[:vehicle_id] = vehiculo.id
		# 			params[:numero_poliza] = vehiculo.numero_poliza
		# 			params[:cedis] = vehiculo.catalog_branch.decripcion
		# 			params[:numero_economico] = vehiculo.numero_economico
		# 			params[:vehiculo] = "#{vehiculo.catalog_brand.descripcion}"
		# 			params[:modelo] = vehiculo.catalog_model.descripcion
		# 			params[:estatus_vehiculo] = vehiculo.vehicle_status.descripcion
		# 			params[:type_sinisters_id] = siniestro.id
		# 			params[:tipo_siniestro] = siniestro.nombreSiniestro
		# 			params[:responsable] = vehiculo.catalog_personal.nombre
		# 			params[:estatus] = "Abierto"
		# 			params[:fecha_ocurrio] = params[:fecha_ocurrio].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
		# 			params[:fecha_reporte] = params[:fecha_reporte].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
		# 			if params[:estatus_responsabilidad_gafi] == params[:estatus_responsabilidad_aseguradora]
		# 				params[:coincide] = "Verdadero"
		# 			else
		# 				params[:coincide] = "Falso"
		# 			end
		# 			insurance_report_ticket = InsuranceReportTicket.new(params)
		# 			if insurance_report_ticket.save
		# 				bandera_error = 4
		# 				mensaje = "Ticket registrado con éxito."
		# 			else
		# 				bandera_error = 3
		# 				mensaje = "Ocurrieron uno o más errores que no permitieron guardar el ticket: "
		# 				insurance_report_ticket.errors.full_messages.each do |error|
		# 					mensaje += "#{error}. "
		# 				end
		# 			end
		# 		else
		# 			bandera_error = 1
		# 			mensaje = "No se encontró el tipo de siniestro seleccionado."
		# 		end
		# 	else
		# 		bandera_error = 1
		# 		mensaje = "No se encontró vehículo con el número de serie proporcionado."
		# 	end
		# rescue Exception => e
		# 	puts "Error en guardado de ticket #{e}. -------------------------------------"
		# 	bandera_error = 3
		# 	mensaje = "Ocurrió un error desconocido. Favor de contactar a soporte."
		# end
		# byebug
	end

	def self.consulta_siniestros_indicador(empresa,cedis,responsabilidad,area,vehiculo,anio)
		resultados = Array.new
		fecha_inicio =   Date.strptime("#{anio}-01-01") + 6.hours 
		fecha_fin =   Date.strptime("#{anio}-12-31") + 30.hours 
		total_siniestros = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,estatus:"Cerrado").count
		hash = Hash.new
		hash["enero"] = 0
		hash["febrero"] = 0
		hash["marzo"] = 0
		hash["abril"] = 0
		hash["mayo"] = 0
		hash["junio"] = 0
		hash["julio"] = 0
		hash["agosto"] = 0
		hash["septiembre"] = 0
		hash["octubre"] = 0
		hash["noviembre"] = 0
		hash["diciembre"] = 0
		if responsabilidad == "Todos"
			if cedis != ""
				branch = CatalogBranch.find_by(id:cedis,status: true)
				if area == "" and vehiculo == ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado")	
				elsif area != "" and vehiculo == ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area)	
				elsif area == "" and vehiculo != ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo)	
				elsif area != "" and vehiculo != ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo)	
				end
				if ticket.count > 0
					ticket.each do |tk|
					  if tk.fecha_ocurrio.strftime("%m") == "01"
						  hash["enero"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "02"
						  hash["febrero"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "03"
						  hash["marzo"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "04"
						  hash["abril"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "05"
						  hash["mayo"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "06"
						  hash["junio"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "07"
						  hash["julio"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "08"
						  hash["agosto"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "09"
						  hash["septiembre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "10"
						  hash["octubre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "11"
						  hash["noviembre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "12"
						  hash["diciembre"] += 1
					  end
					end
					percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
					resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
					hash.update(hash) { |key, value| value = 0 }
				end
			elsif empresa != ""
				branches = CatalogBranch.where(catalog_company_id:empresa,status: true)
				if area == "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado")
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area)
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area == "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo)
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo)	
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				end	
			else
				branches = CatalogBranch.where(status: true)
				if area == "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado")	
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area)	
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area == "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo)
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo)
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				end	
			end
		elsif responsabilidad == "0"
			if cedis != ""
				branch = CatalogBranch.find_by(id:cedis,status: true)
				if area == "" and vehiculo == ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)	
				elsif area != "" and vehiculo == ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)	
				elsif area == "" and vehiculo != ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)	
				elsif area != "" and vehiculo != ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)	
				end
				if ticket.count > 0
					ticket.each do |tk|
					  if tk.fecha_ocurrio.strftime("%m") == "01"
						  hash["enero"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "02"
						  hash["febrero"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "03"
						  hash["marzo"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "04"
						  hash["abril"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "05"
						  hash["mayo"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "06"
						  hash["junio"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "07"
						  hash["julio"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "08"
						  hash["agosto"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "09"
						  hash["septiembre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "10"
						  hash["octubre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "11"
						  hash["noviembre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "12"
						  hash["diciembre"] += 1
					  end
					end
					percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
					resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
					hash.update(hash) { |key, value| value = 0 }
				end
			elsif empresa != ""
				branches = CatalogBranch.where(catalog_company_id:empresa,status: true)
				if area == "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area == "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)	
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				end	
			else
				branches = CatalogBranch.where(status: true)
				if area == "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)	
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)	
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area == "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo,estatus_responsabilidad_gafi:1,estatus_responsabilidad_aseguradora:1)
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				end	
			end
		else
			if cedis != ""
				branch = CatalogBranch.find_by(id:cedis,status: true)
				if area == "" and vehiculo == ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)	
				elsif area != "" and vehiculo == ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)	
				elsif area == "" and vehiculo != ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)	
				elsif area != "" and vehiculo != ""
					ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)	
				end
				if ticket.count > 0
					ticket.each do |tk|
					  if tk.fecha_ocurrio.strftime("%m") == "01"
						  hash["enero"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "02"
						  hash["febrero"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "03"
						  hash["marzo"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "04"
						  hash["abril"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "05"
						  hash["mayo"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "06"
						  hash["junio"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "07"
						  hash["julio"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "08"
						  hash["agosto"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "09"
						  hash["septiembre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "10"
						  hash["octubre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "11"
						  hash["noviembre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "12"
						  hash["diciembre"] += 1
					  end
					end
					percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
					resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
					hash.update(hash) { |key, value| value = 0 }
				end
			elsif empresa != ""
				branches = CatalogBranch.where(catalog_company_id:empresa,status: true)
				if area == "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area == "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)	
						if ticket.count > 0
						  ticket.each do |tk|
							if tk.fecha_ocurrio.strftime("%m") == "01"
								hash["enero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "02"
								hash["febrero"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "03"
								hash["marzo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "04"
								hash["abril"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "05"
								hash["mayo"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "06"
								hash["junio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "07"
								hash["julio"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "08"
								hash["agosto"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "09"
								hash["septiembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "10"
								hash["octubre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "11"
								hash["noviembre"] += 1
							end
							if tk.fecha_ocurrio.strftime("%m") == "12"
								hash["diciembre"] += 1
							end
						  end
						  percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						  resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						  hash.update(hash) { |key, value| value = 0 }
						end
					end
				end	
			else
				branches = CatalogBranch.where(status: true)
				if area == "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)	
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo == ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)	
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area == "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",vehicle_id:vehiculo,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				elsif area != "" and vehiculo != ""
					branches.each do |branch|
						ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,cedis:branch.decripcion,estatus:"Cerrado",catalog_area_id: area,vehicle_id:vehiculo,estatus_responsabilidad_gafi:0,estatus_responsabilidad_aseguradora:0)
						if ticket.count > 0
						ticket.each do |tk|
						  if tk.fecha_ocurrio.strftime("%m") == "01"
							  hash["enero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "02"
							  hash["febrero"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "03"
							  hash["marzo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "04"
							  hash["abril"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "05"
							  hash["mayo"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "06"
							  hash["junio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "07"
							  hash["julio"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "08"
							  hash["agosto"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "09"
							  hash["septiembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "10"
							  hash["octubre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "11"
							  hash["noviembre"] += 1
						  end
						  if tk.fecha_ocurrio.strftime("%m") == "12"
							  hash["diciembre"] += 1
						  end
						end
						percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
						resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
						hash.update(hash) { |key, value| value = 0 }
						end
					end
				end	
			end
		end
		return resultados
	end

	def self.consulta_tickets(n_economico, cedis, status, fecha_ini, fecha_fin, registro, siniestro)
		cadena_consulta = ""
		if n_economico != "" 
			cadena_consulta += " numero_economico = '#{n_economico}' and"
		end
		if cedis != "" 
			cadena_consulta += " cedis = '#{cedis}' and"
		end
		if status != "Todos"
			cadena_consulta += " estatus = '#{status}' and"
		end
		if registro != "Todos"
			cadena_consulta += " registro = '#{registro}' and"
		end
		if siniestro != ""
			cadena_consulta += " type_sinisters_id = '#{siniestro}' and"
		end
		if fecha_ini != "" and fecha_fin != ""
			cadena_consulta += " fecha_ocurrio between '#{(fecha_ini + 6.hours).strftime("%Y-%m-%d %H:%M:%M")}' and '#{(fecha_fin + 30.hours).strftime("%Y-%m-%d %H:%M:%S")}'"
		else
			cadena_consulta += " fecha_ocurrio between '#{(Time.now.beginning_of_year + 6.hours).strftime("%Y-%m-%d %H:%M:%M")}' and '#{(Time.now + 30.hours).strftime("%Y-%m-%d %H:%M:%S")}'"
		end
		
		#byebug
		consulta = InsuranceReportTicket.where(cadena_consulta)
		return consulta
	end

	def self.consulta_responsable(n_economico, cedis, empresa, fecha_ini, fecha_fin, responsable, siniestro, area)
		cadena_consulta = ""
		arreglo_responsable = Array.new
		arreglo_matriz = Array.new
		cons_cedis = CatalogBranch.find_by(id: cedis)
		if n_economico != "" 
			cadena_consulta += " numero_economico = '#{n_economico}' and"
		end
		if cedis != "" 
			cadena_consulta += " cedis = '#{cons_cedis.decripcion}' and"
		end
		# if empresa != ""
		# 	cadena_consulta += " catalog_company_id = '#{empresa}' and"
		# end
		if responsable != ""
			cadena_consulta += " responsable = '#{responsable}' and"
		end
		if siniestro != ""
			cadena_consulta += " type_sinisters_id = '#{siniestro}' and"
		end
		if area != ""
			cadena_consulta += " catalog_area_id = '#{area}' and"
		end
		#byebug
		#cadena_consulta += " fecha_ocurrio between '#{(fecha_ini + 6.hours).strftime("%Y-%m-%d %H:%M:%S")}' and '#{(fecha_fin + 30.hours).strftime("%Y-%m-%d %H:%M:%S")}'"
		cadena_consulta += " fecha_ocurrio between '#{(fecha_ini).strftime("%Y-%m-%d %H:%M:%S")}' and '#{(fecha_fin + 30.hours).strftime("%Y-%m-%d %H:%M:%S")}'"
		consulta = InsuranceReportTicket.where(cadena_consulta)
		#byebug
		consulta.each do |cons|
			hash_responsable = Hash.new
			cualquiera = arreglo_responsable.find {|item| item["chofer"] == "#{cons.responsable}"}
            #byebug
            if cualquiera.nil?
				hash_responsable["empresa"] = cons.vehicle.catalog_company.nombre
				hash_responsable["cedis"] = cons.cedis
				hash_responsable["chofer"] = cons.responsable
				if cons.estatus_responsabilidad_gafi == 1
					#hash_responsable["responsabilidad"] = "Responsable"
					hash_responsable["costo_siniestro"] = cons.cargo_deducible_empresa.to_f + cons.cargo_deducible_empleado.to_f
				else
					hash_responsable["costo_siniestro"] = 0
				end
				hash_responsable["total_siniestro"] = 1
				hash_responsable["vehiculos"].nil? ? hash_responsable["vehiculos"] = cons.numero_economico : hash_responsable["vehiculos"] += ", #{cons.numero_economico}"
				hash_responsable["costo_total"] = cons.monto_siniestro
				arreglo_responsable.push(hash_responsable)
			else
				if cons.estatus_responsabilidad_gafi == 1
					#hash_responsable["responsabilidad"] = "Responsable"
					cualquiera["costo_siniestro"] += (cons.cargo_deducible_empresa.to_f + cons.cargo_deducible_empleado.to_f)
					cualquiera["costo_total"] += cons.monto_siniestro
				end
				cualquiera["total_siniestro"] += 1
				cualquiera["vehiculos"] == "" ? cualquiera["vehiculos"] = cons.numero_economico : cualquiera["vehiculos"] += ", #{cons.numero_economico}"
			end

			hash_matriz = Hash.new
			matriz = arreglo_matriz.find {|item| item["chofer"] == "#{cons.responsable}" and item["mes"] == cons.fecha_ocurrio.strftime("%B %Y")}
			if matriz.nil?
				hash_matriz["chofer"] = cons.responsable
				hash_matriz["mes"] = cons.fecha_ocurrio.strftime("%B %Y")
				hash_matriz["cantidad"] = 1
				arreglo_matriz.push(hash_matriz)
			else
				matriz["cantidad"] += 1
			end
		end
		#byebug
		#matriz_todos = InsuranceReportTicket.matriz_todos_resp(fecha_ini.strftime("%Y-%m-%d"),fecha_fin.strftime("%Y-%m-%d"))
		return arreglo_responsable, arreglo_matriz

	end

	def self.matriz_todos_resp(fecha_ini, fecha_fin)
		require 'time_difference'
		consulta = InsuranceReportTicket.where("fecha_ocurrio between '#{fecha_ini}' and '#{fecha_fin}'").order(responsable: :asc, fecha_ocurrio: :asc)
		array_meses = Array.new
		arreglo_consulta = Array.new
		fecha_inicio = fecha_ini.to_date
		fecha_final = fecha_fin.to_date
		empleados = CatalogPersonal.all
		cant_meses = TimeDifference.between(fecha_inicio, fecha_final).in_months
		for i in 0..(cant_meses + 1) do
			hash_meses = Hash.new
			hash_meses["mes_numero"] = (fecha_inicio + i.months).month
			hash_meses["mes_nombre"] = (fecha_inicio + i.months).strftime("%B %Y")
			hash_meses["anio"] = (fecha_inicio + i.months).strftime("%Y")
			array_meses.push(hash_meses)
		end
		pivote_resp = ""
		array_reg = Array.new
		consulta.each_with_index do |cons, index|
			hash_empleado = Hash.new
			#cualquiera = arreglo_consulta.find {|item| item["chofer"] == "#{cons.responsable}"}
			if pivote_resp != cons.responsable
				if index == 0 
					array_resultados = Array.new
					pivote_resp = cons.responsable
					array_meses.each do |arr|
						
					end
				#end
				else
					hash_responsable["chofer"] = cons.responsable
					arreglo_consulta.push(array_reg)
				end
			else
			
			end
		end
		#byebug
	end

	def self.consulta_informe_sin(anio_ini, anio_fin, sucursal_id, empresa, area, vehiculo)
		if sucursal_id != ""
			fecha_ini = "#{anio_ini}-10-01".to_date
			fecha_fin = "#{anio_fin}-09-30"
			#consulta = ClaimReport.where(fecha: fecha_ini..fecha_fin).order(sucursal: :asc, fecha: :asc)
			octubre = nil
			noviembre = nil
			diciembre = nil
			enero = nil
			febrero = nil
			marzo = nil
			abril = nil
			mayo = nil
			junio = nil
			julio = nil
			agosto = nil
			septiembre = nil
			if area == "" and vehiculo == ""
				octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
				septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: sucursal_id).order(sucursal: :asc, fecha: :asc)
			elsif area != "" and vehiculo == ""
				octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
			elsif area == "" and vehiculo != ""
				octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: sucursal_id, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
			elsif area != "" and vehiculo != ""
				octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: sucursal_id, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
			end
			cedis = CatalogBranch.where(status: true, id: sucursal_id)
			#byebug
			return octubre, noviembre, diciembre, enero, febrero, marzo, abril, mayo, junio, julio, agosto,septiembre, cedis
		elsif empresa != "" 
			fecha_ini = "#{anio_ini}-10-01".to_date
			fecha_fin = "#{anio_fin}-09-30"
			#consulta = ClaimReport.where(fecha: fecha_ini..fecha_fin).order(sucursal: :asc, fecha: :asc)
			octubre = nil
			noviembre = nil
			diciembre = nil
			enero = nil
			febrero = nil
			marzo = nil
			abril = nil
			mayo = nil
			junio = nil
			julio = nil
			agosto = nil
			septiembre = nil
			cedis = CatalogBranch.where(status: true, catalog_company_id: empresa)
			if cedis.length > 0
				if area == "" and vehiculo == ""
					octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
				elsif area != "" and vehiculo == ""
					octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				elsif area == "" and vehiculo != ""
					octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				elsif area != "" and vehiculo != ""
					octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				end
			end
			return octubre, noviembre, diciembre, enero, febrero, marzo, abril, mayo, junio, julio, agosto,septiembre, cedis
		else
			fecha_ini = "#{anio_ini}-10-01".to_date
			fecha_fin = "#{anio_fin}-09-30"
			#consulta = ClaimReport.where(fecha: fecha_ini..fecha_fin).order(sucursal: :asc, fecha: :asc)
			octubre = nil
			noviembre = nil
			diciembre = nil
			enero = nil
			febrero = nil
			marzo = nil
			abril = nil
			mayo = nil
			junio = nil
			julio = nil
			agosto = nil
			septiembre = nil
			cedis = CatalogBranch.where(status: true)
			if cedis.length > 0
				if area == "" and vehiculo == ""
					octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
					septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: cedis.map{|x| x.id}).order(sucursal: :asc, fecha: :asc)
				elsif area != "" and vehiculo == ""
					octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
					septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area).order(sucursal: :asc, fecha: :asc)
				elsif area == "" and vehiculo != ""
					octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				elsif area != "" and vehiculo != ""
					octubre = ClaimReport.where(fecha: fecha_ini..fecha_ini.end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					noviembre = ClaimReport.where(fecha: (fecha_ini + 1.months)..(fecha_ini + 1.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					diciembre = ClaimReport.where(fecha: (fecha_ini + 2.months)..(fecha_ini + 2.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					enero = ClaimReport.where(fecha: (fecha_ini + 3.months)..(fecha_ini + 3.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					febrero = ClaimReport.where(fecha: (fecha_ini + 4.months)..(fecha_ini + 4.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					marzo = ClaimReport.where(fecha: (fecha_ini + 5.months)..(fecha_ini + 5.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					abril = ClaimReport.where(fecha: (fecha_ini + 6.months)..(fecha_ini + 6.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					mayo = ClaimReport.where(fecha: (fecha_ini + 7.months)..(fecha_ini + 7.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					junio = ClaimReport.where(fecha: (fecha_ini + 8.months)..(fecha_ini + 8.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					julio = ClaimReport.where(fecha: (fecha_ini + 9.months)..(fecha_ini + 9.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					agosto = ClaimReport.where(fecha: (fecha_ini + 10.months)..(fecha_ini + 10.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
					septiembre = ClaimReport.where(fecha: (fecha_ini + 11.months)..(fecha_ini + 11.months).end_of_month, sucursal_id: cedis.map{|x| x.id}, catalog_area_id: area, vehicle_id: vehiculo).order(sucursal: :asc, fecha: :asc)
				end
			end
			return octubre, noviembre, diciembre, enero, febrero, marzo, abril, mayo, junio, julio, agosto,septiembre, cedis
		end
	end

	def vehicle_log_create
		VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} registró un siniestro con número de siniestro ##{self.numero_siniestro} para el vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
	end

	# def vehicle_log_update
	# 	VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} actualizó el siniestro ##{self.numero_siniestro} para el vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
	# end

	def log_actualizar
		if self.estatus_changed? 
			if self.estatus_change[0] == "Abierto" and self.estatus_change[1] == "Cerrado"
				VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} marcó como cerrado el ticket de siniestro ##{self.numero_siniestro} para el vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
			elsif self.estatus_change[0] == "Cerrado" and self.estatus_change[1] == "Abierto"
				VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} reabrió el ticket de siniestro ##{self.numero_siniestro} para el vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
			elsif self.estatus_change[1] == "Cancelado"
				VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} canceló el ticket de siniestro ##{self.numero_siniestro} para el vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
			end
		end

		# if self.numero_siniestro_changed?
		# 	VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número de siniestro de #{self.numero_siniestro_change[0]} a #{self.numero_siniestro_change[1]} para el vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
		# end

		# if self.inciso_changed?
		# 	VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el inciso del siniestro ##{self.numero_siniestro} de #{self.inciso_change[0]} a #{self.inciso_change[1]}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
		# end

		# if self.fecha_ocurrio_changed?
		# 	VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la fecha que ocurrió el siniestro ##{self.numero_siniestro} de #{self.fecha_ocurrio_change[0]} a #{self.fecha_ocurrio_change[1]}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
		# end

		# if self.fecha_reporte_changed?
		# 	VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la fecha que se reportó el siniestro ##{self.numero_siniestro} de #{self.fecha_reporte_change[0]} a #{self.fecha_reporte_change[1]}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
		# end
	end


	def self.consulta_siniestros_indicador_correo(empresa,cedis,responsabilidad,area,vehiculo,fecha_inicio,fecha_fin)
		resultados = Array.new
		total_siniestros = InsuranceReportTicket.where(estatus:"Cerrado", fecha_ocurrio: fecha_inicio..fecha_fin).count
		hash = Hash.new
		hash["enero"] = 0
		hash["febrero"] = 0
		hash["marzo"] = 0
		hash["abril"] = 0
		hash["mayo"] = 0
		hash["junio"] = 0
		hash["julio"] = 0
		hash["agosto"] = 0
		hash["septiembre"] = 0
		hash["octubre"] = 0
		hash["noviembre"] = 0
		hash["diciembre"] = 0

		if responsabilidad == "Todos"
			if cedis != ""
				branch = CatalogBranch.find_by(id:cedis,status: true)
				ticket = InsuranceReportTicket.where(cedis:branch.decripcion,estatus:"Cerrado", fecha_ocurrio: fecha_inicio..fecha_fin)	
				if ticket.count > 0
					ticket.each do |tk|
					  if tk.fecha_ocurrio.strftime("%m") == "01"
						  hash["enero"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "02"
						  hash["febrero"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "03"
						  hash["marzo"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "04"
						  hash["abril"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "05"
						  hash["mayo"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "06"
						  hash["junio"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "07"
						  hash["julio"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "08"
						  hash["agosto"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "09"
						  hash["septiembre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "10"
						  hash["octubre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "11"
						  hash["noviembre"] += 1
					  end
					  if tk.fecha_ocurrio.strftime("%m") == "12"
						  hash["diciembre"] += 1
					  end
					end
					percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
					resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
					return resultados
				end
			end
		end
				
	end
	
	def self.consulta_siniestros_indicador
		hoy = Time.zone.now.to_date
		resultados = Array.new
		if hoy.month.to_i >= 10
			fecha_inicio = Date.new(Time.zone.now.year.to_i, 10, 16)
			fecha_fin = Date.new(Time.zone.now.year.to_i + 1, 10, 15)
		else
			fecha_inicio = Date.new(Time.zone.now.year.to_i - 1, 10, 16)
			fecha_fin = Date.new(Time.zone.now.year.to_i, 10, 15)
		end
		total_siniestros = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,estatus:"Cerrado").count
		hash = Hash.new
		hash["enero"] = 0
		hash["febrero"] = 0
		hash["marzo"] = 0
		hash["abril"] = 0
		hash["mayo"] = 0
		hash["junio"] = 0
		hash["julio"] = 0
		hash["agosto"] = 0
		hash["septiembre"] = 0
		hash["octubre"] = 0
		hash["noviembre"] = 0
		hash["diciembre"] = 0
		branches = CatalogBranch.where(status: true)
		branches.each do |branch|
			ticket = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,estatus:"Cerrado",cedis:branch.decripcion)	
			if ticket.count > 0
				ticket.each do |tk|
					if tk.fecha_ocurrio.strftime("%m") == "01"
						hash["enero"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "02"
						hash["febrero"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "03"
						hash["marzo"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "04"
						hash["abril"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "05"
						hash["mayo"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "06"
						hash["junio"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "07"
						hash["julio"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "08"
						hash["agosto"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "09"
						hash["septiembre"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "10"
						hash["octubre"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "11"
						hash["noviembre"] += 1
					end
					if tk.fecha_ocurrio.strftime("%m") == "12"
						hash["diciembre"] += 1
					end
				end
				percentaje =   ticket.count.to_f/total_siniestros.to_f * 100.0
				resultados.push(cedis:branch.decripcion,cantidad:ticket.count,porcentaje:percentaje,enero:hash["enero"],febrero:hash["febrero"],marzo:hash["marzo"],abril:hash["abril"],mayo:hash["mayo"],junio:hash["junio"],julio:hash["julio"],agosto:hash["agosto"],septiembre:hash["septiembre"],octubre:hash["octubre"],noviembre:hash["noviembre"],diciembre:hash["diciembre"])
				hash.update(hash) { |key, value| value = 0 }
			end
		end
		return resultados
	end

	def self.consulta_siniestros_indicador
		hoy = Time.zone.now.to_date
		resultados = Array.new
		if hoy.month.to_i >= 10
			fecha_inicio = Date.new(Time.zone.now.year.to_i, 10, 16)
			fecha_fin = Date.new(Time.zone.now.year.to_i + 1, 10, 15)
		else
			fecha_inicio = Date.new(Time.zone.now.year.to_i - 1, 10, 16)
			fecha_fin = Date.new(Time.zone.now.year.to_i, 10, 15)
		end
		responsables = CatalogPersonal.all
		responsables.each do |responsable|
			siniestros = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,estatus:"Cerrado", responsable: responsable.nombre)
			if siniestros.length >= 2
				responsable_ = 0
				monto_responsable = 0
				afectado = 0
				monto_afectado = 0
				siniestros.each do |siniestro|
					if siniestro.estatus_responsabilidad_gafi == 0
						responsable_ += 1
						monto_responsable += siniestro.monto_siniestro
					else
						afectado += 1
						monto_afectado += siniestro.monto_siniestro
					end
				end
				resultados.push(conductor: responsable.nombre, responsable: responsable_, monto_responsable: monto_responsable, afectado: afectado, monto_afectado: monto_afectado, total: responsable_ + afectado, monto_total: monto_responsable + monto_afectado)
			end
		end
		return resultados
	end

	def self.consulta_siniestros_indicador_fecha(empresa,cedis,responsabilidad,area,vehiculo,anio)
		hoy_date = Time.zone.now.to_date
		hoy = Date.new(anio.to_i, hoy_date.month, hoy_date.day)
		resultados = Array.new
		if hoy.month.to_i >= 10
			fecha_inicio = Date.new(hoy.year.to_i, 10, 16)
			fecha_fin = Date.new(hoy.year.to_i + 1, 10, 15)
		else
			fecha_inicio = Date.new(hoy.year.to_i - 1, 10, 16)
			fecha_fin = Date.new(hoy.year.to_i, 10, 15)
		end
		responsables = CatalogPersonal.all
		responsables.each do |responsable|
			siniestros = InsuranceReportTicket.where(fecha_ocurrio:fecha_inicio..fecha_fin,estatus:"Cerrado", responsable: responsable.nombre)
			if siniestros.length >= 2
				responsable_ = 0
				monto_responsable = 0
				afectado = 0
				monto_afectado = 0
				siniestros.each do |siniestro|
					if siniestro.estatus_responsabilidad_gafi == 0
						responsable_ += 1
						monto_responsable += siniestro.monto_siniestro
					else
						afectado += 1
						monto_afectado += siniestro.monto_siniestro
					end
				end
				resultados.push(conductor: responsable.nombre, responsable: responsable_, monto_responsable: monto_responsable, afectado: afectado, monto_afectado: monto_afectado, total: responsable_ + afectado, monto_total: monto_responsable + monto_afectado)
			end
		end
		return resultados
	end
end
