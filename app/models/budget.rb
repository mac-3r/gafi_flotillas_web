class Budget < ApplicationRecord
    has_many :budget_items
    validates :anio, :uniqueness => true

	enum estatus: ["Rechazado","Pendiente", "Por autorizar", "Autorizado","Orden Capturada"]

	def cantidad_vehiculos
		self.budget_items.sum(:cantidad)
	end

	def total_importe
		items = self.budget_items
		total = 0
		items.each do |budget_item|
			total += (budget_item.importe + budget_item.plaqueo + budget_item.seguro)
		end
		return total
	end
end
