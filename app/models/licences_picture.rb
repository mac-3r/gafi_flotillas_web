class LicencesPicture < ApplicationRecord
    has_one_attached :imagen
    def self.insertar_imagen(params)
        vehicle_id = params[:vehicle_id]
        user_id = params[:user_id]
        catalog_licence_id = params[:catalog_licence_id]
             @bandera = true
             params[:imagenes].each do |img| 
            imagen_existe =  self.where(tipo: img[:tipo],user_id: user_id, vehicle_id: vehicle_id )
            if imagen_existe != nil
                imagen_existe.destroy_all
            end
                user = User.find(params[:user_id])
                bas64 = img[:imagen].gsub(' ', '+')
                decoded_data = Base64.decode64(bas64.split(',')[1])
                        imagen = { 
                        io: StringIO.new(decoded_data),
                        filename: "licencia_#{user.name}_#{user.last_name}_#{Date.today.strftime('%y%m%d')}.png",
                        content_type: 'image/png'
                        }
                       insertar =   self.new(imagen:imagen, tipo: img[:tipo], user_id: user_id, vehicle_id: vehicle_id, catalog_licence_id: catalog_licence_id)
                      if !insertar.save
                        @bandera = false
                        end
                    end
                return @bandera
        end
end