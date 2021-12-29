class DeliveryAddress < ApplicationRecord
  belongs_to :catalog_company
  belongs_to :catalog_branch
  belongs_to :customer
end
