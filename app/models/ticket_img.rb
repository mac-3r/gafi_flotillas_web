class TicketImg < ApplicationRecord
  belongs_to :ticket_tire_battery
  has_one_attached :imagen  
  def self.registro(data)
    @bandera = true
  #  firma_usuario = self.find_by(vehicle_id: vehicle_id)
        if data[:imagen] == nil or data[:imagen] == ""
          imagen = nil
        else
          imagen =data[:imagen]
            bas64= imagen.gsub(' ', '+')
            decoded_data = Base64.decode64(bas64.split(',')[1])
            imagen = { 
                    io: StringIO.new(decoded_data),
                    filename: "firma#{SecureRandom.hex}_#{Date.today.strftime('%y%m%d')}.png",
                    content_type: 'image/png'
                    }
                  end
                  ticket =self.new(imagen:imagen, tipo: data[:tipo],dot:data[:dot],ticket_tire_battery_id: data[:ticket_tire_battery_id])
                  if ticket.save
                    @bandera = false  
                  else
                    raise ActiveRecord::Rollback
                  end
            return @bandera
end
end
