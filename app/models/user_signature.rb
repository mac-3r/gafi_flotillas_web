class UserSignature < ApplicationRecord

    has_one_attached :firma  
    belongs_to :user
def self.firma_usuario(firma, user_id)
        @bandera = true
      #  firma_usuario = self.find_by(vehicle_id: vehicle_id)
                bas64= firma.gsub(' ', '+')
                decoded_data = Base64.decode64(bas64.split(',')[1])
                        firma = { 
                        io: StringIO.new(decoded_data),
                        filename: "firma#{SecureRandom.hex}_#{Date.today.strftime('%y%m%d')}.png",
                        content_type: 'image/png'
                        }
                      user_signature =self.new(firma:firma, user_id:user_id)
                      if user_signature.save
                        @bandera = false  
                        end
                return @bandera
end

  end
  