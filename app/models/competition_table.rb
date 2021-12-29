class CompetitionTable < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_role
  validates :monto, presence: true

  def self.consulta_competencias(rol,cedis,tipo)
    cadena_consulta = ""
    
      if rol != ""
        cadena_consulta += " catalog_role_id = #{rol} and"
      end
      if cedis != "" 
        cadena_consulta += " catalog_branch_id = #{cedis} and"
      end
      if tipo != ""
        cadena_consulta += " tipo = '#{tipo}' and"
      end
      cadena_consulta += " competition_tables.created_at <= '#{(Time.now + 7.hours).strftime("%Y-%m-%d %H:%M:%M")}'"
        consulta = CompetitionTable.joins(:catalog_branch).where(cadena_consulta).order(decripcion: :asc)
      return consulta  
  end

end
