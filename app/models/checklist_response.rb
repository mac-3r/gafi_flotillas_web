class ChecklistResponse < ApplicationRecord
    has_many :checklist_response_detail
    belongs_to :vehicle
    belongs_to :catalog_personal
end
