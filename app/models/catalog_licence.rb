class CatalogLicence < ApplicationRecord
    belongs_to :vehicle
    belongs_to :user
    has_one_attached :anverso
    has_one_attached :reverso

    validates :clave, uniqueness: true
    validates :clave,:descripcion, :fecha_vencimiento, presence: true

    after_create :vehicle_log_create

    def self.consulta_licencias(usuario,vehiculo)
        cadena_consulta = ""
          if usuario != "" and vehiculo != ""
            cadena_consulta += " user_id = #{usuario} and vehicle_id = #{vehiculo}"
          elsif  vehiculo != "" and usuario == ""
            cadena_consulta += " vehicle_id = #{vehiculo}"
          elsif  vehiculo == "" and usuario != ""
            cadena_consulta += " user_id = #{usuario}"
          else
            cadena_consulta = ""
          end

          if cadena_consulta != ""
            consulta = CatalogLicence.joins(:user).where(cadena_consulta).order(name: :asc)
          else
            consulta = CatalogLicence.joins(:user).all.order(name: :asc)
          end

          return consulta  
    end
    def self.adjuntar_fotos_anverso(params,encabezado)
        bandera_error = 0
        mensaje = ""
        h = Hash.new
        busqueda_enc = CatalogLicence.find_by(id: encabezado)
        buscar_archivo = LicencesPicture.find_by(catalog_licence_id: busqueda_enc.id,tipo:"Frontal")
      begin
        if busqueda_enc
            if busqueda_enc.update(anverso: params[:catalog_licence][:anverso])
                if buscar_archivo
                    adjuntar = buscar_archivo.update(imagen:params[:catalog_licence][:anverso])
                else
                    adjuntar = LicencesPicture.create(catalog_licence_id: busqueda_enc.id,imagen:params[:catalog_licence][:anverso],tipo:"Frontal",vehicle_id: busqueda_enc.vehicle_id,user_id: busqueda_enc.user_id)
                end
                 if adjuntar
                  bandera_error = 4
                  mensaje = "Fotografías agregadas correctamente."  
                 else
                  bandera_error = 3
                  mensaje = "Ocurrio un error al enviar fotografia."  
                 end                      
              else
                  documento.errors.full_messages.each do |error|
                      mensaje += " #{error}."
                  end
                  bandera_error = 3
              end
          else
              bandera_error = 1
              mensaje = "No se encontró el registro del encabezado."
          end
      rescue Exception => error
          mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
          bandera_error = 3
      end
      return mensaje,bandera_error
    end

    def self.adjuntar_fotos_reverso(params,encabezado)
        bandera_error = 0
        mensaje = ""
        h = Hash.new
        busqueda_enc = CatalogLicence.find_by(id: encabezado)
        buscar_archivo = LicencesPicture.find_by(catalog_licence_id: busqueda_enc.id,tipo:"Trasera")
      begin
        if busqueda_enc
            if busqueda_enc.update(reverso: params[:catalog_licence][:reverso])
                if buscar_archivo
                    adjuntar = buscar_archivo.update(imagen:params[:catalog_licence][:reverso])
                else
                    adjuntar = LicencesPicture.create(catalog_licence_id: busqueda_enc.id,imagen:params[:catalog_licence][:reverso],tipo:"Trasera",vehicle_id: busqueda_enc.vehicle_id,user_id: busqueda_enc.user_id)
                end
                 if adjuntar
                  bandera_error = 4
                  mensaje = "Fotografías agregadas correctamente."  
                 else
                  bandera_error = 3
                  mensaje = "Ocurrio un error al enviar fotografia."  
                 end                      
              else
                  documento.errors.full_messages.each do |error|
                      mensaje += " #{error}."
                  end
                  bandera_error = 3
              end
          else
              bandera_error = 1
              mensaje = "No se encontró el registro del encabezado."
          end
      rescue Exception => error
          mensaje = "Error interno del sistema: #{error}. Favor de contactar a soporte."
          bandera_error = 3
      end
      return mensaje,bandera_error
    end

    def vehicle_log_create
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó la licencia del usuario #{self.user.name} #{self.user.last_name} con el vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
    end

    def self.licencias_expirar(company, branch, area, vehicle)
        cadena = ""
        if company != "" and company != nil
            cadena += " vehicles.catalog_company_id = #{company} and"
        end
        if branch != "" and branch != nil
            cadena += " vehicles.catalog_branch_id = #{branch} and"
        end
        if area != "" and area != nil
            cadena += " vehicles.catalog_area_id = #{area} and"
        end
        if vehicle != "" and vehicle != nil
            cadena += " catalog_licences.vehicle_id = #{vehicle} and"
        end
        return @licencias = CatalogLicence.joins(:vehicle).where("#{cadena} fecha_vencimiento <= ?", Time.zone.now.to_date.end_of_month).order(fecha_vencimiento: :asc)
    end

    def self.envio_correo_licencias_expirar
        if Time.zone.now.to_date.beginning_of_month == Time.zone.now.to_date
            valor = ""
            contador = 0
            parametro = Parameter.find_by(valor: "correos gerente cedis")
            rol = CatalogRole.find_by(clave: parametro.valor_extendido)
            usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
            usuarios_gerentes.each do |user|
                contador += 1
                IndicatorMailer.licencias_x_expirar().deliver_later(wait: (20 * contador).seconds) if contador == 1
            end
        end
    end
    
    
end
