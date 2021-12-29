class BudgetsController < ApplicationController
	before_action :set_budget, only: [:show, :edit, :update, :add_item_budget, :request_budget]
	#load_and_authorize_resource
	before_action :validacion_menu

	def index
		@budget_distributions = Budget.all
	end

	def show
		@presupuesto = @budget.id
		@area = "0"
		@budget_items = @budget.budget_items
		@areas = Section.where(status: true)
	end

	def new
		@budget = Budget.new
	end

	def create
		@budget = Budget.new(anio: params[:budget][:anio], estatus: 1)
		if @budget.save
			redirect_to edit_budget_path(@budget.id)
		else
			@texto = ""
			@budget.errors.full_messages.each do |error|
				@texto = "#{error}. "
			end
		end
	end

	def edit
		@budget = Budget.find_by(id: params[:id])
		if @budget
			@budget_items = @budget.budget_items
		else
			flash[:alert] = "No se encontró el año de presupuesto seleccionado."
			redirect_to budgets_path
		end
	end

	def add_item_budget
		@bandera_error = false
		@budget = Budget.find_by(id: params[:id])
		if @budget
			@budget_item = BudgetItem.new
		else
			@bandera_error = true
			@texto = "No se encontró el año de presupuesto seleccionado."
		end
	end

	def save_item_budget
		@budget_item = BudgetItem.registrar_concepto(params, current_user.id)
		@bandera_error = @budget_item[0]
		@texto = @budget_item[1]
		if !@bandera_error 
			@budget = Budget.find_by(id: params[:budget_item][:budget_id])
			if @budget
				@budget_items = @budget.budget_items
			else
				flash[:alert] = "No se encontró el año de presupuesto seleccionado."
				redirect_to budgets_path
			end
		end
	end

	def edit_item_budget
		@bandera_error = false
		@texto = ""
		@budget_item = BudgetItem.joins(:budget).find_by(id: params[:id_budget_item], budget_id: params[:id_budget], budgets: {estatus: ["Pendiente", "Rechazado"]})
		if @budget_item
			@budget = @budget_item.budget
			if @budget_item.estatus_autorizacion == "Pendiente" or @budget_item.estatus_autorizacion == "Rechazado"
				# if @budget_item.destroy
				# 	@texto = "Concepto eliminado con éxito"
				# 	@budget_items = @budget.budget_items
				# else
				# 	@budget_item.errors.full_messages.each do |error|
				# 		@texto += "#{error}. "
				# 	end
				# 	@bandera_error = true
				# end
			else
				@bandera_error = true
				@texto = "El concepto ya fue autorizado o se encuentra en proceso de autorización y no se puede modificar."
			end
		else
			@bandera_error = true
			@texto = "No se encontró el concepto o ya no se puede modificar."
		end
	end

	def update_item_budget
		@budget_item = BudgetItem.editar_concepto(params, current_user.id)
		@bandera_error = @budget_item[0]
		@texto = @budget_item[1]
		if !@bandera_error 
			@budget = Budget.find_by(id: params[:budget_item][:budget_id])
			if @budget
				@budget_items = @budget.budget_items
			else
				flash[:alert] = "No se encontró el año de presupuesto seleccionado."
				redirect_to budgets_path
			end
		end
	end

	def update
	
	end

	def destroy
		@bandera_error = false
		@texto = ""
		@budget_item = BudgetItem.joins(:budget).find_by(id: params[:id_budget_item], budget_id: params[:id_budget], budgets: {estatus: ["Pendiente", "Rechazado"]})
		if @budget_item
			@budget = @budget_item.budget
			if @budget_item.estatus_autorizacion == "Pendiente" or @budget_item.estatus_autorizacion == "Rechazado"
				if @budget_item.destroy
					@texto = "Concepto eliminado con éxito"
					@budget_items = @budget.budget_items
				else
					@budget_item.errors.full_messages.each do |error|
						@texto += "#{error}. "
					end
					@bandera_error = true
				end
			else
				@bandera_error = true
				@texto = "El concepto ya fue autorizado o se encuentra en proceso de autorización y no se puede eliminar."
			end
		else
			@bandera_error = true
			@texto = "No se encontró el concepto o ya no se puede modificar."
		end
	end

	def request_budget
		seccion = Section.find_by(id: params[:area_id])
		areas = seccion.catalog_areas_sections
		@budget = BudgetItem.where(budget_id: params[:id], catalog_area_id: areas.map{|x| x.catalog_area_id}, estatus_autorizacion: ["Pendiente", "Rechazado"])
		if @budget
		  	if @budget.update_all(estatus_autorizacion: "Por autorizar", fecha_solicitud: (Time.zone.now).to_date)
				flash[:notice] = "Solicitud enviada con éxito"
				redirect_to show_budget_path(params[:id])
			else
				texto = "Ocurrió un error: "
				@budget.errors.full_messages.each do |error|
					texto += "#{error}. "
				end
				flash[:alert] = texto
				redirect_to show_budget_path(params[:id])
			end
		else
			flash[:alert] = "No se encontró el registro."
			redirect_to budgets_path
		end
	end

	def search_by_area
		@presupuesto = params[:budget_id]
		@area = params[:area_id]
		@budget = Budget.find_by(id: params[:budget_id])
		if params[:area_id] == "0" or params[:area_id].nil?
			@budget_items = BudgetItem.where(budget_id: params[:budget_id])
		else
			seccion = Section.find_by(id: @area)
			areas = seccion.catalog_areas_sections
			@budget_items = BudgetItem.where(budget_id: params[:budget_id], catalog_area_id: areas.map{|x| x.catalog_area_id})
		end
	end

	def pdf_presupuestos
		if params[:area_id] == "" or params[:area_id] == "0"
			@budget_items = BudgetItem.where(budget_id: params[:budget_id])
		else
			seccion = Section.find_by(id: params[:area_id])
			areas = seccion.catalog_areas_sections
			@budget_items = BudgetItem.where(budget_id: params[:budget_id], catalog_area_id: areas.map{|x| x.catalog_area_id})
		end
	end

	private
	def validacion_menu
		session["menu1"] = "Maestro de vehículos"
		session["menu2"] = "Presupuestos"
	  end
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      	@budget = Budget.find_by(id: params[:id])
    end

end
