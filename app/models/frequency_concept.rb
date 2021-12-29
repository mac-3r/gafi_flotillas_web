class FrequencyConcept < ApplicationRecord
	enum tipo_frecuencia: ["KM", "Meses", "Horas"]
	belongs_to :concept_brand
	belongs_to :catalog_brand
	self.primary_key = "id"

	def self.importar_bitacora(file, usuario)
		spreadsheet = Roo::Spreadsheet.open(file.path)
        arreglo_conceptos = Array.new()
        header = spreadsheet.sheet('Importación').row(8)
        (9..spreadsheet.sheet('Importación').last_row).each do |i|
			row = Hash[[header, spreadsheet.sheet('Importación').row(i)].transpose]
            hash_concepto = Hash.new

			if row["Clave de la línea"] == "" or row["Clave de la línea"].nil?
                hash_concepto["Problema"] = "La clave de la línea no es correcta o el campo 'Clave de la línea' se encuentra vacío."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Clave de la línea"]
                arreglo_conceptos.push(hash_concepto)
                next
            end
			cvelinea = row["Clave de la línea"].to_s
			if cvelinea.gsub(" ", "") == ""
                hash_concepto["Problema"] = "La clave de la línea no es correcta o el campo 'Clave de la línea' se encuentra vacío."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Clave de la línea"]
                arreglo_conceptos.push(hash_concepto)
                next
            end

			if row["Clave del concepto"] == "" or row["Clave del concepto"].nil?
                hash_concepto["Problema"] = "La clave del concepto no es correcta o el campo 'Clave del concepto' se encuentra vacío."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Clave del concepto"]
                arreglo_conceptos.push(hash_concepto)
                next
            end

			cveconcepto = row["Clave del concepto"].to_s
			if cveconcepto.gsub(" ", "") == ""
                hash_concepto["Problema"] = "La clave del concepto no es correcta o el campo 'Clave del concepto' se encuentra vacío."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Clave del concepto"]
                arreglo_conceptos.push(hash_concepto)
                next
            end

			consulta_linea = CatalogBrand.find_by(status: true, clave: row["Clave de la línea"])
			if !consulta_linea
                hash_concepto["Problema"] = "La clave de la línea no existe o es incorrecta. Por favor verifica que la línea existe y que la clave sea correcta."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Clave de la línea"]
                arreglo_conceptos.push(hash_concepto)
                next
            end

			consulta_concepto = ConceptDescription.find_by(estatus: true, clave: row["Clave del concepto"])
			if !consulta_concepto
                hash_concepto["Problema"] = "La clave del concepto de mantenimiento no existe o es incorrecta. Por favor verifica que el concepto existe y que la clave sea correcta."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Clave del concepto"]
                arreglo_conceptos.push(hash_concepto)
                next
            end
			
			consulta_asignacion = ConceptBrand.find_by(estatus: true, catalog_brand_id: consulta_linea.id, concept_description_id: consulta_concepto.id)
			if !consulta_asignacion
                hash_concepto["Problema"] = "El concepto de mantenimiento no está asignado a la línea seleccionada. Comprueba que el concepto coincida con los asignados a la línea."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = "Clave de la línea: #{row["Clave de la línea"]}. Clave del concepto: #{row["Clave del concepto"]}."
                arreglo_conceptos.push(hash_concepto)
                next
            end

			if row["Tipo de frecuencia"].nil?
				hash_concepto["Problema"] = "El tipo de frecuencia no es válido o el campo 'Tipo de frecuencia' se encuentra vacío."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Tipo de frecuencia"]
                arreglo_conceptos.push(hash_concepto)
                next
			end

			if row["Tipo de frecuencia"].gsub(" ", "") == "" or (row["Tipo de frecuencia"].to_s.gsub(" ", "") != "KM" and row["Tipo de frecuencia"].to_s.gsub(" ", "") != "Meses" and row["Tipo de frecuencia"].to_s.gsub(" ", "") != "Horas")
				hash_concepto["Problema"] = "El tipo de frecuencia no es válido o el campo 'Tipo de frecuencia' se encuentra vacío."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Tipo de frecuencia"]
                arreglo_conceptos.push(hash_concepto)
                next
			end
			fecha_inicial = nil
			if row["Tipo de frecuencia"].gsub(" ", "") == "Meses"
				if row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == ""
					hash_concepto["Problema"] = "El campo de mes de inicio se encuentra vacío."
					hash_concepto["fila"] = i
					hash_concepto["nombre"] = row["Mes de inicio (Opcional)"]
					arreglo_conceptos.push(hash_concepto)
                	next
				else
					if row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "1" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "2" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "3" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "4" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "5" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "6" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "7" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "8" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "9" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "10" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "11" or row["Mes de inicio (Opcional)"].to_s.gsub(" ", "") == "12"
						mes_inicio = row["Mes de inicio (Opcional)"].to_i
						if Time.zone.now.month > mes_inicio
							fecha_inicial = Date.new(Time.zone.now.year + 1, mes_inicio, 1)
						else
							fecha_inicial = Date.new(Time.zone.now.year, mes_inicio, 1)
						end
					else
						hash_concepto["Problema"] = "El mes ingresado en el campo 'Mes de inicio (Opcional)' no es válido."
						hash_concepto["fila"] = i
						hash_concepto["nombre"] = row["Mes de inicio (Opcional)"]
						arreglo_conceptos.push(hash_concepto)
						next
					end
				end
			else
				mes_inicio = nil
			end

			if row["Frecuencia para reemplazo"].to_s.gsub(" ", "") == "" and row["Frecuencia para inspección"].to_s.gsub(" ", "") == ""
				hash_concepto["Problema"] = "Los campos 'Frecuencia para reemplazo' y 'Frecuencia para inspección' están vacíos. Se debe capturar por lo menos uno."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Clave de la línea"]
                arreglo_conceptos.push(hash_concepto)
                next
			end

			if row["Frecuencia para reemplazo"].to_s.gsub(" ", "").to_s.scan(/\D/).empty?

			else
				hash_concepto["Problema"] = "El campo 'Frecuencia para reemplazo' contiene un valor no válido. Capture solamente datos numéricos"
				hash_concepto["fila"] = i
				hash_concepto["nombre"] = row["Frecuencia para reemplazo"]
				arreglo_conceptos.push(hash_concepto)
				next
			end

			if row["Frecuencia para inspección"].to_s.gsub(" ", "").to_s.scan(/\D/).empty?
	
			else
				hash_concepto["Problema"] = "El campo 'Frecuencia para inspección' contiene un valor no válido. Capture solamente datos numéricos"
				hash_concepto["fila"] = i
				hash_concepto["nombre"] = row["Frecuencia para inspección"]
				arreglo_conceptos.push(hash_concepto)
				next
			end
			consulta_frecuencia = FrequencyConcept.find_by(catalog_brand_id: consulta_linea.id, concept_brand_id: consulta_asignacion.id, estatus: true)
			if consulta_frecuencia
				begin
					if consulta_frecuencia.update(estatus: false, usuario_desactiva_id: usuario)
						frecuencia = FrequencyConcept.create(catalog_brand_id: consulta_linea.id, concept_brand_id: consulta_asignacion.id, tipo_frecuencia: row["Tipo de frecuencia"], frecuencia_reemplazo: row["Frecuencia para reemplazo"], frecuencia_inspeccion: row["Frecuencia para inspección"], meses: mes_inicio, user_id: usuario, fecha: fecha_inicial)
						if !frecuencia.save
							consulta_frecuencia.update(estatus: true)
							mensaje = "Ocurrió un error registrando la nueva frecuencia: "
							consulta_frecuencia.errors.full_messages.each do |error|
								mensaje += "#{error}. "
							end
							hash_concepto["Problema"] = mensaje
							hash_concepto["fila"] = i
							hash_concepto["nombre"] = row["Clave de la línea"]
							arreglo_conceptos.push(hash_concepto)
							next
						end
					else
						mensaje = "Ocurrió un error deshabilitando la frecuencia anterior: "
						consulta_frecuencia.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						hash_concepto["Problema"] = mensaje
						hash_concepto["fila"] = i
						hash_concepto["nombre"] = row["Clave de la línea"]
						arreglo_conceptos.push(hash_concepto)
						next
					end
				rescue => exception
					hash_concepto["Problema"] = "Ocurrió un error: #{exception}."
					hash_concepto["fila"] = i
					hash_concepto["nombre"] = row["Clave de la línea"]
					arreglo_conceptos.push(hash_concepto)
					next
				end
			else
				begin
					frecuencia = FrequencyConcept.create(catalog_brand_id: consulta_linea.id, concept_brand_id: consulta_asignacion.id, tipo_frecuencia: row["Tipo de frecuencia"], frecuencia_reemplazo: row["Frecuencia para reemplazo"], frecuencia_inspeccion: row["Frecuencia para inspección"], meses: mes_inicio, user_id: usuario, fecha: fecha_inicial)
					if !frecuencia.save
						mensaje = "Ocurrió un error registrando la nueva frecuencia: "
						consulta_frecuencia.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						hash_concepto["Problema"] = mensaje
						hash_concepto["fila"] = i
						hash_concepto["nombre"] = row["Clave de la línea"]
						arreglo_conceptos.push(hash_concepto)
						next
					end
				rescue => exception
					hash_concepto["Problema"] = "Ocurrió un error: #{exception}."
					hash_concepto["fila"] = i
					hash_concepto["nombre"] = row["Clave de la línea"]
					arreglo_conceptos.push(hash_concepto)
					next
				end
			end
		end
		return arreglo_conceptos
	end
end
