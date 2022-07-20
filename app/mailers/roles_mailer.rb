class RolesMailer < ApplicationMailer

    def correo_asignacion_vehiculo(vehiculo_id, personal_id)
        @personal = CatalogPersonal.find_by(id: personal_id)
        @vehicle = Vehicle.find_by(id: vehiculo_id)
        usuario = User.find_by(id: @personal.user_id)
        if usuario
            if usuario.email
                @nombre = usuario.name
                mail(to: usuario.email, subject: 'Asignación de vehículo', cc: "no_replay_flotillas@gafi.com.mx")
            end
        end
    end


    def correo_verificacion_vehiculo(id_checklist)
        @checklist = BimonthlyVerification.find_by(id: id_checklist)
        @vehicle = @checklist.vehicle
        rol = CatalogRole.find_by(clave: 4)
        usuarios = rol.users.where.not(email: nil)
        #ChecklistResponseDetail.joins(:checklist).joins(:vehicle_checklist).where(checklist: {id: 1}).order(vehicle_checklist: {clasificacionvehiculo: :asc})
        @respuestas = BimonthlyDetail.joins(:bimonthly_verification).joins(:vehicle_checklist).where(bimonthly_verification_id: @checklist.id).order("vehicle_checklists.clasificacionvehiculo asc")
        #@respuestas = @checklist.checklist_response_detail.order(vehicle_checklist_id: :asc)
        @cantidad_mitad = ((@respuestas.length / 2) - 1).to_i
        @respuestas.each do |respuesta|
            valor = instance_variable_get("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id")
            if valor.nil?
                instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id", 1)
                instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_texto", respuesta.vehicle_checklist.clasificacionvehiculo)
            else
                anterior = instance_variable_get("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id")
                instance_variable_set("@#{respuesta.vehicle_checklist.clasificacionvehiculo.gsub(" ", "")}_id", anterior + 1)
            end
        end
        #puts @respuestas
        #byebug
        #mail(to: usuarios.map{|x| x.email}, subject: "Verificación del vehículo #{@vehicle.numero_economico}", cc: "no_replay_flotillas@gafi.com.mx")
        mail(to: "david.ochoa.deltoro@gmail.com", subject: "Verificación del vehículo #{@vehicle.numero_economico}", cc: "no_replay_flotillas@gafi.com.mx")
    end


end
