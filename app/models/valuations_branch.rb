class ValuationsBranch < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_vendor
  belongs_to :valuation
end
