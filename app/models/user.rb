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

	def correo_combustibles
		# if   self.email != nil and  self.email != ''
		   array_correo = self.email.split("@")
		   if array_correo[1] == "gafi.com.mx"
			 return array_correo[0].upcase
		   else
			 return "MVELAZQUE"
		   end
		 # else
		 #     return "DYENCALADA"
		 # end
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

	def self.importar_usuarios(file)
		spreadsheet = Roo::Spreadsheet.open(file.path)
		header = spreadsheet.row(1)
		arreglo_errores = Array.new
		arreglo_operaciones = Array.new
		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			begin
				if row["Razón Social"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó razón social.")
					next
				end
				if row["Unidad de Negocio"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó la unidad de negocio.")
					next
				end
				if row["Localidad"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó la localidad.")
					next
				end
				if row["División"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó la división.")
					next
				end
				if row["Departamento"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el departamento.")
					next
				end
				if row["Tipo de Posición"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el tipo de posición.")
					next
				end
				if row["Nivel Jerárquico"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el nivel jerárquico.")
					next
				end
				if row["Posición"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó la posición.")
					next
				end
				if row["Género"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el género.")
					next
				end
				if row["Numero de Empleado"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el número de empleado.")
					next
				end
				if row["Nombre"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el nombre.")
					next
				end
				if row["Apellido Paterno"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el apellido paterno.")
					next
				end
				if row["Apellido Materno"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el apellido materno.")
					next
				end
				if row["Fecha de Ingreso"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó la fecha de ingreso.")
					next
				end
				if row["RFC"] == "" or row["RFC"] == nil
					#arreglo_errores.push(linea: i, error: "No se ingresó el RFC.")
					next
				end
				if row["CURP"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó la CURP.")
					next
				end
				if row["IMSS"] == ""
					arreglo_errores.push(linea: i, error: "No se ingresó el IMSS.")
					next
				end
				busca_empleado = CatalogPersonal.find_by(rfc: row["RFC"])
				if busca_empleado
					empleado = busca_empleado
				else
					split_nombre = row["Nombre"].split("")
					split_apellido = (row["Apellido Paterno"].gsub(" ", "")).split("")
					split_apellido.length > 8 ? correo_format = ("#{split_nombre[0]}#{split_apellido[0]}#{split_apellido[1]}#{split_apellido[2]}#{split_apellido[3]}#{split_apellido[4]}#{split_apellido[5]}#{split_apellido[6]}#{split_apellido[7]}").downcase  : correo_format = ("#{split_nombre[0]}#{row["Apellido Paterno"]}").downcase
					correo_format += "@gafi.com.mx"
					empleado = CatalogPersonal.new(clave: row["Numero de Empleado"], nombre: "#{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}", rfc: row["RFC"], correo: correo_format, estatus: 1)
					if empleado.save
						arreglo_operaciones.push(linea: i, error: "Se registró el empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]} con id #{empleado.id}.")
					else
						mensaje = ""
						empleado.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						arreglo_errores.push(linea: i, error: "No se pudo registrar el empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}: #{mensaje}.")
						next
					end
				end
				busca_responsable = Responsable.where("nombre ilike '%#{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}%'")
				if busca_responsable.length == 1
					responsable = busca_responsable.first
					if responsable.update(catalog_personal_id: empleado.id)
						arreglo_operaciones.push(linea: i, error: "Se asignó al responsable #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]} con id #{responsable.id} el empleado existente con id #{empleado.id}.")
					else
						mensaje = ""
						responsable.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						arreglo_errores.push(linea: i, error: "No se pudo generar el responsable del empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}: #{mensaje}.")
						next
					end
				else
					responsable = Responsable.new(nombre: "#{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}", status: 1, catalog_personal_id: empleado.id)
					if responsable.save
						arreglo_operaciones.push(linea: i, error: "Se asignó al responsable #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]} con id #{responsable.id} el empleado existente con id #{empleado.id}.")
					else
						mensaje = ""
						responsable.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						arreglo_errores.push(linea: i, error: "No se pudo generar el responsable del empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}: #{mensaje}.")
						next
					end
				end
				busca_usuario = User.find_by(user: row["RFC"].downcase)
				if busca_usuario
					if empleado.update(user_id: busca_usuario.id)
						arreglo_operaciones.push(linea: i, error: "Se asignó al empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]} con id #{empleado.id} el usuario existente #{busca_usuario.user} con id #{busca_usuario.id}.")
					else
						mensaje = ""
						empleado.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						arreglo_errores.push(linea: i, error: "No se pudo generar el usuario del empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}: #{mensaje}.")
						next
					end
				else
					usuario = User.new(name: row["Nombre"], last_name: "#{row["Apellido Paterno"]} #{row["Apellido Materno"]}", email: empleado.correo, user: row["RFC"].downcase, password: row["RFC"].downcase)
					if usuario.save
						if empleado.update(user_id: usuario.id)
							arreglo_operaciones.push(linea: i, error: "Se asignó al empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]} con id #{empleado.id} el usuario nuevo #{busca_usuario.user} con id #{busca_usuario.id}.")
						else
							mensaje = ""
							empleado.errors.full_messages.each do |error|
								mensaje += "#{error}. "
							end
							arreglo_errores.push(linea: i, error: "No se pudo generar el usuario del empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}: #{mensaje}.")
							next
						end
					else
						mensaje = ""
						usuario.errors.full_messages.each do |error|
							mensaje += "#{error}. "
						end
						arreglo_errores.push(linea: i, error: "No se pudo generar el usuario del empleado #{row["Apellido Paterno"]} #{row["Apellido Materno"]} #{row["Nombre"]}: #{mensaje}.")
						next
					end
				end
			rescue Exception => e
				arreglo_errores.push(linea: i, error: "#{e}")
			end
		end
		if arreglo_errores.length > 0
			return arreglo_errores, arreglo_operaciones
		else
			return nil, arreglo_operaciones
		end
	end
	
	def self.nombre_auxiliar_flotilla(catalog_branch_id)
		usuario = User.joins(:catalog_branches_users, :catalog_roles_users).where(catalog_roles_users: {catalog_role_id: 6}, catalog_branches_users: {catalog_branch_id: catalog_branch_id})	
		if usuario.length > 0
			return "#{usuario.first.nombre_completo}"
		else
			return "Auxiliar de flotilla"
		end	
	end
	
end
