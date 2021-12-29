class FuelBudget < ApplicationRecord
    include ActionView::Helpers::NumberHelper
    validates :precio_litro, presence: true
    belongs_to :vehicle

    after_create :vehicle_log_create

    def vehicle_log_create
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} registró un nuevo presupuesto de combustible al vehículo con número económico #{self.vehicle.numero_economico} de #{self.litros} litros y #{number_to_currency(self.precio_litro)} por litro.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
    end
end
