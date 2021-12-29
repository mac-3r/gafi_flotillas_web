class Concept < ApplicationRecord
    validates :clave, uniqueness: true
    validates :descripcion, presence: true
    validates :clave, presence: true
    has_many :concept_conceptdescriptions

    attr_accessor :seleccionado

    def self.consulta_conceptos(id)
        linea = ConceptConceptdescription.where(concept_id: id)
        categorias = ConceptDescription.where(estatus: true).order(nombre: :asc)
        #categorias = ConceptDescription.joins(:concept_conceptdescriptions).where(estatus: true).order("concept_conceptdescriptions.concept_id asc")
        categorias.each do |categoria|
            if categoria.id.in?(linea.map{|x| x.concept_description_id})
                categoria.seleccionado = true
            else
                categoria.seleccionado = false
            end
        end
        return categorias
    end  
   
    def self.importar_categorias(file)
        spreadsheet = Roo::Spreadsheet.open(file.path)
        arreglo_conceptos = Array.new()
        header = spreadsheet.row(9)
        (10..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            hash_concepto = Hash.new

            if row["Nombre de la categoría"].gsub(" ", "") == ""
                hash_concepto["Problema"] = "El nombre no es correcto o el campo 'Nombre de la categoría' se encuentra vacío."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Nombre de la categoría"]
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

            begin
                concepto = Concept.create(descripcion: row["Nombre de la categoría"], clave: row["Clave"])
                if !concepto.save
                    mensaje = "Ocurrió un error: "
                    concepto.errors.full_messages.each do |error|
                        mensaje += "#{error}. "
                    end
                    hash_concepto["Problema"] = mensaje
                    hash_concepto["fila"] = i
                    hash_concepto["nombre"] = row["Nombre de la categoría"]
                    arreglo_conceptos.push(hash_concepto)
                    next
                end
            rescue => exception
                hash_concepto["Problema"] = "Ocurrió un error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
                hash_concepto["fila"] = i
                hash_concepto["nombre"] = row["Nombre de la categoría"]
                arreglo_conceptos.push(hash_concepto)
                next
            end
        end
        return arreglo_conceptos
    end
end
