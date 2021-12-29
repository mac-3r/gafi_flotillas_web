class MaintenanceDetail < ApplicationRecord
    belongs_to :maintenance_log
    def self.detalle(params,mantenimiento)
        bandera_error = 0
        mensaje = ""
        registro_matenimiento = MaintenanceLog.find_by(id: mantenimiento)
        if registro_matenimiento
          if params[:maintenance_detail][:categoria] == "" and params[:maintenance_detail][:descripcion] == "" and params[:maintenance_detail][:frecuencia_reemplazo]== "" and params[:maintenance_detail][:frecuencia_inspeccion] == "" and params[:maintenance_detail][:servicio] == ""
            bandera_error = 1
            mensaje = "completa los datos"
          else
            begin
              detalle = MaintenanceDetail.new(maintenance_log_id:registro_matenimiento.id,categoria:params[:maintenance_detail][:categoria],descripcion:params[:maintenance_detail][:descripcion],
                frecuencia_reemplazo:params[:maintenance_detail][:frecuencia_reemplazo],frecuencia_inspeccion:params[:maintenance_detail][:frecuencia_inspeccion],
                servicio:params[:maintenance_detail][:servicio])
              if detalle.save
                bandera_error = 4
                mensaje = "Registro correcto"
              else
                bandera_error = 3
                detalle.errors.full_messages.each do |error|
                  mensaje += error
                end
              end
            rescue Exception=> error
              mensaje += "Ocurrio un error desconocido #{error}"
                bandera_error = 3
            end
          end
        else
          bandera_error = 1
          mensaje = "No se encontró el registro seleccionado."
        end
        return mensaje, bandera_error, mantenimiento
      end
end
