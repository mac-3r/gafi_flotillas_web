class TicketMailer < ApplicationMailer
    def orden_servicio_compra(id)
        user = Parameter.find_by(valor: "correos compras")
        @service_order =  ServiceOrder.find_by(id: id)
        @km = MileageIndicator.select('km_actual').where(vehicle_id: @service_order.vehicle_id).last
        @tipo = @service_order.ticket_tire_battery.tipo
        mail(to: user.valor_extendido, subject: 'Proceso de compra', cc: "no_replay_flotillas@gafi.com.mx")
    end

    def orden_servicio_competencia(current_user,service_order)
        @service_order = service_order
        @current_user = current_user
        user = Parameter.find_by(valor: "correo competencia")
        mail(to: user.valor_extendido, subject: 'Solicitud de autorización', cc: "no_replay_flotillas@gafi.com.mx")
    end

    def correo_talleres(orden)
        @service_orders = orden
        @ultimo_km = MileageIndicator.select('km_actual','fecha').where(vehicle_id:@service_orders.vehicle_id).last
        @resultados = ServiceOrder.ver_servicios(orden.vehicle.catalog_brand,orden.vehicle_id)[0]
        mail(to: orden.catalog_workshop.correo, subject: 'Orden de servicio', cc: "no_replay_flotillas@gafi.com.mx")
        #mail(to: "jeros@apbsoluciones.com", subject: 'Orden de servicio')
    end
end
