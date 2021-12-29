class ApplicationController < ActionController::Base
	before_action :authenticate_user!,:checar_cedis, :set_current_user,:comprobar_taller

	
	def set_current_user
		User.current_user = current_user
	end
	
	def checar_cedis
		if current_user.present?
			@usuario_cedis = CatalogBranchesUser.where(user_id: current_user.id).first
			#byebug
		end
	end

	def comprobar_taller
		if current_user.present?
			#byebug
			taller = CatalogWorkshop.find_by(user_id: current_user.id)
			if taller
				session["taller"] = taller.id
			end
		end 
	end

    rescue_from CanCan::AccessDenied do |exception|
		respond_to do |format|
			format.json { head :forbidden }
			format.html { redirect_to root_url, :alert => "No tienes permiso para acceder a esta sección." }
		end
	end
end
