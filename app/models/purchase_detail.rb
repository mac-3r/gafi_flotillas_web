class PurchaseDetail < ApplicationRecord
  belongs_to :vehicle_type
  belongs_to :catalog_model
  belongs_to :catalog_brand
  belongs_to :purchase_order
  belongs_to :budget_item, class_name: 'BudgetItem', foreign_key: :budget_detail_id, optional: true

  def self.detalle(params,orden)
    bandera_error = 0
    mensaje = ""
    registro_orden = PurchaseOrder.find_by(id: orden)
    if registro_orden
      if params[:purchase_detail][:cantidad] == "" and params[:catalog_brand_id] == "" and params[:catalog_model_id] == "" and params[:vehicle_type_id]  == "" and params[:purchase_detail][:precio]  == "" and params[:purchase_detail][:total_detalle]  == ""
        bandera_error = 1
        mensaje = "completa los datos"
      else
        begin
          detalle = PurchaseDetail.new(purchase_order_id:registro_orden.id,cantidad: params[:purchase_detail][:cantidad],catalog_brand_id:params[:catalog_brand_id],vehicle_type_id:params[:vehicle_type_id],catalog_model_id:params[:catalog_model_id],precio:params[:purchase_detail][:precio],total_detalle:params[:purchase_detail][:total_detalle])
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
    return mensaje, bandera_error, orden
  end
end
