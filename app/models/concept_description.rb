class ConceptDescription < ApplicationRecord
    validates :clave, uniqueness: true
    validates :nombre, presence: true
    validates :clave, presence: true

    has_many :concept_conceptdescriptions

  	attr_accessor :seleccionado
    attr_accessor :frecuencia_r
    attr_accessor :frecuencia_i
    attr_accessor :nombre_categoria

    # def self.consulta_conceptos(id)
    #     linea = ConceptBrand.where(catalog_brand_id: id)
    #     categorias
    #     categorias = ConceptDescription.joins(:concept_conceptdescriptions).where(estatus: true).order("concept_conceptdescriptions.concept_id asc")
    #     categorias.each do |categoria|
    #         categoria.nombre_categoria = categoria.
    #         if categoria.id.in?(linea.map{|x| x.concept_description_id})
    #             busqueda = ConceptBrand.find_by(catalog_brand_id: id,concept_description_id:categoria.id, estatus: true)
    #             if busqueda
    #                 categoria.frecuencia_r = busqueda.frecuecia_reemplazo
    #                 categoria.frecuencia_i = busqueda.frecuencia_inspeccion
    #                 #byebug
    #             end
    #             categoria.seleccionado = true
    #         else
    #             categoria.seleccionado = false
    #         end
    #     end
    #     return categorias
    # end  
    def self.consulta_servicios(id)
        linea = ConceptServiceDescription.where(concept_description_id: id)
        servicios = ConceptService.where(estatus:"Activo" ).order(descripcion: :asc)
        #categorias = ConceptDescription.joins(:concept_conceptdescriptions).where(estatus: true).order("concept_conceptdescriptions.concept_id asc")
        servicios.each do |servicio|
            if servicio.id.in?(linea.map{|x| x.concept_service_id})
                servicio.seleccionado = true
            else
                servicio.seleccionado = false
            end
        end
        return servicios
    end  

    def self.importar_conceptos(file)
        spreadsheet = Roo::Spreadsheet.open(file.path)
        arreglo_conceptos = Array.new()
        header = spreadsheet.row(9)
        (10..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            hash_concepto = Hash.new

            if row["Nombre del Concepto"].gsub(" ", "") == ""
                hash_concepto["Problema"] = "El nombre no es correcto o el campo 'Nombre del Concepto' se encuentra vacío."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Nombre del Concepto"]
                arreglo_conceptos.push(hash_concepto)
                next
            end
                
            if row["Clave"] != "" and !row["Clave"].nil? 
                if row["Clave"].to_s.gsub(" ", "") == ""
                    hash_concepto["Problema"] = "La clave no es correcta o el campo 'Clave' se encuentra vacío."
                    hash_concepto["fila"] = i
                    hash_concepto["nombre"] = row["Clave"]
                    arreglo_conceptos.push(hash_concepto)
                    next
                end
            else
                if row["Clave"].to_s.gsub(" ", "") == ""
                    hash_concepto["Problema"] = "La clave no es correcta o el campo 'Clave' se encuentra vacío."
                    hash_concepto["fila"] = i
                    hash_concepto["nombre"] = row["Clave"]
                    arreglo_conceptos.push(hash_concepto)
                    next
                end
            end

            if row["Tipo de afinación"].to_s.gsub(" ", "") != "0" and row["Tipo de afinación"].to_s.gsub(" ", "") != "1"
                hash_concepto["Problema"] = "El tipo de afinación capturado no es válido. Seleccione una de las opciones de la tabla 'Tipos de afinación' que se encuentra en la plantilla."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Nombre del Concepto"]
                arreglo_conceptos.push(hash_concepto)
                next
            end

            begin
                concepto = ConceptDescription.create(nombre: row["Nombre del Concepto"], clave: row["Clave"], tipo_afinacion: row["Tipo de afinación"])
                if !concepto.save
                    mensaje = "Ocurrió un error: "
                    concepto.errors.full_messages.each do |error|
                        mensaje += "#{error}. "
                    end
                    hash_concepto["Problema"] = mensaje
                    hash_concepto["fila"] = i
                    hash_concepto["nombre"] = row["Nombre del Concepto"]
                    arreglo_conceptos.push(hash_concepto)
                    next
                end
            rescue => exception
                hash_concepto["Problema"] = "Ocurrió un error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Nombre del Concepto"]
                arreglo_conceptos.push(hash_concepto)
                next
            end
        end
        return arreglo_conceptos
    end

end
