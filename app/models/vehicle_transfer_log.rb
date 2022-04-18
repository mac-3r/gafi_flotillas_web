class VehicleTransferLog < ApplicationRecord
  belongs_to :vehicle
  belongs_to :catalog_branch
  belongs_to :user
end
