class AdditionalService < ApplicationRecord
  belongs_to :service_order
  enum estatus: {"Pendiente de autorizar": 0, "Autorizado":1, "Rechazado": 2}
end
