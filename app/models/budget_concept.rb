class BudgetConcept < ApplicationRecord
    belongs_to :catalog_area
    belongs_to :catalog_branch
    has_many :budget_details
    enum status: ["Pendiente", "Por autorizar", "Autorizado", "Rechazado","Orden Capturada"]
    validates :clave, uniqueness: true
    def self.crear_pres(params)
        id_registro = 0
        bandera_error = 0
        mensaje = ""
        begin
            if params[:budget_concept][:clave] == "" and params[:budget_concept][:catalog_branch_id]== "" and params[:budget_concept][:fecha_entrega]== "" and params[:budget_concept][:catalog_area_id]== "" and params[:budget_concept][:fecha]== ""
              bandera_error =  1
            else
                presupuesto = BudgetConcept.new(clave:params[:budget_concept][:clave],catalog_branch_id:params[:budget_concept][:catalog_branch_id],fecha_entrega: params[:budget_concept][:fecha_entrega],catalog_area_id:params[:budget_concept][:catalog_area_id],fecha:params[:budget_concept][:fecha],status:0)
            end 
            if presupuesto.save 
                bandera_error = 4
                id_registro= presupuesto.id
            else
                presupuesto.errors.full_messages.each do |error|
                    bandera_error = 2
                end
            end
        rescue Exception => error 
            bandera_error = 3
        end
        return  bandera_error, id_registro
    end

end
