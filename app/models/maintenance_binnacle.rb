class MaintenanceBinnacle < ApplicationRecord
  belongs_to :catalog_brand
  belongs_to :concept
  belongs_to :concept_description
  belongs_to :vehicle
end
