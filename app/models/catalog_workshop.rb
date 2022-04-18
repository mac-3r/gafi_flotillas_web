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

  def self.listado_talleres_mantenimiento(vehicle_id)
    vehiculo = Vehicle.find_by(id: vehicle_id)
    bitacora = Binnacle.where(catalog_brand_id: vehiculo.catalog_brand_id)
    if bitacora.length > 0
      precios = TuningPrice.where(anio: Time.zone.now.year, catalog_brand_id: vehiculo.catalog_brand_id)
      if precios
        talleres = CatalogWorkshop.where(vigente: true, id: precios.map{|x| x.catalog_workshop_id}).where.not(user_id: nil)
        return talleres, ""
      else
        return CatalogWorkshop.where(id: nil), "No existe lista de precios para el vehículo con número económico #{vehiculo.numero_economico}."
      end
    else
      return CatalogWorkshop.where(id: nil), "No existe bitácora para el vehículo con número económico #{vehiculo.numero_economico}."
    end
  end
  
  def self.listado_talleres_mantenimiento_validacion(vehicle_id, service_order)
    if service_order.tipo_servicio == "Preventivo"
      vehiculo = Vehicle.find_by(id: vehicle_id)
      bitacora = Binnacle.where(catalog_brand_id: vehiculo.catalog_brand_id)
      if bitacora.length > 0
        precios = TuningPrice.where(anio: Time.zone.now.year, catalog_brand_id: vehiculo.catalog_brand_id)
        if precios
          talleres = CatalogWorkshop.where(vigente: true, id: precios.map{|x| x.catalog_workshop_id}).where.not(user_id: nil)
          return talleres, ""
        else
          return CatalogWorkshop.where(id: nil), "No existe lista de precios para el vehículo con número económico #{vehiculo.numero_economico}."
        end
      else
        return CatalogWorkshop.where(id: nil), "No existe bitácora para el vehículo con número económico #{vehiculo.numero_economico}."
      end
    else
      return CatalogWorkshop.where(vigente: true).order(nombre_taller: :asc), ""
    end
  end

end
