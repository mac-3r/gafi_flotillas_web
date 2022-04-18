class MovilApiController < ApplicationController
    skip_before_action :verify_authenticity_token 
    skip_before_action :authenticate_user!
    def show
        
    end
    
    def create
        bandera_respuesta = true
        params[:_json].each do |p|
            response = VehicleEvidence.insertar_imagen(p)
            if !response 
                bandera_respuesta = false
            end
        end

        render json: bandera_respuesta 
    end
    def ver_evidencia_check
        @evidencias = []
        vehicle_evidences = VehicleEvidence.where(checklist_response_id: params[:checklist_response_id]) 
        vehicle_evidences.each do |ve|
            hash_evidencias = Hash.new
            hash_evidencias["id"] = ve.id
            if ve.imagen.attachment
                hash_evidencias["imagen"] = Rails.application.routes.url_helpers.rails_blob_path(ve.imagen, only_path: true)
            else
                hash_evidencias["imagen"] =nil
            end
            hash_evidencias["tipo"] = ve.tipo
            hash_evidencias["checklist_response_id"] = ve.checklist_response_id
            hash_evidencias["vehicles_id"] = ve.vehicles_id
            @evidencias << hash_evidencias
        end
        render json: (@evidencias)
    end
    def cargar_imagen_licencia
        bandera_respuesta = true
        params[:_json].each do |js|
            response = LicencesPicture.insertar_imagen(js)
            if !response 
                bandera_respuesta = false
            end              
        end
        render json: bandera_respuesta  
    end   

    def cargar_imagen_siniestro
        bandera_respuesta = true
        params[:_json].each do |js|
            response = InsuranceReportTicket.insertar_imagen(js)
            if !response 
                bandera_respuesta = false
            end              
        end
        render json: bandera_respuesta  
    end

    def ver_licencias
        @evidencias = []
        licences_evidences = LicencesPicture.where(user_id: params[:user_id]) 
        licences_evidences.each do |le|
            hash_evidencias = Hash.new
            hash_evidencias["id"] = le.id
            if le.imagen.attachment
                #hash_evidencias["imagen"] = Rails.application.routes.url_helpers.rails_blob_path(le.imagen, only_path: true)
                hash_evidencias["imagen"] = url_for(le.imagen)
            else
                hash_evidencias["imagen"] =nil
            end
            hash_evidencias["tipo"] = le.tipo
            hash_evidencias["vehicle_id"] = le.vehicle_id
            hash_evidencias["user_id"] = le.user_id
            @evidencias << hash_evidencias
        end
        render json: (@evidencias)
    end
    def firma_venta
        bandera_respuesta = true
        params[:_json].each do |js|
           sale = Sale.firma_venta(js[:firma],params[:vehicle_id])
           if !sale
            bandera_respuesta = false
           end  
        end
            render json:bandera_respuesta     
    end
    def ver_firma_venta
        @firma = []
        sale = Sale.find_by(vehicle_id: params[:vehicle_id])
        hash_firma_venta = Hash.new
        hash_firma_venta["firma"] = Rails.application.routes.url_helpers.rails_blob_path(sale.firma, only_path: true)
        @firma << hash_firma_venta
        render json: (@firma)

    end
    def firma_usuario
        bandera_respuesta = true
        params[:_json].each do |js|
           firma =  UserSignature.firma_usuario(js[:firma], js[:user_id])
           if !firma
            bandera_respuesta = false
           end  
        end
            render json:bandera_respuesta     
    end
    def ver_firma_usuario
        @firma = []
        user_signature = UserSignature.find_by(user_id:params[:user_id])
        if user_signature != nil
            hash_evidencias = Hash.new
            hash_evidencias["id"] = user_signature.id
            if user_signature.firma.attachment
                hash_evidencias["imagen"] = polymorphic_url(user_signature.firma)   #Rails.application.routes.url_helpers.rails_blob_path(user_signature.firma, only_path: true)
            else
                hash_evidencias["imagen"] =nil
            end
        end
        @firma << hash_evidencias
        render json: (@firma)
    end
    def agregar_img_llantas
        @bandera_respuesta = false
        params[:_json].each do |data|
            ticket =TicketImg.registro(data)
            if !ticket
                @bandera_respuesta = true
            end
        end
        render json:@bandera_respuesta     
    end
    def ver_img_llantas
        @imagen_llanta = []
          ticket_imagen = TicketImg.where(ticket_tire_battery_id:params[:ticket_tire_battery_id])
            if ticket_imagen != [] 
            ticket_imagen.each do |ti|
                hash_llanta_imagen = Hash.new
                hash_llanta_imagen["id"] = ti.id
            if  ti.imagen.attachment
                hash_llanta_imagen["imagen"] = polymorphic_url(ti.imagen)
            else
                hash_llanta_imagen["imagen"] =nil
            end
                hash_llanta_imagen["numero_serie"] = ti.dot
                hash_llanta_imagen["ticket_tire_battery_id"] = ti.ticket_tire_battery_id
                @imagen_llanta  << hash_llanta_imagen
            end
        end
        render json:@imagen_llanta   
    end
    def bimonthly_img
        bandera_respuesta = true
        params[:_json].each do |p|
            response = BimonthlyImg.insertar_imagen(p)
            if !response 
                bandera_respuesta = false
            end
        end
        render json: bandera_respuesta 
    end
    def ver_biomonthly_img
        @evidencias = []
        vehicle_evidences = BimonthlyImg.where(bimonthly_verification_id: params[:checklist_response_id]) 
        vehicle_evidences.each do |ve|
            hash_evidencias = Hash.new
            hash_evidencias["id"] = ve.id
            if ve.imagen.attachment
                hash_evidencias["imagen"] = Rails.application.routes.url_helpers.rails_blob_path(ve.imagen, only_path: true)
            else
                hash_evidencias["imagen"] =nil
            end
            hash_evidencias["tipo"] = ve.tipo
            hash_evidencias["bimonthly_verification_id"] = ve.checklist_response_id
            hash_evidencias["vehicles_id"] = ve.vehicles_id
            @evidencias << hash_evidencias
        end
        render json: (@evidencias)
    end 
    def img_ticket_taller
        bandera_respuesta = true
        params[:_json].each do |p|
                response = ImgTicketWorkshop.insertar_imagen(p)
            if !response 
                bandera_respuesta = false
            end
        end
        render json: bandera_respuesta 
    end

    def ver_ticket_taller
        @evidencias =[]
        img_ticket_taller = ImgTicketWorkshop.where(maintenance_ticket_id: params[:maintenance_ticket_id]) 
        img_ticket_taller.each do |tt|
            hash_evidencias = Hash.new
            hash_evidencias["id"] = tt.id
            if tt.imagen.attachment
                hash_evidencias["imagen"] = polymorphic_url(tt.imagen, only_path: true)
            else
                hash_evidencias["imagen"] =nil
            end
            hash_evidencias["maintenance_ticket_id"] = tt.maintenance_ticket_id
            @evidencias << hash_evidencias
        end
        render json: (@evidencias)
    end
    
    def self.correo_incidencias_responsable_siniestro(fecha_inicio,fecha_fin)
        valor = ""
		
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
                cedis_id = suc.catalog_branch_id
                ticket = InsuranceReportTicket.consulta_responsable(valor,cedis_id,valor,fecha_inicio.to_date,fecha_fin.to_date,valor,valor, valor)
                responsables = ResponsibleReportResponsible.responsables_matriz(fecha_inicio.to_date,fecha_fin.to_date,cedis_id,valor, valor)
                if responsables != [] and ticket != [[],[]]
                    IndicatorMailer.correo_incidencias_responsable_siniestro(ticket, responsables,user).deliver_later     
                end
            end
        end

    end
    
    def self.consulta_siniestros_indicador_correo(fecha_inicio,fecha_fin)
        empresa = ""
        responsabilidad = "Todos"
        area = ""
        vehiculo = ""
        @bandera_error = false
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
                cedis_id = suc.catalog_branch_id
                @resultados = InsuranceReportTicket.consulta_siniestros_indicador_correo(empresa,cedis_id,responsabilidad,area,vehiculo,fecha_inicio,fecha_fin)
                IndicatorMailer.correo_indicador_siniestros_cedis(@resultados,user).deliver_later
            end
        end
        if @resultados == []
          @mensaje = "No se encontró información."
          @bandera_error = true
        end
    end

    def self.correo_monto_siniestrada(fecha_inicio,fecha_fin)
        @bandera_error = false
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
                cedis_id = suc.catalog_branch_id
                IndicatorMailer.indicador_monto_siniestrada_correo( suc.catalog_branch.catalog_company_id,cedis_id, fecha_inicio, fecha_fin, "", "",user).deliver_later
            end
        end
        #@grafica = DamagedVehicleAmmount.grafica_indicadores_monto(session["empresa_dva"], session["cedis_dva"], session["fechaini_dva"], session["fechafin_dva"], session["area_dva"], session["vehiculo_dva"])
        #@tabla = DamagedVehicleResponsible.tabla_indicadores_monto(session["empresa_dva"], session["cedis_dva"], session["fechaini_dva"], session["fechafin_dva"], session["area_dva"], session["vehiculo_dva"])
        #byebug
    end
    
    def self.correo_flotilla_siniestrada(fecha_inicio,fecha_fin)
        @bandera_error = false
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
                cedis_id = suc.catalog_branch_id
                @tabla2 = DamagedVehicleResponsible.tabla_indicadores_daniados(suc.catalog_branch.catalog_company_id,cedis_id,fecha_inicio,fecha_fin, "", "")
                arreglo = []
                @tabla = []
                @tabla2.each do |tab|
                    hash_ren = {}
                    hash_ren = Vehicle.joins(:catalog_branch).where(catalog_branches:{decripcion: tab.sucursal}).count
                    calculo = tab.total * 100 / hash_ren
                    arreglo << hash_ren
                    @tabla.push({sucursal: tab.sucursal,cantidad: tab.cantidad,total:tab.total,vehiculos:hash_ren,total_v:calculo})
                end
                if @tabla != []
                    IndicatorMailer.indicador_flotilla_siniestrada_correo(@tabla,user).deliver_later
                end
            end
        end
        
    end
    
    def self.correo_indicador_vehiculos_dentro_rendimiento(fecha_inicio,fecha_final)
        @indicador = Array.new
        @arreglo = []
        @arreglo_ren = []
        @bandera_error = false
        cedis = ""
        compania = ""
        @resultados = []
 
        fecha_inicio_anterior = fecha_inicio.to_date - 1.month
        fecha_final_anterior = fecha_inicio_anterior.end_of_month
        @total_grafica = 0
        @buen_grafica = 0
        @percentaje_grafica = 0
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
                cedis = CatalogBranchesUser.where(user_id: user.id)
                cedis.each do |suc|
                cedis_id = suc.catalog_branch_id
                    query = VehicleConsumption.joins(:vehicle).select("vehicle_id","vehicle_type_id as tipo","catalog_branch_id as cedis","((max(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then odometro end) - max(case when fecha between '#{fecha_inicio_anterior.strftime("%Y-%m-%d")}' and '#{fecha_final_anterior.strftime("%Y-%m-%d")}' then odometro end))/(sum(case when fecha between '#{fecha_inicio.to_date.strftime("%Y-%m-%d")}' and '#{fecha_final.to_date.strftime("%Y-%m-%d")}' then cantidad end))) as rendimiento").where(vehicles:{catalog_branch_id:cedis_id, reparto: true}).group(:vehicle_id,:catalog_branch_id,:vehicle_type_id)
                    cumple = 0
                    no_cumple = 0
                    query.each do |que|
                        rendimiento_i = VehicleType.find_by(id: que.tipo)
                        if rendimiento_i.rendimiento_ideal != nil
                            if que.rendimiento.to_f >= rendimiento_i.rendimiento_ideal
                                cumple += 1
                            else
                                no_cumple += 1
                            end       
                        end
                    end
                    total_vehiculos = cumple + no_cumple
                    if cumple == 0 and no_cumple == 0
                      percentaje = 0
                    else
                      percentaje =   cumple.to_f/total_vehiculos.to_f * 100.0
                    end
                    @resultados.push(cedis: suc.catalog_branch.decripcion,buen:cumple,bajo: no_cumple,total:total_vehiculos,porcentaje:percentaje.round(2))
                end
            if @resultados != []
                IndicatorMailer.indicador_vehiculos_dentro_rendimiento(@resultados,user).deliver_later
            end
            
        end
    end

    def self.correo_reporte_acumulado(fecha_inicio,fecha_final)
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
                IndicatorMailer.reporte_combustible_acumulado(fecha_inicio.to_date,fecha_final.to_date,suc.catalog_branch,user).deliver_later
            end
        end
    end

    def self.correo_reporte_reparto(fecha_inicio,fecha_final)  
        fecha_inicio_anterior = fecha_inicio.to_date - 1.month
        fecha_final_anterior = fecha_inicio_anterior.end_of_month
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
                IndicatorMailer.reporte_mensual_reparto(fecha_inicio.to_date,fecha_final.to_date,fecha_inicio_anterior,fecha_final_anterior,suc.catalog_branch,user).deliver_later
            end
        end
    end

    def self.notificar_gerente
        responsables = Vehicle.select('catalog_branch_id','responsable_id').group(:catalog_branch_id, :responsable_id)
        responsables.each do |res|
            if res.responsable_id
              dato = Responsable.find_by(id:res.responsable_id)
              if dato.catalog_personal_id
                  if dato.catalog_personal.correo != ""
                    IndicatorMailer.correo_responsivas(dato,res.catalog_branch_id).deliver_later
                  end
              end  
            end
        end
    end

    #anual
    def self.correo_indicador_presupuesto
        anio = Date.today.year
        anio_anterior = anio - 1
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
                IndicatorMailer.indicador_presupuesto_correo(anio,anio_anterior,suc.catalog_branch,user).deliver_later
            end
        end
    end

    def self.correo_indicador_km
        anio = Date.today.year
        parametro = Parameter.find_by(valor: "correos gerente cedis")
        rol = CatalogRole.find_by(clave: parametro.valor_extendido)
        usuarios_gerentes = rol.users.where.not(email: nil).where.not(email: "")
        usuarios_gerentes.each do |user|
            cedis = CatalogBranchesUser.where(user_id: user.id)
            cedis.each do |suc|
                IndicatorMailer.indicador_combustible_km(anio,suc.catalog_branch,user).deliver_later
            end
        end
    end
end