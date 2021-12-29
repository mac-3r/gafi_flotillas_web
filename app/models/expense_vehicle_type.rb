class ExpenseVehicleType < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_brand
  validates :clave,:gasto, presence: true
end
