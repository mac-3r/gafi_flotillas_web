class VehiclePolicy < ApplicationRecord
  belongs_to :vehicle
  belongs_to :insurance_policy
end
