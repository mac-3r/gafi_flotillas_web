class MaintenanceLog < ApplicationRecord
  belongs_to :vehicle
  has_many :maintenance_details

  after_create :vehicle_log_create

  def self.crear_man(params)
    id_registro = 0
    bandera_error = 0
    mensaje = ""
    begin
        if params[:maintenance_log][:clave] == "" and params[:maintenance_log][:catalog_brand_id]== "" and params[:maintenance_log][:fecha]== ""
          bandera_error =  1
        else
            mantenimiento = MaintenanceLog.new(clave:params[:maintenance_log][:clave],catalog_brand_id:params[:maintenance_log][:catalog_brand_id],fecha:params[:maintenance_log][:fecha])
        end
        if mantenimiento.save 
            bandera_error = 4
            id_registro= mantenimiento.id
        else
          mantenimiento.errors.full_messages.each do |error|
                bandera_error = 2
            end
        end
    rescue Exception => error 
        bandera_error = 3
        puts error
    end
    return  bandera_error, id_registro
  end

  def vehicle_log_create
    VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} autorizó el mantenimiento para el vehículo con número económico #{self.vehicle.numero_economico}.", vehicle_id: self.vehicle_id, user_id: User.current_user.id)
  end
end
