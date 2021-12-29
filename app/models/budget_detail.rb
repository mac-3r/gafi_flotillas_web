class BudgetDetail < ApplicationRecord
  belongs_to :budget_concept
  belongs_to :catalog_brand
  belongs_to :catalog_model
  belongs_to :vehicle_type
  belongs_to :reason

  def self.detalle(params,presupuesto)
    bandera_error = 0
    mensaje = ""
    registro_presupuesto = BudgetConcept.find_by(id: presupuesto)
    if registro_presupuesto
      if params[:budget_detail][:cantidad] == "" and params[:budget_detail][:catalog_brand_id] == "" and params[:budget_detail][:reason_id] == "" and params[:budget_detail][:importe]
        bandera_error = 1
        mensaje = "completa los datos"
      else
        begin
          detalle = BudgetDetail.new(budget_concept_id:registro_presupuesto.id,cantidad: params[:budget_detail][:cantidad],catalog_brand_id:params[:catalog_brand_id],reason_id:params[:reason_id],importe:params[:budget_detail][:importe],plaqueo:params[:budget_detail][:plaqueo],seguro:params[:budget_detail][:seguro],vehicle_type_id:params[:vehicle_type_id],catalog_model_id:params[:catalog_model_id])
          if detalle.save
            bandera_error = 4
            mensaje = "Registro correcto"
          else
            bandera_error = 3
            detalle.errors.full_messages.each do |error|
              mensaje += error
            end
          end
        rescue Exception=> error
          mensaje += "Ocurrio un error desconocido #{error}"
            bandera_error = 3
        end
      end
    else
      bandera_error = 1
      mensaje = "No se encontró el registro seleccionado."
    end
    return mensaje, bandera_error, presupuesto
  end
end
