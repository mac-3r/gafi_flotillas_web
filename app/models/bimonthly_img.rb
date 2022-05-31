class BimonthlyImg< ApplicationRecord
       
        has_one_attached :imagen
       
        def self.insertar_imagen(params)
        vehicle_id = params[:vehicle_id]
        bimonthly_verification_id = params[:bimonthly_verification_id]
             @bandera = true
             params[:imagenes].each do |img| 
                        bas64= img["img"].gsub(' ', '+')
                        decoded_data = Base64.decode64(bas64.split(',')[1])
                        imagen = { 
                                io: StringIO.new(decoded_data),
                                filename: "evidencia#{SecureRandom.hex}_#{Date.today.strftime('%y%m%d')}.png",
                                content_type: 'image/png'
                                }
                        insertar =   self.new(imagen:imagen, tipo: img["tipo_imagen"], bimonthly_verification_id: bimonthly_verification_id, vehicles_id: vehicle_id)
                        if !insertar.save
                                @bandera = false
                        end
               end
                return @bandera
        end


        def self.insertar_imagenWeb(params)
                puts "-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
                puts "paramsBimonthy",params
                
                vehicle_id = params[:vehicle_id]
                bimonthly_verification_id = params[:bimonthly_verification_id]
                @bandera = true
                puts "-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
                puts "Imagenes:",params[:imagenes]
                     params[:imagenes].each do |img|

                        decoded_data = img.read()
                        #decoded_data = Base64.encode64(img.read())
                        imagen = { 
                                io: StringIO.new(decoded_data),
                                filename: "evidencia#{SecureRandom.hex}_#{Date.today.strftime('%y%m%d')}.png",
                                content_type: 'image/png'
                                }
                        insertar =   self.new(imagen:imagen, tipo:2, bimonthly_verification_id: bimonthly_verification_id, vehicles_id: vehicle_id)
                        if !insertar.save
                                @bandera = false
                        end        
          
                      end
                      return @bandera
              end 
end