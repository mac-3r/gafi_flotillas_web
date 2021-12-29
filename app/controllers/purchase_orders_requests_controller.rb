class PurchaseOrdersRequestsController < ApplicationController
    authorize_resource :class => false
	before_action :validacion_menu
	def index
		@purchase_orders = PurchaseOrder.where(status: "Pendiente de autorizar")
	end

	def autorizar
		orden = PurchaseOrder.find_by(id: params[:id_orden], status: "Pendiente de autorizar")
		firma_autorizante = UserSignature.find_by(user_id: current_user.id)
		if orden
			begin
				if firma_autorizante
					if orden.update(status: "Autorizado",user_id: current_user.id)
						flash[:notice] = "Orden de compra autorizada con éxito"
					else
						mensaje = "Ocurrió un error: "
						orden.errors.full_messages.each do |error|
							mensaje += "#{error}"
						end
						flash[:alert] = mensaje
					end
				else
					flash[:alert] = "No se encontró la firma, favor de registrar firma."
				end
			rescue => exception
				flash[:alert] = "Error interno del sistema: #{exception}. Favor de contactar a soporte."
			end
		else
			flash[:alert] = "No se encontró la orden de compra o no se encuentra disponible para autorizar."
		end
		redirect_to purchase_orders_requests_path
	end

	def modal_rechazar
		@bandera_error = false
		orden = PurchaseOrder.find_by(id: params[:id_orden], status: "Pendiente de autorizar")
		if orden
			@purchase_order = orden
		else
			@bandera_error = true
			@mensaje = "No se encontró la orden de compra o no se encuentra disponible para autorizar."
		end
	end

	def rechazar_orden_compra
		orden = PurchaseOrder.find_by(id: params[:purchase_order][:id], status: "Pendiente de autorizar")
		if orden
			if orden.update(motivo: params[:purchase_order][:motivo], status: "Rechazado")
				flash[:notice] = "Orden de compra rechazada con éxito."
				redirect_to purchase_orders_requests_path
			else
				@mensaje = ""
				orden.errors.full_messages.each do |error|
					@mensaje += "#{error}. "
				end
				respond_to do |format|
					format.js
				end
			end
		else
			@bandera_error = 1
			@mensaje = "No se encontró la orden de compra o no se encuentra disponible para autorizar."
			respond_to do |format|
				format.js
			end
		end
	end

	private
		def validacion_menu
			session["menu1"] = "Maestro de vehículos"
			session["menu2"] = "Autorización de ordenes de compra"
		end
end