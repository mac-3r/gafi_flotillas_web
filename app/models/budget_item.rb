class BudgetItem < ApplicationRecord
	belongs_to :catalog_branch
	belongs_to :catalog_area
	belongs_to :budget
	belongs_to :catalog_brand
	belongs_to :reason
	belongs_to :vehicle_type
	belongs_to :catalog_model
	belongs_to :user
	enum estatus_autorizacion: ["Rechazado","Pendiente", "Por autorizar", "Autorizado","Orden Capturada"]
	has_one :purchase_detail, class_name: 'PurchaseDetail', foreign_key: :budget_detail_id

	def self.registrar_concepto(params, usuario)
		bandera_error = false
		texto = ""
		begin
			existente = BudgetItem.find_by(budget_id: params[:budget_item][:budget_id], estatus_autorizacion: [ "Por autorizar", "Autorizado","Orden Capturada"], catalog_area_id: params[:budget_item][:catalog_area_id])
			if existente
				bandera_error = true
				texto = "El presupuesto para esta área ya fue autorizado o fue envíado a autorizar y ya no se puede modificar."
			else
				concepto = BudgetItem.new(
					cantidad: 						 params[:budget_item][:cantidad], 
					vehicle_type_id: 			params[:budget_item][:vehicle_type_id],
					catalog_branch_id: 		  params[:budget_item][:catalog_branch_id],
					catalog_area_id: 			params[:budget_item][:catalog_area_id],
					catalog_brand_id: 		   params[:budget_item][:catalog_brand_id],
					catalog_model_id: 		   params[:budget_item][:catalog_model_id],
					reason_id: 					    params[:budget_item][:reason_id],
					user_id: 						 usuario,
					budget_id:                     params[:budget_item][:budget_id],
					importe:                         params[:budget_item][:importe].to_f + (params[:budget_item][:importe].to_f * 0.16),
					plaqueo:                         params[:budget_item][:plaqueo],
					seguro:                          params[:budget_item][:seguro],
					muelle:                           params[:budget_item][:muelle],
					caja:                              params[:budget_item][:caja],
					rotulacion:                     params[:budget_item][:rotulacion],
					lona:                              params[:budget_item][:lona]
				)
				if concepto.save
					texto = "Concepto registrado con éxito."
				else
					bandera_error = true
					concepto.errors.full_messages.each do |error|
						texto += "#{error}. "
					end
				end
			end
		rescue ActiveRecord::Rollback => e
			bandera_error = true
			texto += "#{e}"
		rescue ActiveRecord::RecordInvalid => e
			bandera_error = true
			texto += "#{e}"
		rescue => exception
			bandera_error = true
			texto += "Error interno del sistema: #{error}. Favor de contactar a soporte."
			texto += "Favor de contactar a soporte. Error: #{exception}."
		end
		return bandera_error, texto
	end

	def self.editar_concepto(params, usuario)
		bandera_error = false
		texto = ""
		begin
			existente = BudgetItem.find_by(budget_id: params[:budget_item][:budget_id], estatus_autorizacion: [ "Pendiente", "Rechazado"], catalog_area_id: params[:budget_item][:catalog_area_id])
			if existente
				if existente.update(
					cantidad: 						 params[:budget_item][:cantidad], 
					vehicle_type_id: 			params[:budget_item][:vehicle_type_id],
					catalog_branch_id: 		  params[:budget_item][:catalog_branch_id],
					catalog_area_id: 			params[:budget_item][:catalog_area_id],
					catalog_brand_id: 		   params[:budget_item][:catalog_brand_id],
					catalog_model_id: 		   params[:budget_item][:catalog_model_id],
					reason_id: 					    params[:budget_item][:reason_id],
					user_id: 						 usuario,
					budget_id:                     params[:budget_item][:budget_id],
					importe:                         params[:budget_item][:importe].to_f + (params[:budget_item][:importe].to_f * 0.16),
					plaqueo:                         params[:budget_item][:plaqueo],
					seguro:                          params[:budget_item][:seguro],
					muelle:                           params[:budget_item][:muelle],
					caja:                              params[:budget_item][:caja],
					rotulacion:                     params[:budget_item][:rotulacion],
					lona:                              params[:budget_item][:lona]
				)
					texto = "Concepto actualizado con éxito."
				else
					bandera_error = true
					concepto.errors.full_messages.each do |error|
						texto += "#{error}. "
					end
				end
			else
				bandera_error = true
				texto = "El presupuesto no existe, ya fue autorizado o fue envíado a autorizar y ya no se puede modificar."
			end
		rescue ActiveRecord::Rollback => e
			bandera_error = true
			texto += "#{e}"
		rescue ActiveRecord::RecordInvalid => e
			bandera_error = true
			texto += "#{e}"
		rescue => exception
			bandera_error = true
			texto += "Error interno del sistema: #{error}. Favor de contactar a soporte."
			texto += "Favor de contactar a soporte. Error: #{exception}."
		end
		return bandera_error, texto
	end
end
