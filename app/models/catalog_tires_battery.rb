class CatalogTiresBattery < ApplicationRecord
  belongs_to :catalog_brand

  def self.consulta_llantas(tipo,linea)
    cadena_consulta = ""
      if tipo != "" and linea != ""
        cadena_consulta += " tipo = '#{tipo}' and catalog_brand_id = #{linea}"
      elsif  linea != "" and tipo == ""
        cadena_consulta += "  catalog_brand_id = #{linea}"
      elsif  linea == "" and tipo != ""
        cadena_consulta += " tipo = '#{tipo}'"
      else
        cadena_consulta = ""
      end

      if cadena_consulta != ""
        consulta = CatalogTiresBattery.joins(:catalog_brand).where(cadena_consulta).order(descripcion: :asc)
      else
        consulta = CatalogTiresBattery.joins(:catalog_brand).all.order(descripcion: :asc)
      end

      return consulta  
end
  def self.listado_articulos(id,tipo)
    CatalogTiresBattery.where(catalog_brand_id:id,tipo:tipo)
  end

  def datoscombo
		"#{self.modelo} -  $#{self.precio} "
	end


end
