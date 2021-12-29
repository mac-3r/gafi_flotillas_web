class BudgetAdministration < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_area
  validates :clave, uniqueness: true
  has_many :budget_administration_details
  enum status: ["Pendiente", "Por autorizar", "Autorizado", "Rechazado","Orden Capturada"]

  def self.crear_pres(params)
    id_registro = 0
    bandera_error = 0
    mensaje = ""
    begin
        if params[:budget_administration][:clave] == "" and params[:budget_administration][:catalog_branch_id]== "" and params[:budget_administration][:fecha_entrega]== "" and params[:budget_administration][:catalog_area_id]== "" and params[:budget_administration][:fecha_compra]== ""
          bandera_error =  1
        else
            presupuesto = BudgetAdministration.new(clave:params[:budget_administration][:clave],catalog_branch_id:params[:budget_administration][:catalog_branch_id],fecha_entrega: params[:budget_administration][:fecha_entrega],catalog_area_id:params[:budget_administration][:catalog_area_id],fecha_compra:params[:budget_administration][:fecha_compra],status:0)
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
