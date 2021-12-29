class CostCenter < ApplicationRecord
    belongs_to :catalog_company
    belongs_to :catalog_branch
    belongs_to :catalog_area
    has_many :vehicles
    has_many :purchase_orders
    validates :clave,:descripcion,:unidad_negocio, presence: true

    def self.consulta_centros(area,cedis)
        cadena_consulta = ""
          if cedis != "" and area != ""
            cadena_consulta += " catalog_branch_id = #{cedis} and catalog_area_id = #{area}"
          elsif  area != "" and cedis == ""
            cadena_consulta += " catalog_area_id = #{area}"
          elsif  area == "" and cedis != ""
            cadena_consulta += " catalog_branch_id = #{cedis}"
          else
            cadena_consulta = ""
          end

          if cadena_consulta != ""
            consulta = CostCenter.joins(:catalog_branch).where(cadena_consulta).order(decripcion: :asc)
          else
            consulta = CostCenter.joins(:catalog_branch).all.order(decripcion: :asc)
          end

          return consulta  
    end

    def get_status
        return self.status ? "Activo" : "Inactivo"
    end
    def self.listado_centros
        CostCenter.joins(:catalog_area).where(status:true).order('"catalog_areas"."descripcion" ASC')
    end

    def datoscombo
        "#{self.catalog_area_id ? self.catalog_area.descripcion : "N/A"} -  #{self.centro_costo} "
    end
end
