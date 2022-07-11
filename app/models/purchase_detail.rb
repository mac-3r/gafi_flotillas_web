class PurchaseDetail < ApplicationRecord
  belongs_to :vehicle_type
  belongs_to :catalog_model
  belongs_to :catalog_brand
  belongs_to :purchase_order
  belongs_to :budget_item, class_name: 'BudgetItem', foreign_key: :budget_detail_id, optional: true
  belongs_to :catalog_tires_battery, optional: true

  def self.detalle(params,orden)
    bandera_error = 0
    mensaje = ""
    registro_orden = PurchaseOrder.find_by(id: orden)
    if registro_orden
      if params[:purchase_detail][:cantidad] == "" and params[:catalog_brand_id] == "" and params[:catalog_model_id] == "" and params[:vehicle_type_id]  == "" and params[:purchase_detail][:precio]  == "" and params[:purchase_detail][:total_detalle]  == "" and params[:purchase_detail][:catalog_tires_battery_id] == ""
        bandera_error = 1
        mensaje = "completa los datos"
      else
        begin
          detalle = PurchaseDetail.new(purchase_order_id:registro_orden.id,cantidad: params[:purchase_detail][:cantidad],catalog_brand_id:params[:catalog_brand_id],vehicle_type_id:params[:vehicle_type_id],catalog_model_id:params[:catalog_model_id], catalog_tires_battery_id: params[:purchase_detail][:catalog_tires_battery_id],precio:params[:purchase_detail][:precio],total_detalle:params[:purchase_detail][:total_detalle])
          if detalle.save
            # Calculando de nuevo los totales de la orden -----------------------------------------
            nuevo_subtotal = registro_orden.purchase_details.sum(:total_detalle)
            nuevo_iva = (nuevo_subtotal*0.16)
            nuevo_total = (nuevo_subtotal+nuevo_iva)
            registro_orden.update(subtotal: nuevo_subtotal, monto_iva: nuevo_iva, total: nuevo_total )
            # Calculando de nuevo los totales de la orden -----------------------------------------
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
