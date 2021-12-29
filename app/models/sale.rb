class Sale < ApplicationRecord
    belongs_to :vehicle
    has_one_attached :firma    
    def self.firma_venta(firma, vehicle_id)
        @bandera = true
        sale = self.find_by(vehicle_id: vehicle_id)
             @bandera = true
                bas64= firma.gsub(' ', '+')
                decoded_data = Base64.decode64(bas64.split(',')[1])
                        firma = { 
                        io: StringIO.new(decoded_data),
                        filename: "evidencia#{SecureRandom.hex}_#{Date.today.strftime('%y%m%d')}.png",
                        content_type: 'image/png'
                        }
                      if !sale.update(firma:firma)
                        @bandera = false
                        end
                return @bandera
    end
    
end
