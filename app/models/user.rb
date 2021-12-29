class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,:authentication_keys => [:user]
	#belongs_to :catalog_role
	has_many :one_signal_device
	has_and_belongs_to_many :catalog_branches
	validates :user, length: { maximum: 15 }
	has_many :catalog_branches_user
	has_many :catalog_roles_users
	has_many :catalog_roles, through: :catalog_roles_users
	has_many :permissions, through: :catalog_roles
	has_many :catalog_licences
	has_many :catalog_workshops
	has_many :vehicle_logs
	has_one :catalog_personal

	class << self
		def current_user=(user)
		  	Thread.current[:current_user] = user
		end
	
		def current_user
		  	Thread.current[:current_user]
		end
	end

	def ability
		@ability ||= Ability.new(self)
	end
	  delegate :can?, :cannot?, :to => :ability

	def datoscombo
		"#{self.name} - #{self.email} "
	end

	def nombre_completo
		"#{self.name} #{self.last_name}"
	end

	def self.listado_usuarios
		User.all.order(name: :asc)
	end

	#tabla de competencias
	def self.listado_competencias(consumption)
		competencia = CompetitionTable.where("catalog_branch_id = #{consumption.catalog_branch_id} and monto >= #{consumption.monto} and tipo = 'Combustible'").order(monto: :asc)
		monto_competencia = competencia.first
		User.joins(:catalog_roles).joins(:catalog_branches_users).where("catalog_roles.nombre = '#{monto_competencia.catalog_role.nombre}' and catalog_branches_users.catalog_branch_id = #{consumption.catalog_branch_id}")   
	end
	
	def correo_ordenes
		# if   self.email != nil and  self.email != ''
		array_correo = self.email.split("@")
		if array_correo[1] == "gafi.com.mx"
			return array_correo[0]
		else
			return "MVELAZQUE"
			 #return "DYENCALADA"
		end
		 # else
		 #     return "DYENCALADA"
		 # end
	end
end
