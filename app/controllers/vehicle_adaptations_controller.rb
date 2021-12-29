class VehicleAdaptationsController < ApplicationController

  def solicitar_adaptacion
    adaptacion = VehicleAdaptation.find_by(id: params[:id])
    #byebug
    if adaptacion
      adaptacion.update(estatus:"Pendiente autorización")
      if adaptacion.save
        flash[:notice] = "Solicitud enviada con éxito."
        redirect_to agregar_adaptaciones_path(adaptacion.vehicle_id)

      else
        adaptacion.errors.full_messages.each do |error|
          #byebug
          flash[:alert] = "Ocurrio un error."
          redirect_to vehicles_path
        end
      end
    else
      flash[:alert] = "Ocurrio un error."
      redirect_to vehicles_path
    end
  end

  def factura_adaptacion
    @documentos = VehicleAdaptation.where(id: params[:id])
    @documento = VehicleAdaptation.new
    @adaptacion_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_factura_adaptacion
    id_partida = params[:vehicle_adaptation][:id]
    #para sacar el id vehiculo y mandarme al index de las adaptaciones
    @documento = VehicleAdaptation.crear_factura(params, id_partida)
    #byebug
    @resultados = @documento
    @documentos = VehicleAdaptation.where(id: id_partida)
    @partida_id = id_partida
    adaptacion = VehicleAdaptation.find_by(id: params[:vehicle_adaptation][:id])
    if @documento[1] == 4
      jde = VehicleAdaptation.update_request(adaptacion,current_user)
      if jde[1] == 1
        flash[:alert] = jde[0]
        redirect_to agregar_adaptaciones_path(adaptacion.vehicle_id)
      else
        @documentos.update(estatus:"Póliza generada")
        flash[:notice] = jde[0]
        redirect_to agregar_adaptaciones_path(adaptacion.vehicle_id)
      end
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      flash[:alert] = @mensaje
     redirect_to vehicles_path
    end
  end

  def pdf_adaptacion
    @documentos = VehicleAdaptation.where(id: params[:id])
    @documento = VehicleAdaptation.new
    @orden_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def cargar_pdf_adaptacion
    id_partida = params[:vehicle_adaptation][:id]
    adaptacion = VehicleAdaptation.find_by(id: params[:vehicle_adaptation][:id])
    @documento = VehicleAdaptation.crear_pdf(params, id_partida)
    @resultados = @documento
    @documentos = VehicleAdaptation.where(id: id_partida)
    @partida_id = id_partida
    if @documento[1] == 4
      flash[:notice] = @documento[0]
      redirect_to agregar_adaptaciones_path(adaptacion.vehicle_id)
    else
      @bandera_error = @documento[1]
      @mensaje = @documento[0]
      flash[:alert] = @mensaje
      redirect_to vehicles_path
    end
  end

  def modal_cambio_factura_adaptacion
		@adaptation = VehicleAdaptation.find_by(id: params[:id])
		if @adaptation
			@metodo = "PATCH"
			@url = "editar_factura_adaptacion_path(#{@adaptation.id})"
		end
	end

  def editar_factura_adaptacion
		bandera_error = false
	  @adaptation = VehicleAdaptation.find_by(id: params[:id])
		begin
			#byebug
			if @adaptation
				if @adaptation.update(n_factura:params[:vehicle_adaptation][:n_factura])
					flash[:notice] = "Folio actualizado con éxito"
					redirect_to agregar_adaptaciones_path(@adaptation.vehicle_id)
				else
					bandera_error = true
					@mensaje = "Ocurrió uno o más errores actualizando: "
					@adaptation.errors.full_messages.each do |error|
						@mensaje += "#{error}. "
					end
				end
			else
				bandera_error = true
				@mensaje = "No se encontró el registro seleccionado."
			end
		rescue => exception
			bandera_error = true
			@mensaje = "Error interno del sistema: #{exception}. Favor de contactar al administrador del sistema."
		end
		if bandera_error
			respond_to do |format|
				format.js
			end
		end
  end

end
