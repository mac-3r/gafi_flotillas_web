class Quote < ApplicationRecord
  belongs_to :vehicle
  belongs_to :service_order
  belongs_to :catalog_workshop, optional: true
  belongs_to :catalog_vendor,optional: true
  has_many :quote_details
  enum estatus: ["Pendiente","Autorizado","Rechazado"]

end
