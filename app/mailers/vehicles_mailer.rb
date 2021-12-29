class VehiclesMailer < ApplicationMailer
    def correo_reporte(user,id)
        @user = user
        @id = id
        @vehicle = Vehicle.find_by(id: id)
        mail(to: user, subject: 'Proceso de compra del vehículo', cc: "no_replay_flotillas@gafi.com.mx")
      end
end
