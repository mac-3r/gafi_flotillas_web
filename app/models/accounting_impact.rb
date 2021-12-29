class AccountingImpact < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_area
  validates :nombre,:cuenta_contable, presence: true

  def get_status
    return self.status ? "Activo" : "Inactivo"
  end

  def self.consulta_afectaciones(area,cedis,tipo)
    cadena_consulta = ""
      if tipo != "" 
        cadena_consulta += " cuenta_contable = '#{tipo}' and"
      end

      if cedis != "" 
        cadena_consulta += " catalog_branch_id = #{cedis} and"
      end

      if area != ""
        cadena_consulta += " catalog_area_id = #{area} and"
      end
      cadena_consulta += " accounting_impacts.status"
    

      consulta = AccountingImpact.joins(:catalog_branch).where(cadena_consulta).order(decripcion: :asc)
      return consulta  
  end

end
