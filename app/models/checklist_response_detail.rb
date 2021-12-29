class ChecklistResponseDetail < ApplicationRecord
    belongs_to :checklist_response
    belongs_to :vehicle_checklist
    enum estatus: ["BUEN ESTADO", "MAL ESTADO","NO SE RECIBE"] 
end
