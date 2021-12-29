class Notification < ApplicationRecord
  enum tipo: ["Preventivo", "Preventivo Agencia", "Correctivo", "Correctivo Agencia", "Taller", "Encuesta","Adicionales"]
  #cuando se registra la salida - usuario
  def self.solicitar_encuesta(service_order)
        players_ids = []
        vehicle = Vehicle.find_by(id:service_order.vehicle_id)
        personal = CatalogPersonal.find_by(id: vehicle.catalog_personal_id)
        if vehicle != nil and personal != nil
        txt = "Se registró la salida del vehículo de la orden del servicio #{service_order.n_orden} favor de contestar la encuesta de satisfacción."
        notificacion = self.new(
        notificacion: "<p> #{txt} </p>",
        texto: txt,
        tipo: 5,
        user_id: personal.user_id ,
        vehicle_id: service_order.vehicle_id,
        service_order_id: service_order.id
        )
        if notificacion.save
        user = User.find_by(id: notificacion.user_id)
        if user.one_signal_device.last != nil
        players_ids.push(user.one_signal_device.last.player_id)
        Notification.send_notification(players_ids, notificacion.texto,1, service_order.id)
        end
      end
    end
  end
   #cuando autoriza la orden - taller
  def self.servicio_autorizado(service_order)
        players_ids = []
        vehicle = Vehicle.find_by(id:service_order.vehicle_id)
        catalog_workshop = CatalogWorkshop.find_by(id: service_order.catalog_workshop_id)
        if vehicle != nil and catalog_workshop != nil
        txt = "Se autorizo la orden del servicio #{service_order.n_orden} por el motivo #{service_order.descripcion}, para el día #{service_order.fecha_revision_propuesta}."
        notificacion = self.new(
        notificacion: "<p> #{txt} </p>",
        texto: txt,
        tipo: service_order.tipo_servicio,
        user_id: catalog_workshop.user.id,
        vehicle_id: service_order.vehicle_id,
        service_order_id: service_order.id
        )
        if notificacion.save
        user = User.find_by(id: notificacion.user_id)
        if user.one_signal_device.last != nil
        players_ids.push(user.one_signal_device.last.player_id)
        Notification.send_notification(players_ids, notificacion.texto,1, service_order.id)
        end
      end
    end
  end
  #cuando se autoriza orden - usuario
  def self.servicio_autorizado_usuario(service_order)
        players_ids = []
        vehicle = Vehicle.find_by(id:service_order.vehicle_id)
        personal = CatalogPersonal.find_by(id: vehicle.catalog_personal_id)
        if vehicle != nil and personal != nil
        txt = "Se autorizo la orden del servicio #{service_order.n_orden} por el motivo #{service_order.descripcion}, para el día #{service_order.fecha_revision_propuesta}."
        notificacion = self.new(
        notificacion: "<p> #{txt} </p>",
        texto: txt,
        tipo: service_order.tipo_servicio,
        user_id: personal.user_id,
        vehicle_id: service_order.vehicle_id,
        service_order_id: service_order.id
        )
        if notificacion.save
        user = User.find_by(id: notificacion.user_id)
        if user
          if user.one_signal_device.last != nil
          players_ids.push(user.one_signal_device.last.player_id)
          Notification.send_notification(players_ids, notificacion.texto,1, service_order.id)
          end  
        end
      end
    end
  end

  # se creo la orden del servicio - taller
  def self.orden_creada(service_order)
      players_ids = []
      vehicle = Vehicle.find_by(id:service_order.vehicle_id)
      catalog_workshop = CatalogWorkshop.find_by(id: service_order.catalog_workshop_id)
      if vehicle != nil and catalog_workshop != nil
      txt = "Se creo la orden de servicio #{service_order.n_orden} para el vehículo #{vehicle.numero_economico}."
      notificacion = self.new(
      notificacion: "<p> #{txt} </p>",
      texto: txt,
      tipo: service_order.tipo_servicio,
      user_id: catalog_workshop.user.id ,
      vehicle_id: service_order.vehicle_id,
      service_order_id: service_order.id
      )
      if notificacion.save
      user = User.find_by(id: notificacion.user_id)
      if user.one_signal_device.last != nil
      players_ids.push(user.one_signal_device.last.player_id)
      Notification.send_notification(players_ids, notificacion.texto,1, service_order.id)
      end
    end
  end
