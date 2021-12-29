class CatalogWorkshop < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :user ,optional: true
  belongs_to :catalog_vendor ,optional: true
  has_many :maintenance_controls
  has_many :workshop_certifications
  validates :clave,:nombre_taller,:telefono,:responsable, presence: true

  def self.consulta_talleres(cedis,nombre)
    cadena_consulta = ""
      if cedis != "" 
        cadena_consulta += " catalog_branch_id = #{cedis} and"
      end
      if nombre != ""
        cadena_consulta += " nombre_taller LIKE '%#{nombre}%' and"
      end
      #cadena_consulta += " catalog_workshops.created_at <= '#{Time.now.strftime("%Y-%m-%d")}'"
      cadena_consulta += " catalog_workshops.vigente"
        consulta = CatalogWorkshop.where(cadena_consulta).order(nombre_taller: :asc)
      return consulta  
  end

  def get_vigente
    return self.vigente ? "SI" : "NO"
  end
  def self.listado_talleres
    CatalogWorkshop.where(vigente:true).order(nombre_taller: :asc)
  end

  def self.consulta_x_taller(id)
    CatalogWorkshop.find_by(id: id)
  end

end
