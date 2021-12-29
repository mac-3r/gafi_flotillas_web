class BudgetSalesReplacement < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_area
  belongs_to :catalog_brand
  belongs_to :reason
  validates :fecha_entrega,:fecha_compra,:importe, presence: true
end
