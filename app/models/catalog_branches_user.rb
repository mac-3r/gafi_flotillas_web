class CatalogBranchesUser < ApplicationRecord
    belongs_to :user
    belongs_to :catalog_branch

    def self.consulta_usuarios(usuario,cedis)
        cadena_consulta = ""
           if usuario != "" and cedis != ""
            cadena_consulta += " user_id = #{usuario} and catalog_branch_id = #{cedis}"
          elsif  cedis != "" and usuario == ""
            cadena_consulta += " catalog_branch_id = #{cedis}"
          elsif  cedis == "" and usuario != ""
            cadena_consulta += " user_id = #{usuario}"
          else
            cadena_consulta = ""
          end
            consulta = CatalogBranchesUser.joins(:user).where(cadena_consulta).order(name: :asc)
          return consulta  
      end

end