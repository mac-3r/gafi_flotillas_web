class VehicleChecklist < ApplicationRecord
  belongs_to :vehicle_type
  validates :clasificacionvehiculo,:conceptovehiculo, presence: true
end
