class ImgTicketWorkshop < ApplicationRecord
    has_one_attached :imagen
    belongs_to :maintenance_ticket   
    def self.insertar_imagen(params)
      maintenance_ticket_id = params[:maintenance_ticket_id]
    bimonthly_verification_id = params[:bimonthly_verification_id]
         @bandera = true
         params[:imagenes].each do |img| 
            bas64= img["imagen"].gsub(' ', '+')
            decoded_data = Base64.decode64(bas64.split(',')[1])
                    imagen = { 
                    io: StringIO.new(decoded_data),
                    filename: "evidencia#{SecureRandom.hex}_#{Date.today.strftime('%y%m%d')}.png",
                    content_type: 'image/png'
                    }
                   insertar =   self.new(imagen:imagen,maintenance_ticket_id: maintenance_ticket_id )
                  if !insertar.save
                    @bandera = false
                    end
           end
            return @bandera
    end
    
end