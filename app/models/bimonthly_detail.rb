class BimonthlyDetail < ApplicationRecord
    belongs_to :bimonthly_verification
    belongs_to :vehicle_checklist
end