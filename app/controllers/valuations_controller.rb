class ValuationsController < ApplicationController
  load_and_authorize_resource
  def index
    @tasas = Valuation.all
  end

  def create
    params.permit!
    @valuation = Valuation.new(valuation_params)
    if @valuation.save
      @respuesta_error = false
      @tasas = Valuation.all
    else
      @respuesta_error = true
      @mensaje = ""
      @valuation.errors.full_messages.each do |error|
        @mensaje += "#{error}. "
      end
    end
  end

  def update
    @valuation = Valuation.find_by(id: params[:id])
    if @valuation
      if @valuation.update(tipo_zona: params[:valuation][:tipo_zona], descripcion: params[:valuation][:descripcion], valor: params[:valuation][:valor], cuenta: params[:valuation][:cuenta])
        @respuesta_error = false
        @tasas = Valuation.all
      else
        @respuesta_error = true
        @mensaje = ""
        @valuation.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @respuesta_error = true
      @mensaje = "No se encontró la tasa seleccionada."
    end
  end

  def destroy
    @valuation = Valuation.find_by(id: params[:id])
    if @valuation
      @valuation.estatus ? valor_estatus = false : valor_estatus = true
      if @valuation.update(estatus: valor_estatus)
        @respuesta_error = false
        @tasas = Valuation.all
      else
        @respuesta_error = true
        @mensaje = ""
        @valuation.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @respuesta_error = true
      @mensaje = "No se encontró la tasa seleccionada."
    end
  end

  def modal_crear
    @valuation = Valuation.new
    respond_to do |format|
      format.js
    end
  end

  def modal_editar
    @valuation = Valuation.find_by(id: params[:valuation_id])
    respond_to do |format|
      format.js
    end
  end

  def show
    @valuation = Valuation.find_by(id: params[:id])
    @cedis = CatalogBranch.where(status: true).order(decripcion: :asc)
    @proveedores = CatalogVendor.all.order(razonsocial: :asc)
    @asignaciones = ValuationsBranch.where(valuation_id: params[:id])
    @asignacion = ValuationsBranch.new
  end

  def asignacion_tasa_cedis
    @cedis = CatalogBranch.find_by(id: params[:valuations_branch][:catalog_branch_id])
    @proveedores = CatalogVendor.find_by(id: params[:valuations_branch][:catalog_vendor_id])
    @tasa = Valuation.find_by(id: params[:valuations_branch][:valuation_id])
    @respuesta_error = true
    @mensaje = ""
    if @cedis
      if @proveedores
        if @tasa
          busca_existente = ValuationsBranch.find_by(catalog_branch_id: @cedis.id, catalog_vendor_id: @proveedores.id, valuation_id: @tasa.id)
          if busca_existente
            @mensaje = "La tasa ya se encuentra asignada al proveedor del CEDIS seleccionado."
          else
            registrar = ValuationsBranch.new(catalog_branch_id: @cedis.id, catalog_vendor_id: @proveedores.id, valuation_id: @tasa.id)
            if registrar.save
              @mensaje = "Tasa asignada con éxito."
              @respuesta_error = false
              @asignaciones = ValuationsBranch.where(valuation_id: @tasa.id)
            else
              registrar.errors.full_messages.each do |error|
                @mensaje += "#{error}. "
              end
            end
          end
        else
          @mensaje = "No se encontró la tasa selecionada."
        end
      else
        @mensaje = "No se encontró el proveedor seleccionado."
      end
    else
      @mensaje = "No se encontró el CEDIS seleccionado."
    end
  end
  
  def eliminar_tasa_cedis
    @valuation = ValuationsBranch.find_by(id: params[:valuations_branch_id])
    @respuesta_error = true
    @mensaje = ""
    if @valuation
      @tasa = @valuation.valuation
      if @valuation.destroy
        @respuesta_error = false    
        @mensaje = "Asignación eliminada con éxito."
        @asignaciones = ValuationsBranch.where(valuation_id: @tasa.id)
      else
        @valuation.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @mensaje = "No se encontró la asignación seleccionada."
    end
  end
  
  private
    def valuation_params
      params.require(:valuation).permit(:tipo_zona, :descripcion, :valor, :cuenta)
    end
    
end
