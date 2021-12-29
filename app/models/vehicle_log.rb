class VehicleLog < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :vehicle
end
