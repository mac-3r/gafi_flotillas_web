class Warehouse < ApplicationRecord
  belongs_to :catalog_company
  has_many :vehicles

  def self.listado_almacenes
    return Warehouse.where(estatus: true)
  end

  def clave_descripcion
    return "#{self.clave}.- #{self.descripcion}"
  end
  
  
end