end

  #cuando se solicitan los servicios adicionales - permisos
  def self.peticion_adicionales(service_order)
        #byebug
        players_ids = []
        vehicle = Vehicle.find_by(id:service_order.vehicle_id)
        if vehicle != nil 
          users = User.joins(:catalog_branches_user).where(catalog_branches_users:{catalog_branch_id: vehicle.catalog_branch_id})       
          if  users != [] 
              users.each do |user|
                  if user.can?(:autorizar_servicio_adicional, ServiceOrder) or user.can?(:rechazar_servicio_adicional, ServiceOrder) or user.can?(:registrar_servicio, ServiceOrder)
                      txt = "Se adjunto una cotización para la orden del servicio #{service_order.n_orden} para el vehículo #{vehicle.numero_economico}"
                      notificacion = self.new(
                          notificacion: "<p> #{txt} </p>", 
                          texto: txt,
                          tipo: 6,
                          user_id: user.id ,
                          vehicle_id: service_order.vehicle_id,
                          service_order_id: service_order.id
                      )
                      if notificacion.save
                          if user.one_signal_device.last != nil
                              players_ids.push(user.one_signal_device.last.player_id)
                              Notification.send_notification(players_ids, notificacion.texto,nil, nil)
                          end
                      end
                  end
              end 
          end
      end
  end

  #cuando se autoriza los servicios - taller
  def self.adicionales_autorizados(service_order)
        players_ids = []
        vehicle = Vehicle.find_by(id:service_order.vehicle_id)
        catalog_workshop = CatalogWorkshop.find_by(id: service_order.catalog_workshop_id)
        if vehicle != nil and catalog_workshop != nil
        txt = "Se autorizaron los servicios adicionales de la orden de servicio #{service_order.n_orden} para el vehículo #{vehicle.numero_economico}."
        notificacion = self.new(
        notificacion: "<p> #{txt} </p>",
        texto: txt,
        tipo: 6,
        user_id: catalog_workshop.user.id ,
        vehicle_id: service_order.vehicle_id,
        service_order_id: service_order.id
        )
        if notificacion.save
        user = User.find_by(id: notificacion.user_id)
        if user.one_signal_device.last != nil
        players_ids.push(user.one_signal_device.last.player_id)
        Notification.send_notification(players_ids, notificacion.texto,1, service_order.id)
        end
      end
    end
  end

  def self.adicionales_rechazados(service_order)
        players_ids = []
        vehicle = Vehicle.find_by(id:service_order.vehicle_id)
        catalog_workshop = CatalogWorkshop.find_by(id: service_order.catalog_workshop_id)
        if vehicle != nil and catalog_workshop != nil
        txt = "Se rechazaron los servicios adicionales de la orden de servicio #{service_order.n_orden} para el vehículo #{vehicle.numero_economico}."
        notificacion = self.new(
        notificacion: "<p> #{txt} </p>",
        texto: txt,
        tipo: 6,
        user_id: catalog_workshop.user.id ,
        vehicle_id: service_order.vehicle_id,
        service_order_id: service_order.id
        )
        if notificacion.save
        user = User.find_by(id: notificacion.user_id)
        if user.one_signal_device.last != nil
        players_ids.push(user.one_signal_device.last.player_id)
        Notification.send_notification(players_ids, notificacion.texto,1, service_order.id)
        end
      end
    end
  end
  
    #rendimiento
    def self.notificacion_rendimiento(fecha_inicio,fecha_final)
      players_ids = []
      fecha_inicio_anterior = fecha_inicio.to_date.at_beginning_of_month - 1.month
      fecha_final_anterior = fecha_inicio.to_date.end_of_month
      query = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento").where(vehicles:{reparto: true}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
      query.each do |que|
        rendimiento_i = VehicleType.find_by(id: que.tipo)
        if rendimiento_i.rendimiento_ideal != nil
          if que.rendimiento.to_f >= rendimiento_i.rendimiento_ideal
            txt = "Tu vehículo cumplio con el rendimiento del mes de #{I18n.l(fecha_final.to_date,format: '%B')}."
            if que.vehicle.catalog_personal.user != nil 
              notificacion = self.new(
                notificacion: "<p> #{txt} </p>",
                texto: txt,
                tipo: 6,
                user_id: que.vehicle.catalog_personal.user.id ,
                vehicle_id: que.vehicle_id
                )
            end 
          else
              txt = "Tu vehículo no cumplio con el rendimiento del mes de #{I18n.l(fecha_final.to_date,format: '%B')}."
               if que.vehicle.catalog_personal.user != nil 
                notificacion = self.new(
                    notificacion: "<p> #{txt} </p>",
                    texto: txt,
                    tipo: 6,
                    user_id: que.vehicle.catalog_personal.user.id ,
                    vehicle_id: que.vehicle_id
                    )
              end  
          end
          if notificacion
            if notificacion.save
                user = User.find_by(id: notificacion.user_id)
                if user
                    if user.one_signal_device.last != nil
                        players_ids.push(user.one_signal_device.last.player_id)
                        Notification.send_notification(players_ids, notificacion.texto,nil, nil)
                    end
                end 
            end
          end
          
        end
      end
  end


  def self.notificacion_captura_kilometraje_tarde(branch_id)
    sin_kilometraje = false
    vehiculos = Vehicle.where(catalog_branch_id: branch_id).where("catalog_personal_id is not null").where.not(vehicle_status_id: [3, 8, 10])
    arreglo_no_personal = Array.new
    arreglo_no_usuario = Array.new
    players_ids = []
    cumplen_condicion = []
    #VehicleIndicator.notificar_gerente
    #maintenance_program = MaintenanceProgram.all
    maintenance_program = MaintenanceProgram.where(vehicle_id: vehiculos.map{ |x| x.id})
    #puts maintenance_program.to_s
    if maintenance_program != []
      maintenance_program.each do |mp|   
        vehicle = Vehicle.find_by(id: mp.vehicle_id)
        frecuencia_mtto = MaintenanceFrecuency.find_by(catalog_model_id: vehicle.catalog_model_id, vehicle_type_id: vehicle.vehicle_type_id, tipo: 0)
        if frecuencia_mtto
          if frecuencia_mtto.dias == 0 or frecuencia_mtto.dias == nil 
            dias_mtto = 180
          else
            dias_mtto = frecuencia_mtto.dias.to_i
          end
        end
        proximo_mtto = mp.fecha_ultima_afinacion.to_date + dias_mtto.to_i
        if vehicle != nil   

          rol_auxiliar_flotillas = CatalogRole.find_by(clave: "6")
          rol_gerente_cedis = CatalogRole.find_by(clave: "7")
          rol_coordinador_ventas = CatalogRole.find_by(clave: "026")
          usuarios_auxiliar_flotillas = rol_auxiliar_flotillas.users.joins(:catalog_branches_user).where(catalog_branches_users:{catalog_branch_id: vehicle.catalog_branch_id})
          usuarios_gerente_cedis = rol_gerente_cedis.users.joins(:catalog_branches_user).where(catalog_branches_users:{catalog_branch_id: vehicle.catalog_branch_id})
          usuarios_coordinador_ventas = rol_coordinador_ventas.users.joins(:catalog_branches_user).where(catalog_branches_users:{catalog_branch_id: vehicle.catalog_branch_id})
          if usuarios_auxiliar_flotillas != []  
            usuarios_auxiliar_flotillas.each do |user|
              players_ids = []
              #if (user.can?(:autorizar_orden, ServiceOrder) or user.can?(:edit, MaintenanceTicket)) and user.catalog_personal != nil
                valor_bitacora = Parameter.find_by(valor: "Valor para bitacora")
                bitacora = Binnacle.ver_servicios(vehicle.id,mp.km_actual)
                # if vehicle.numero_economico == '555'
                #   byebug
                # end
                if ((bitacora != []) or (Time.zone.today >= proximo_mtto))
                  txt = "#{user.name}, el vehículo con número económico #{vehicle.numero_economico}, requiere mantenimiento preventivo. ¿Desea programarlo?"
                  notificacion =  self.new(
                    notificacion: "<p> #{txt} </p>", 
                    texto: txt,
                    tipo: 0,
                    user_id: user.id ,
                    vehicle_id: vehicle.id
                  )
                  if notificacion.save
                    if user
                      if user.one_signal_device.last != nil
                        players_ids.push(user.one_signal_device.last.player_id)
                        Notification.send_notification(players_ids, notificacion.texto,nil,nil)
                      end      
                    end
                  end
                end
              #end
            end
          end
          if usuarios_gerente_cedis != []  
            usuarios_gerente_cedis.each do |user|
              players_ids = []
              #if (user.can?(:autorizar_orden, ServiceOrder) or user.can?(:edit, MaintenanceTicket)) and user.catalog_personal != nil
                valor_bitacora = Parameter.find_by(valor: "Valor para bitacora")
                bitacora = Binnacle.ver_servicios(vehicle.id,mp.km_actual)
                if ((bitacora != []) or (Time.zone.today >= proximo_mtto))
                  txt = "#{user.name}, el vehículo con número económico #{vehicle.numero_economico}, requiere mantenimiento preventivo. ¿Desea programarlo?"
                  #txt = "El vehículo con número económico #{vehicle.numero_economico}, requiere mantenimiento preventivo. ¿Desea programarlo?"
                  notificacion =  self.new(
                    notificacion: "<p> #{txt} </p>", 
                    texto: txt,
                    tipo: 0,
                    user_id: user.id ,
                    vehicle_id: vehicle.id
                  )
                  if notificacion.save
                    if user
                      if user.one_signal_device.last != nil
                        players_ids.push(user.one_signal_device.last.player_id)
                        Notification.send_notification(players_ids, notificacion.texto,nil,nil)
                      end      
                    end
                  end
                end
              #end
            end
          end
          if usuarios_coordinador_ventas != []  
            usuarios_coordinador_ventas.each do |user|
              players_ids = []
              #if (user.can?(:autorizar_orden, ServiceOrder) or user.can?(:edit, MaintenanceTicket)) and user.catalog_personal != nil
                valor_bitacora = Parameter.find_by(valor: "Valor para bitacora")
                bitacora = Binnacle.ver_servicios(vehicle.id,mp.km_actual)
                if ((bitacora != []) or (Time.zone.today >= proximo_mtto))
                  txt = "#{user.name}, el vehículo con número económico #{vehicle.numero_economico}, requiere mantenimiento preventivo. ¿Desea programarlo?"
                  #txt = "El vehículo con número económico #{vehicle.numero_economico}, requiere mantenimiento preventivo. ¿Desea programarlo?"
                  notificacion =  self.new(
                    notificacion: "<p> #{txt} </p>", 
                    texto: txt,
                    tipo: 0,
                    user_id: user.id ,
                    vehicle_id: vehicle.id
                  )
                  if notificacion.save
                    if user
                      if user.one_signal_device.last != nil
                        players_ids.push(user.one_signal_device.last.player_id)
                        Notification.send_notification(players_ids, notificacion.texto,nil,nil)
                      end      
                    end
                  end
                end
              #end
            end
          end
          valor_bitacora = Parameter.find_by(valor: "Valor para bitacora")
          bitacora = Binnacle.ver_servicios(vehicle.id,mp.km_actual)
          usuario_vehiculo = vehicle.catalog_personal.user
          if ((bitacora != []) or (Time.zone.today >= proximo_mtto))
            txt = "#{usuario_vehiculo.name}, el vehículo con número económico #{vehicle.numero_economico}, requiere mantenimiento preventivo. ¿Desea programarlo?"
            #txt = "El vehículo con número económico #{vehicle.numero_economico}, requiere mantenimiento preventivo. ¿Desea programarlo?"
            notificacion =  self.new(
              notificacion: "<p> #{txt} </p>", 
              texto: txt,
              tipo: 0,
              user_id: usuario_vehiculo.id ,
              vehicle_id: vehicle.id
            )
            if notificacion.save
              if usuario_vehiculo
                if usuario_vehiculo.one_signal_device.last != nil
                  players_ids.push(usuario_vehiculo.one_signal_device.last.player_id)
                  Notification.send_notification(players_ids, notificacion.texto,nil,nil)
                end      
              end
            end

            if vehicle.responsable.catalog_personal
              if vehicle.responsable.catalog_personal.user
                usuario_responsable = vehicle.responsable.catalog_personal.user
                txt = "#{usuario_responsable.name}, el vehículo con número económico #{vehicle.numero_economico}, requiere mantenimiento preventivo. ¿Desea programarlo?"
                notificacion2 =  self.new(
                  notificacion: "<p> #{txt} </p>", 
                  texto: txt,
                  tipo: 0,
                  user_id: usuario_responsable.id ,
                  vehicle_id: vehicle.id
                )
                if notificacion2.save
                  if usuario_responsable
                    if usuario_responsable.one_signal_device.last != nil
                      players_ids.push(usuario_responsable.one_signal_device.last.player_id)
                      Notification.send_notification(players_ids, notificacion2.texto,nil,nil)
                    end      
                  end
                end
              else
                arreglo_no_usuario.push(vehicle.responsable.catalog_personal)
              end
            else
              arreglo_no_personal.push(vehicle.responsable)
            end
          end
        end
      end
    end
    if arreglo_no_usuario.length > 0
      VehicleConsumptionsMailer.mail_no_usuario(arreglo_no_usuario, branch_id).deliver_later
    end
    if arreglo_no_personal.length > 0
      VehicleConsumptionsMailer.mail_no_personal(arreglo_no_personal, branch_id).deliver_later
    end
  end

  def self.send_notification(player_ids, mensaje, pantalla, id)

      api_key = 'OGI4YTQzMTQtZjYwMC00OTY1LTlhMjktODM3NGZhMDE1NGI4'
      user_auth_key = 'N2JiYmUyNzctNzdlZC00ZjAyLTgxMDktOTY1ODBlN2ExYmNi'
          
      app_id = "87adb461-c6d3-4d79-95e9-af157844dd38"
    OneSignal::OneSignal.api_key = api_key
    OneSignal::OneSignal.user_auth_key = user_auth_key
    params = {
      app_id: app_id,
      #included_segments: ["All"], #envia las notificaciones a todos los dispositivos
      contents: {
        en: mensaje
      },
      data: {
          pantalla: pantalla,
          id: id

      },
      include_player_ids: player_ids #envia notificaciones por dispositivo
      #excluded_segments
    }
    begin
      response = OneSignal::Notification.create(params: params)
      #OneSignal::Notification.create(params: params)
      puts JSON.parse response.body
      notification_id = JSON.parse(response.body)["id"]
    rescue OneSignal::OneSignalError => e
      puts "--- OneSignalError  :"
      puts "-- message : #{e.message}"
      puts "-- status : #{e.http_status}"
      puts "-- body : #{e.http_body}"
    end
    puts "--------------------------------------------------#{e}----------------------------" 
    return e
  end
end
