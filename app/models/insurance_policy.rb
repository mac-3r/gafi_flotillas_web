class InsurancePolicy < ApplicationRecord
  belongs_to :catalog_vendor
  belongs_to :policy_coverage
end
