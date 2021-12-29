class BudgetDistributionDetail < ApplicationRecord
  belongs_to :budget_distribution
  belongs_to :catalog_brand
  belongs_to :catalog_model
  belongs_to :vehicle_type
  belongs_to :reason

  def self.detalle(params,presupuesto)
    bandera_error = 0
    mensaje = ""
    registro_presupuesto = BudgetDistribution.find_by(id: presupuesto)
    if registro_presupuesto
      if params[:budget_distribution_detail][:cantidad] == "" and params[:budget_distribution_detail][:catalog_brand_id] == "" and params[:budget_distribution_detail][:reason_id] == "" and params[:budget_distribution_detail][:importe]
        bandera_error = 1
        mensaje = "completa los datos"
      else
        begin
          detalle = BudgetDistributionDetail.new(budget_distribution_id:registro_presupuesto.id,cantidad: params[:budget_distribution_detail][:cantidad],catalog_brand_id:params[:catalog_brand_id],reason_id:params[:reason_id],importe:params[:budget_distribution_detail][:importe],plaqueo:params[:budget_distribution_detail][:plaqueo],seguro:params[:budget_distribution_detail][:seguro],
            muelle:params[:budget_distribution_detail][:muelle],caja:params[:budget_distribution_detail][:caja],rotulacion:params[:budget_distribution_detail][:rotulacion],lona:params[:budget_distribution_detail][:lona],vehicle_type_id:params[:vehicle_type_id],catalog_model_id:params[:catalog_model_id])
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
