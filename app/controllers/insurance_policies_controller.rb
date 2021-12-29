class InsurancePoliciesController < ApplicationController
  
  def index
    @insurance_policies = InsurancePolicy.where(estatus: true).order(fecha_inicio: :desc)
  end

  def create
    @respuesta_error = true
    @mensaje = ""
    insurance_policy = InsurancePolicy.new(clave_aseguradora: params[:insurance_policy][:clave_aseguradora], catalog_vendor_id: params[:insurance_policy][:catalog_vendor_id], policy_coverage_id: params[:insurance_policy][:policy_coverage_id], fecha_inicio: params[:fecha_inicio], fecha_fin: params[:fecha_fin])
    if insurance_policy.save
      @mensaje = "Póliza registrada con éxito."
      @respuesta_error = false
      @insurance_policies = InsurancePolicy.where(estatus: true).order(fecha_inicio: :desc)
    else
      insurance_policiy.errors.full_messages.each do |error|
        @mensaje += "#{error}. "
      end
    end
  end

  def show
    @insurance_policy = InsurancePolicy.find(params[:id])
    @policy_items = PolicyItem.where(insurance_policy_id: @insurance_policy.id).order(nombre: :asc)
  end
  

  def update
    @respuesta_error = true
    @mensaje = ""
    insurance_policy = InsurancePolicy.find_by(id: params[:id])
    if insurance_policy
      if insurance_policy.update(clave_aseguradora: params[:insurance_policy][:clave_aseguradora], catalog_vendor_id: params[:insurance_policy][:catalog_vendor_id], policy_coverage_id: params[:insurance_policy][:policy_coverage_id], fecha_inicio: params[:fecha_inicio], fecha_fin: params[:fecha_fin])
        @mensaje = "Póliza registrada con éxito."
        @respuesta_error = false
        @insurance_policies = InsurancePolicy.where(estatus: true).order(fecha_inicio: :desc)
      else
        insurance_policiy.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @mensaje = "No se encontró la póliza seleccionada."
    end
  end

  def destroy
    @respuesta_error = true
    @mensaje = ""
    insurance_policy = InsurancePolicy.find_by(id: params[:id])
    if insurance_policy
      if insurance_policy.update(estatus: false)
        @mensaje = "Póliza eliminada con éxito."
        @respuesta_error = false
        @insurance_policies = InsurancePolicy.where(estatus: true).order(fecha_inicio: :desc)
      else
        insurance_policiy.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @mensaje = "No se encontró la póliza seleccionada."
    end
    respond_to do |format|
      format.js
    end
  end
  
  def modal_crear
    @insurance_policy = InsurancePolicy.new
  end

  def activar_poliza_modal
    @respuesta_error = true
    @insurance_policy = InsurancePolicy.find_by(id: params[:insurance_policy_id])
    if @insurance_policy
      @vehiculos = Vehicle.where.not(vehicle_status_id: ["3", "8"])
      @vehiculos_x_asignar = Vehicle.joins("left join vehicle_policies on vehicles.id = vehicle_policies.vehicle_id").where("vehicle_policies.vehicle_id IS NULL").where.not(vehicle_status_id: ["3", "8"])
      @vehiculos_asignados = Vehicle.joins(:vehicle_policies).where(vehicle_policies: {insurance_policy_id: @insurance_policy.id, estatus: true})
      @respuesta_error = false
    else
      @mensaje = "No se encontró la póliza seleccionada."
    end
  end
  
  def activar_poliza
    # @respuesta_error = true
    # @mensaje = ""
    # insurance_policy = InsurancePolicy.find_by(id: params[:insurance_policy_id])
    # if insurance_policy
    #   if insurance_policy.update(activo: true)
    #     vehiculos = Vehicle.where.not(vehicle_status_id: ["3", "8"])
    #     vehiculos.each do |vehiculo|
    #       VehiclePolicy.create(vehicle_id: vehiculo.id, insurance_policy_id: insurance_policy.id)
    #     end
    #     @mensaje = "Póliza activada con éxito."
    #     @respuesta_error = false
    #     @insurance_policies = InsurancePolicy.where(estatus: true).order(fecha_inicio: :desc)
    #   else
    #     insurance_policiy.errors.full_messages.each do |error|
    #       @mensaje += "#{error}. "
    #     end
    #   end
    # else
    #   @mensaje = "No se encontró la póliza seleccionada."
    # end
  end
  
  def buscar_vehiculos_x_asignar
    
  end

  def buscar_vehiculos_asignados
    
  end

  def asignar_vehiculos_poliza
    
  end
  
  def remover_vehiculos_asignados_poliza
    
  end
  
  def modal_editar
    @respuesta_error = true
    @insurance_policy = InsurancePolicy.find_by(id: params[:insurance_policy_id])
    if @insurance_policy
      @respuesta_error = false
    else
      @mensaje = "No se encontró la póliza seleccionada."
    end
  end
  
  def modal_crear_inciso
    @policy_item = PolicyItem.new
    @insurance_policy_id = params[:insurance_policy_id]
  end
  
  def modal_editar_inciso
    @respuesta_error = true
    @policy_item = PolicyItem.find_by(id: params[:policy_item_id])
    if @policy_item
      @respuesta_error = false
    else
      @mensaje = "No se encontró la póliza seleccionada."
    end
  end

  def actualizar_inciso
    @respuesta_error = true
    @mensaje = ""
    policy_item = PolicyItem.find_by(id: params[:policy_item_id])
    if policy_item
      if policy_item.update(clave: params[:policy_item][:clave], nombre: params[:policy_item][:nombre], descripcion: params[:policy_item][:descripcion])
        @mensaje = "Inciso actualizado con éxito."
        @respuesta_error = false
        @policy_items = PolicyItem.where(insurance_policy_id: policy_item.insurance_policy_id).order(nombre: :desc)
      else
        policy_item.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @mensaje = "No se encontró el inciso seleccionado."
    end
  end
  
  def registrar_inciso
    @respuesta_error = true
    @mensaje = ""
    policy_item = PolicyItem.new(clave: params[:policy_item][:clave], nombre: params[:policy_item][:nombre], descripcion: params[:policy_item][:descripcion], insurance_policy_id: params[:policy_item][:insurance_policy_id])
    insurance_policy = InsurancePolicy.find_by(id: params[:policy_item][:insurance_policy_id])
    if insurance_policy
      if policy_item.save
        @mensaje = "Inciso registrado con éxito."
        @respuesta_error = false
        @policy_items = PolicyItem.where(insurance_policy_id: insurance_policy.id).order(nombre: :desc)
      else
        policy_item.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @mensaje = "No se encontró la póliza seleccionada."
    end
  end

  def eliminar_inciso
    @respuesta_error = true
    @mensaje = ""
    @policy_item = PolicyItem.find_by(id: params[:policy_item_id])
    if @policy_item.estatus
      if @policy_item
        if @policy_item.update(estatus: false)
          @mensaje = "Inciso eliminado con éxito."
          @respuesta_error = false
          @policy_items = PolicyItem.where(insurance_policy_id: @policy_item.insurance_policy_id).order(nombre: :desc)
        else
          insurance_policiy.errors.full_messages.each do |error|
            @mensaje += "#{error}. "
          end
        end
      else
        @mensaje = "No se encontró la póliza seleccionada."
      end
    else
      if @policy_item
        if @policy_item.update(estatus: true)
          @mensaje = "Inciso activado con éxito."
          @respuesta_error = false
          @policy_items = PolicyItem.where(estatus: true, insurance_policy_id: @policy_item.insurance_policy_id).order(nombre: :desc)
        else
          insurance_policiy.errors.full_messages.each do |error|
            @mensaje += "#{error}. "
          end
        end
      else
        @mensaje = "No se encontró la póliza seleccionada."
      end
    end
    respond_to do |format|
      format.js
    end
  end
  
end
