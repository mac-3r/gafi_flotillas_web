class ConceptBrand < ApplicationRecord
  belongs_to :catalog_brand
  belongs_to :concept_description
  has_many :frequency_concepts
  enum tipo_frecuencia: ["KM", "Meses", "Horas"]

  def self.add_conceptos(id, permisos)
    linea= CatalogBrand.find_by(id: id)
    if !permisos.nil?
        permisos = Permission.where(id: permisos)
        rol.permissions =(permisos)
    else
        rol.permissions.clear
        rol.save
    end
  end 

end
