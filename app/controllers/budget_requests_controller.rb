class BudgetRequestsController < ApplicationController
	before_action :validacion_menu

	def index
		@anios = Budget.all.order(anio: :desc)
		@secciones = Section.where(status: true)
	end

	def show
	end

	def accept_budget_request
		seccion = Section.find_by(id: params[:section_id])
		areas = seccion.catalog_areas_sections
		@budget = BudgetItem.where(budget_id: params[:budget_id], catalog_area_id: areas.map{|x| x.catalog_area_id}, estatus_autorizacion: "Por autorizar")
		if @budget
		  	if @budget.update_all(estatus_autorizacion: "Autorizado")
				flash[:notice] = "Solicitud autorizada con éxito"
				redirect_to budget_requests_path
			else
				texto = "Ocurrió un error: "
				@budget.errors.full_messages.each do |error|
					texto += "#{error}. "
				end
				flash[:alert] = texto
				redirect_to budget_requests_path
			end
		else
			flash[:alert] = "No se encontró el registro."
			redirect_to budgets_path
		end
	end

	def reject_budget_request
		seccion = Section.find_by(id: params[:section_id])
		areas = seccion.catalog_areas_sections
		@budget = BudgetItem.where(budget_id: params[:budget_id], catalog_area_id: areas.map{|x| x.catalog_area_id}, estatus_autorizacion: "Por autorizar")
		if @budget
		  	if @budget.update_all(estatus_autorizacion: "Rechazado")
				flash[:notice] = "Solicitud rechazada con éxito"
				redirect_to budget_requests_path
			else
				texto = "Ocurrió un error: "
				@budget.errors.full_messages.each do |error|
					texto += "#{error}. "
				end
				flash[:alert] = texto
				redirect_to budget_requests_path
			end
		else
			flash[:alert] = "No se encontró el registro."
			redirect_to budgets_path
		end
	end

	def show_budget_requests_concepts
		@presupuesto = params[:budget_id]
		@area = params[:section_id]
		@budget = Budget.find_by(id: params[:budget_id])
		seccion = Section.find_by(id: @area)
		areas = seccion.catalog_areas_sections
		@budget_items = BudgetItem.where(budget_id: params[:budget_id], catalog_area_id: areas.map{|x| x.catalog_area_id})
	end

	private
	def validacion_menu
		session["menu1"] = "Maestro de vehículos"
		session["menu2"] = "Autorización de Presupuestos"
	  end
end
