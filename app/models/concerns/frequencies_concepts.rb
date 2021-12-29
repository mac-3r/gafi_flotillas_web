class FrequenciesConcepts < ActiveRecord::Base
  
    attr_accessor :seleccionado

    def readonly?
        true
    end

    def self.consulta_conceptos(id)
        linea = ConceptBrand.where(catalog_brand_id: id)
        categorias = FrequenciesConcepts.all.order(categoria: :asc)
        #categorias = ConceptDescription.joins(:concept_conceptdescriptions).where(estatus: true).order("concept_conceptdescriptions.concept_id asc")
        categorias.each do |categoria|
            if categoria.id.in?(linea.map{|x| x.estatus ? x.concept_description_id : 0})
                categoria.seleccionado = true
            else
                categoria.seleccionado = false
            end
        end
        return categorias
    end  

end