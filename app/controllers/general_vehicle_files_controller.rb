class GeneralVehicleFilesController < ApplicationController
  def index
    session["vehicle_id_arch_gen"] = "0"
  end

  def buscar_vehiculo_carga_doc
    @vehicle = Vehicle.find_by(id: params[:id_vehicle])
    if @vehicle
      session["vehicle_id_arch_gen"] = params[:id_vehicle]
    else
      session["vehicle_id_arch_gen"] = "0"
    end
  end

  def destroy_vehicle_file
    
    if params[:tipo] == "0"
      file = GeneralVehicleFile.find_by(id: params[:file_id])
    else
      file = VehicleFile.find_by(id: params[:file_id])
    end
    if file
      if file.destroy
        @bandera_error = false
        @mensaje = "Archivo eliminado exitosamente."
      else
        errores = ""
        file.errors.full_messages.each do |error|
          errores += "#{error}. "
        end
        @bandera_error = true
        @mensaje = "No se pudo eliminar el archivo. Inténtelo de nuevo más tarde."
      end
    else
      @bandera_error = true
      @mensaje = "No se encontró el archivo seleccionado."
    end
  end
  
end
