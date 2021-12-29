class BudgetDeliveryReplacement < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_area
  belongs_to :catalog_brand
  belongs_to :reason
end
