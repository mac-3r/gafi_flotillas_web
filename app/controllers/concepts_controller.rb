class ConceptsController < ApplicationController
	rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
	before_action :authenticate_user!
	before_action :validacion_menu
	def index
		@concepts = Concept.where(estatus: true).order(descripcion: :asc)
	end

	def ver_conceptos
		@concepto = Concept.find_by(id: params[:id_categoria], estatus: true)
		if @concepto
			@conceptos = Concept.consulta_conceptos(@concepto.id)
		end
	end

	def ver_servicio
		@accion = ConceptDescription.find_by(id: params[:id_accion], estatus: true)
		if @accion
			@acciones = ConceptDescription.consulta_servicios(@accion.id)
		end
	end

	def modal_nva_categoria
		@concepto = Concept.new
		@metodo = "POST"
		@url = "guardar_categoria_path"
	end

	def modal_editar_categoria
		@concepto = Concept.find_by(id: params[:id_categoria])
		if @concepto
			@metodo = "PATCH"
			@url = "editar_categoria_path(#{@concepto.id})"
		end
	end

	def guardar_categoria
		bandera_error = false
		@nuevo_concepto = Concept.new(concept_params)
		begin
			if @nuevo_concepto.save
				flash[:notice] = "Categoría de mantenimiento registrado con éxito"
				redirect_to concepts_index_path
			else
				bandera_error = true
				@mensaje = "Ocurrió uno o más errores registrando la categoría: "
				@nuevo_concepto.errors.full_messages.each do |error|
					@mensaje += "#{error}. "
				end
			end
		rescue => exception
			bandera_error = true
			@mensaje = "Error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
	end

	def editar_categoria
		bandera_error = false
		@concepto = Concept.find_by(id: params[:id_categoria])
		begin
			#byebug
			if @concepto
				#byebug
				if @concepto.update(concept_params)
					flash[:notice] = "Categoría de mantenimiento actualizado con éxito"
					redirect_to concepts_index_path
				else
					bandera_error = true
					@mensaje = "Ocurrió uno o más errores actualizando la categoría: "
					@concepto.errors.full_messages.each do |error|
						@mensaje += "#{error}. "
					end
				end
			else
				bandera_error = true
				@mensaje = "No se encontró la categoría seleccionada."
			end
		rescue => exception
			bandera_error = true
			@mensaje = "Error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
	end

	def importar_categorias
		@concepts = Concept.importar_categorias(params[:file])
		respond_to do |format|
			if @concepts.count == 0
				format.html { redirect_to concepts_index_path, notice: "Plantilla cargada con éxito." }
			else
				format.html { render :import_concepts_errors }
				format.json { render json: @concepts }
			end
		end
	end

	def descargar_plantilla_categorias
		send_file "#{Rails.root}/public/packs/Importaciones/Layout_categorias_mantenimiento.xlsx"
	end

	def asignar_servicios
		id = params[:id_accion]
		@bandera_error = false
		@mensaje = "Servicios asignados con éxito"
		categorias = params[:acciones]
		ConceptServiceDescription.transaction do
			ConceptServiceDescription.where(concept_description_id: id).destroy_all
			categorias.each do |categ|
				cadena = "chkcategoria_#{categ}"
				if params[cadena.to_sym]
					registro = ConceptServiceDescription.new(concept_description_id: id,concept_service_id: categ)
					if registro.save

					else
						@mensaje = "Ocurrió un error: "
						registro.errors.full_messages.each do |error|
							@mensaje += "#{error}. "
						end
						raise ActiveRecord::Rollback
						break
					end
				end
			end 
			respond_to do |format|
				format.js
			end
		end
		rescue Exception => e
			raise ActiveRecord::Rollback
			@bandera_error = true
			@mensaje = "Ocurrió un error interno del sistema: #{e}. Favor de contactar a soporte."
			respond_to do |format|
				format.js
			end
	end

	def asignar_categorias
		id = params[:id_categoria]
		@bandera_error = false
		@mensaje = "Conceptos asignados con éxito"
		categorias = params[:conceptos]
		ConceptConceptdescription.transaction do
			ConceptConceptdescription.where(concept_id: id).destroy_all
			categorias.each do |categ|
				cadena = "chkcategoria_#{categ}"
				if params[cadena.to_sym]
					registro_existe = ConceptConceptdescription.where(concept_description_id: categ)
					if registro_existe.count > 0
						accion = ConceptDescription.find_by(id:categ)
						@bandera_error = true
						@mensaje = "Este concepto ya a sido asignado a otra Categoría. Clave: #{accion.clave}  Concepto: #{accion.nombre}"
					else
						registro = ConceptConceptdescription.new(concept_id: id,concept_description_id: categ)
						if registro.save
						else
							@mensaje = "Ocurrió un error: "
							registro.errors.full_messages.each do |error|
								@mensaje += "#{error}. "
							end
							raise ActiveRecord::Rollback
							break
						end			
					end
				end
			end 
			respond_to do |format|
				format.js
			end
		end
		rescue Exception => e
			raise ActiveRecord::Rollback
			@bandera_error = true
			@mensaje = "Ocurrió un error interno del sistema: #{e}. Favor de contactar a soporte."
			respond_to do |format|
				format.js
			end
	end

	def eliminar_categoria
		bandera_error = false
		categoria = Concept.find_by(id: params[:id_categoria])
		if categoria
			if categoria.update(estatus: false)
				ConceptConceptdescription.where(concept_id: categoria.id).destroy_all
				@mensaje = "Categoría eliminada con éxito."
				respond_to do |format|
					format.html {redirect_to concepts_index_path, notice: @mensaje}
				end
			else
				bandera_error = true
				@mensaje = "Ocurrió un error: "
				categoria.errors.full_messages.each do |error|
					@mensaje += "#{error}. "
				end
			end
		else
			bandera_error = true
			@mensaje = "No se encontró la categoría seleccionada."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
	end

	def new 
		@concept = Concept.new
	end 

  def create_new_concept
    concept = Concept.new(descripcion:params[:concept][:descripcion])
      if concept.save
          flash[:notice] = "Concepto registrado con éxito"
          redirect_to concepts_index_path
      else
          mensaje = ""
          concept.errors.full_messages.each do |message|
              mensaje += message
          end
          flash[:alert] = mensaje
          redirect_to concepts_index_path
      end
  end

  def edit
    @concept = Concept.find_by(id:params[:id])
    #byebug
  end

  def save_concept
    concept = Concept.find_by(id:params[:id])
    if concept.update(descripcion:params[:descripcion])
        flash[:notice] = "Concepto actualizado con éxito"
        redirect_to concepts_index_path
    else
        mensaje = ""
        concept.errors.full_messages.each do |message|
            mensaje += message
        end
        flash[:alert] = mensaje
        redirect_to concepts_index_path
    end
  end

  def delete
    concept = Concept.find_by(id:params[:id])
    if concept.destroy
      flash[:notice] = "Concepto eliminado con éxito"
      redirect_to concepts_index_path
    else
      mensaje = ""
      concept.errors.full_messages.each do |message|
          mensaje += message
      end
      flash[:alert] = mensaje
      redirect_to concepts_index_path
    end
  end
  
  def asign_actions
    @concept = Concept.find_by(id:params[:id])
  end

  def mostrar_acciones
    @bandera_error = false
    if params[:catalog_brand_id].nil? or params[:catalog_brand_id] == ""
			@bandera_error = true
      @mensaje = "Seleccione una línea."
    else
      @categorias = FrequenciesConcepts.consulta_conceptos(params[:catalog_brand_id])
      @linea = CatalogBrand.find_by(id:params[:catalog_brand_id])
	  if @categorias == []
		@bandera_error = true
		@mensaje = "No se encontraron datos, por favor verifique que la categoría tenga asignado un concepto."
	  end
    end
  end
  
  def assign_concept_brand
  
  end
  
  def save_actions_brand
    id = params[:id]
    categorias = params[:categorias]
	@mensaje = ""
	@bandera_error = false
	ConceptBrand.transaction do 
		conceptos_antes = ConceptBrand.where(catalog_brand_id: params[:id])
		if conceptos_antes.length > 0
			conceptos_antes.update_all(estatus: false)
		end
		categorias.each do |categ|
			cadena = "chkcategoria_#{categ}"
			if params[cadena.to_sym]
				consulta_existe = ConceptBrand.find_by(catalog_brand_id: params[:id], concept_description_id: categ)
				if consulta_existe
					if consulta_existe.estatus
						if consulta_existe.update(estatus: false)
							consulta_activo = FrequencyConcept.find_by(catalog_brand_id: params[:id], concept_brand_id: categ, estatus: true)
							if consulta_activo
								if consulta_activo.update(estatus: false)
								else
									@bandera_error = true
									@mensaje = "Ocurrió un error: "
									consulta_activo.errors.full_messages.each do |error|
										@mensaje += "#{error}. "
									end
									raise ActiveRecord::Rollback
								end
							end
						else
							@bandera_error = true
							@mensaje = "Ocurrió un error: "
							consulta_existe.errors.full_messages.each do |error|
								@mensaje += "#{error}. "
							end
							raise ActiveRecord::Rollback
						end
					else
						if consulta_existe.update(estatus: true)
						
						else
							@bandera_error = true
							@mensaje = "Ocurrió un error: "
							consulta_existe.errors.full_messages.each do |error|
								@mensaje += "#{error}. "
							end
							raise ActiveRecord::Rollback
						end
					end
				else
					concepto = ConceptBrand.new(catalog_brand_id: params[:id], concept_description_id: categ)
					if concepto.save
					
					else
						@bandera_error = true
						@mensaje = "Ocurrió un error: "
						concepto.errors.full_messages.each do |error|
							@mensaje += "#{error}. "
						end
						raise ActiveRecord::Rollback
					end
				end
			end
		end 
		respond_to do |format|
			format.js
		end
	end
	rescue Exception => e
		@bandera_error = true
		@mensaje = "Ocurrió un error interno del sistema: #{e}. Favor de contactar al administrador del sistema."
		respond_to do |format|
			format.js
		end
  end
  
  def save_action
      concept = Concept.find_by(id:params[:id])
    accion = ConceptDescription.new(nombre:params[:nombre],tipo_afinacion:params[:tipo_afinacion],concept_id:concept.id, clave: params[:clave])
    if accion.save
      flash[:notice] = "Acción asignada con éxito"
      redirect_to asign_actions_path
    else
      mensaje = ""
      accion.errors.full_messages.each do |message|
          mensaje += message
      end
      flash[:alert] = mensaje
      redirect_to concepts_index_path
    end
  end
  
  def invalid_foreign_key
    redirect_to concepts_index_path, alert: 'Este concepto tiene acciones asignadas.'
  end
  


  	# Catálogo de conceptos de mantenimiento

	def index_conceptos
		@concepts = ConceptDescription.where(estatus: true).order(nombre: :asc)
	end

	def modal_nvo_concepto
		@concepto = ConceptDescription.new
		@metodo = "POST"
		@url = "guardar_concepto_path"
	end

	def modal_editar_concepto
		@concepto = ConceptDescription.find_by(id: params[:id_concepto])
		if @concepto
			@metodo = "PATCH"
			@url = "editar_concepto_path(#{@concepto.id})"
		end
	end

	def guardar_concepto
		if !params[:concept_description][:bujias].present?
			params[:concept_description][:bujias] = false
		end
		bandera_error = false
		@nuevo_concepto = ConceptDescription.new(concept_description_params)
		begin
			if @nuevo_concepto.save
				flash[:notice] = "Concepto de mantenimiento registrado con éxito"
				redirect_to index_conceptos_path
			else
				bandera_error = true
				@mensaje = "Ocurrió uno o más errores registrando el concepto: "
				@nuevo_concepto.errors.full_messages.each do |error|
					@mensaje += "#{error}. "
				end
			end
		rescue => exception
			bandera_error = true
			@mensaje = "Error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
	end

	def editar_concepto
		if !params[:concept_description][:bujias].present?
			params[:concept_description][:bujias] = false
		else
			params[:concept_description][:bujias] = true
		end
		bandera_error = false
		@concepto = ConceptDescription.find_by(id: params[:id_concepto])
		begin
			#byebug
			if @concepto
				if @concepto.update(concept_description_params)
					flash[:notice] = "Concepto de mantenimiento actualizado con éxito"
					redirect_to index_conceptos_path
				else
					bandera_error = true
					@mensaje = "Ocurrió uno o más errores actualizando el concepto: "
					@concepto.errors.full_messages.each do |error|
						@mensaje += "#{error}. "
					end
				end
			else
				bandera_error = true
				@mensaje = "No se encontró el concepto seleccionado."
			end
		rescue => exception
			bandera_error = true
			@mensaje = "Error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
	end

	def importar_conceptos
		@concepts = ConceptDescription.importar_conceptos(params[:file])
		respond_to do |format|
			if @concepts.count == 0
				format.html { redirect_to index_conceptos_url, notice: "Plantilla cargada con éxito." }
			else
				format.html { render :import_concept_errors }
				format.json { render json: @concepts }
			end
		end
	end

	def eliminar_concepto
		bandera_error = false
		@concepto = ConceptDescription.find_by(id: params[:id_concepto])
		begin
			if @concepto
				#byebug
				if @concepto.update(estatus: false, usuario_desactiva_id: current_user.id)
					concept_brands = ConceptBrand.where(concept_description_id: @concepto.id)
					concept_brands.update(estatus: false, usuario_desactiva_id: current_user.id)
					FrequencyConcept.where(concept_brand_id: concept_brands.map{|x| x.id}, estatus: true).update(estatus: false, usuario_desactiva_id: current_user.id)
					flash[:notice] = "Concepto de mantenimiento eliminado con éxito"
					redirect_to index_conceptos_path
				else
					bandera_error = true
					@mensaje = "Ocurrió uno o más errores eliminando el concepto: "
					@concepto.errors.full_messages.each do |error|
						@mensaje += "#{error}. "
					end
				end
			else
				bandera_error = true
				@mensaje = "No se encontró el concepto seleccionado."
			end
		rescue => exception
			bandera_error = true
			@mensaje = "Error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
	end

	def descargar_plantilla_conceptos
		send_file "#{Rails.root}/public/packs/Importaciones/Layout_conceptos_mantenimiento.xlsx"
	end

	# Importación de frecuencias

	def plantilla_frecuencias
		require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
		workbook.styles do |s|
			img = File.expand_path("#{Rails.root}/app/assets/images/excel_logo.png", __FILE__)
			col_widths= [3,30,30,30,30,30,30] 
			celda_tabla = s.add_style :bg_color => "BFBFBF", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_cabecera= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right}
			celda_categoria = s.add_style :bg_color => "D9D9D9", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_notas = s.add_style :fg_color => "FF0000" ,:sz => 12
			celda_afi_mayor = s.add_style :bg_color => "808080", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_afi_menor = s.add_style :bg_color => "F2F2F2", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			lineas = CatalogBrand.where(status: true).order(clave: :asc)
			workbook.add_worksheet(name: "Importación") do |sheet|
				sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
				sheet.merge_cells("B1:D1")
				sheet.add_row ["","Importación de frecuencias de mantenimiento","","","","Tipos de frecuencia", "", "Notas:"], :style => [nil, celda_cabecera, nil, nil, nil, celda_afi_mayor,nil,celda_notas]
				sheet.add_row ["","","","","","KM","","Los datos de los campos 'Clave de la línea' y 'Clave del concepto' se pueden obtener del libro correspondiente a la línea en este Excel."], :style => [nil, nil, nil, nil, nil, celda_tabla_td]
				sheet.add_row ["","","","","","Meses","","En el campo 'Tipo de frecuencia' se debe capturar el valor tal cual se encuentra en la tabla 'Tipos de frecuencia'."], :style => [nil, nil, nil, nil, nil, celda_tabla_td]
				sheet.add_row ["","","","","","Horas","","El campo 'Mes de inicio (Opcional)' sólo debe ser capturado si el tipo de frecuencia es 'Meses' y se desea que inicie desde un mes específico"], :style => [nil, nil, nil, nil, nil, celda_tabla_td]
				sheet.add_row ["","","","","","","","En el campo 'Mes de inicio (Opcional)' se debe capturar el número del mes. Ejemplo: Para el mes de Abril ingresar el número 4."]
				sheet.add_row ["","","","","","","","Para los campos 'Frecuencia para reemplazo' y 'Frecuencia para inspección' se deben capturar únicamente valores numéricos."]
				sheet.add_row [""]
				sheet.add_row ["", "Clave de la línea", "Clave del concepto", "Tipo de frecuencia", "Mes de inicio (Opcional)", "Frecuencia para reemplazo", "Frecuencia para inspección"], :style => [nil,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla]
				sheet.column_widths *col_widths
			end
			lineas.each do |linea|
				begin
					workbook.add_worksheet(name: linea.descripcion.gsub(/[^0-9A-Za-z]/, '')) do |sheet|
						asignados = ConceptBrand.where(catalog_brand_id: linea.id)
						conceptos = FrequenciesConcepts.where(id: asignados.map{|x| x.concept_description_id}).order(categoria: :asc)
						sheet.add_row ["","#{linea.descripcion}",""],:height => 20, :b => true, :sz => 18, :font_name => 'Arial'
						sheet.add_row ["","Clave: #{linea.clave}"],:height => 20, :b => true, :sz => 14, :font_name => 'Arial'
						sheet.add_row ["","Frecuencia de reemplazo"],:height => 20, :b => true, :sz => 14, :font_name => 'Arial'
						sheet.add_row ["","","","Afinación menor"," "], :style => [nil,nil,nil,nil,celda_afi_menor]
						sheet.add_row ["","","","Afinación mayor"," "], :style => [nil,nil,nil,nil,celda_afi_mayor]
						sheet.add_row ["", "Concepto", "Clave"], :style => [nil,celda_tabla,celda_tabla]
						bandera_nombre = ""
						conceptos.each do |conc|
							if conc.tipo_afinacion.to_s == "0"
								c_celda = celda_afi_menor
							else
								c_celda = celda_afi_mayor
							end
							if bandera_nombre != conc.categoria
								bandera_nombre = conc.categoria
								sheet.add_row ["","#{conc.categoria}",""], :style => [nil, celda_categoria,celda_categoria]
								sheet.add_row ["","#{conc.nombre}","#{conc.clave}"], :style => [c_celda]
							else
								sheet.add_row ["","#{conc.nombre}","#{conc.clave}"], :style => [c_celda]
							end
						end
					end
				rescue => exception
					puts linea.descripcion
				end
			end
		end
		send_data package.to_stream.read, type: "application/xlsx", filename: "Layout_importación_frecuencias.xlsx"
	end
	
	def binnacles_index
		
	end
	
	def mostrar_bitacora
		if  params[:catalog_brand_id] != ""
			@binnacles = FrequencyConcept.find_by_sql("SELECT frequency_concepts.id, concept_descriptions.nombre, concepts.descripcion,catalog_brands.descripcion as linea,frequency_concepts.tipo_frecuencia,frequency_concepts.frecuencia_inspeccion,frequency_concepts.frecuencia_reemplazo FROM frequency_concepts
				INNER JOIN catalog_brands ON catalog_brands.id = frequency_concepts.catalog_brand_id 
				INNER JOIN concept_brands ON concept_brands.id = frequency_concepts.concept_brand_id 
				INNER JOIN concept_descriptions ON concept_descriptions.id = concept_brands.concept_description_id
				INNER JOIN concept_conceptdescriptions on concept_conceptdescriptions.concept_description_id = concept_descriptions.id
				inner join concepts on concepts.id = concept_conceptdescriptions.concept_id
				WHERE frequency_concepts.estatus = true
				and frequency_concepts.catalog_brand_id = #{params[:catalog_brand_id]} order by descripcion asc, concept_descriptions.nombre asc")
		else
			@binnacles = FrequencyConcept.find_by_sql("SELECT frequency_concepts.id, concept_descriptions.nombre, concepts.descripcion,catalog_brands.descripcion as linea,frequency_concepts.tipo_frecuencia,frequency_concepts.frecuencia_inspeccion,frequency_concepts.frecuencia_reemplazo FROM frequency_concepts
				INNER JOIN catalog_brands ON catalog_brands.id = frequency_concepts.catalog_brand_id 
				INNER JOIN concept_brands ON concept_brands.id = frequency_concepts.concept_brand_id 
				INNER JOIN concept_descriptions ON concept_descriptions.id = concept_brands.concept_description_id
				INNER JOIN concept_conceptdescriptions on concept_conceptdescriptions.concept_description_id = concept_descriptions.id
				inner join concepts on concepts.id = concept_conceptdescriptions.concept_id
				WHERE frequency_concepts.estatus = true order by descripcion asc, concept_descriptions.nombre asc, catalog_brands.descripcion asc")
		end
		if @binnacles == []
			@mensaje = "No se encontró información de la línea seleccionada."
			@bandera_error = true
		end
	end

	def update_binnacle
		@resultado = FrequencyConcept.find_by(id:params[:id])
	end

	def editar_bitacora
		registro =  FrequencyConcept.find_by(id:params[:id])
		if params[:tipo_frecuencia] == "Meses"
			if Time.zone.now.month > params[:mes_inicio].to_i
				fecha_inicial = Date.new(Time.zone.now.year + 1, params[:mes_inicio].to_i, 1)
			else
				fecha_inicial = Date.new(Time.zone.now.year, params[:mes_inicio].to_i, 1)
			end
			if registro.update(frecuencia_reemplazo:params[:frecuencia_reemplazo],frecuencia_inspeccion:params[:frecuencia_inspeccion],tipo_frecuencia:params[:tipo_frecuencia],meses:params[:mes_inicio].to_i,fecha:fecha_inicial)
				flash[:notice] = "Registro actualizado con éxito."
				redirect_to binnacles_index_path
			else
				flash[:alert] = "Ocurrió un error."
				redirect_to binnacles_index_path
			end
		else
			if registro.update(frecuencia_reemplazo:params[:frecuencia_reemplazo],frecuencia_inspeccion:params[:frecuencia_inspeccion],tipo_frecuencia:params[:tipo_frecuencia],meses:nil,fecha:nil)
				flash[:notice] = "Registro actualizado con éxito."
				redirect_to binnacles_index_path
			else
				flash[:alert] = "Ocurrió un error."
				redirect_to binnacles_index_path
			end
		end
	end
	
	def borrar_bitacora
		begin
			registro = FrequencyConcept.find_by(id:params[:id])
			if registro.destroy
				flash[:notice] = "Registro eliminado con éxito."
				redirect_to binnacles_index_path
			end
		rescue => exception
			flash[:alert] = "Ocurrió un error favor de contactar soporte. Error: #{exception}."
			redirect_to binnacles_index_path
		end
	end
	

	def importar_bitacora_mantenimiento
		@concepts = FrequencyConcept.importar_bitacora(params[:file], current_user.id)
		respond_to do |format|
			if @concepts.count == 0
				format.html { redirect_to service_orders_url, notice: "Plantilla cargada con éxito." }
			else
				format.html { render :import_binnacle_errors }
				format.json { render json: @concepts }
			end
		end
	end

	private
    def validacion_menu
      session["menu1"] = "Seguridad"
      session["menu2"] = "Catálogos"
    end

	def concept_description_params
		params.require(:concept_description).permit(:nombre, :clave, :tipo_afinacion, :user_id,:bujias)
	end

	def concept_params
		params.require(:concept).permit(:descripcion, :clave, :user_id)
	end
end