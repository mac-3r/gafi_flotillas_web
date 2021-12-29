class WarehousesController < ApplicationController

  def index
    @warehouses = Warehouse.all
  end

  def modal_crear
    @warehouse = Warehouse.new
  end

  def modal_editar
    @warehouse = Warehouse.find_by(id: params[:warehouse_id])
  end
  
  def create
    @respuesta_error = true
    @mensaje = ""
    empresa = CatalogCompany.find_by(id: params[:warehouse][:catalog_company_id])
    if empresa
      if params[:warehouse][:clave] == "" or params[:warehouse][:clave] == nil
        @mensaje = "La clave no puede estar vacía."
      else
        if params[:warehouse][:descripcion] == "" or params[:warehouse][:descripcion] == nil
          @mensaje = "La descripción no puede estar vacía."
        else
          almacen = Warehouse.new(clave: params[:warehouse][:clave], descripcion: params[:warehouse][:descripcion], catalog_company_id: empresa.id)
          if almacen.save
            @respuesta_error = false
            @warehouses = Warehouse.all
            @mensaje = "Almacén registrado con éxito."
          else
            almacen.errors.full_messages.each do |error|
              @mensaje += "#{error}. "
            end
          end
        end
      end
    else
      @mensaje = "No se encontró la empresa seleccionada."
    end
  end
  
  def update
    @respuesta_error = true
    @mensaje = ""
    almacen = Warehouse.find_by(id: params[:id])
    if almacen
      empresa = CatalogCompany.find_by(id: params[:warehouse][:catalog_company_id])
      if empresa
        if params[:warehouse][:clave] == "" or params[:warehouse][:clave] == nil
          @mensaje = "La clave no puede estar vacía."
        else
          if params[:warehouse][:descripcion] == "" or params[:warehouse][:descripcion] == nil
            @mensaje = "La descripción no puede estar vacía."
          else
            if almacen.update(clave: params[:warehouse][:clave], descripcion: params[:warehouse][:descripcion], catalog_company_id: empresa.id)
              @respuesta_error = false
              @mensaje = "Almacén actualizado con éxito."
              @warehouses = Warehouse.all
            else
              almacen.errors.full_messages.each do |error|
                @mensaje += "#{error}. "
              end
            end
          end
        end
      else
        @mensaje = "No se encontró la empresa seleccionada."
      end
    else
      @mensaje = "No se encontró el almacén seleccionado."
    end
  end
  
  def destroy
    @almacen = Warehouse.find_by(id: params[:id])
    if @almacen
      @almacen.estatus ? valor_estatus = false : valor_estatus = true
      if @almacen.update(estatus: valor_estatus)
        @respuesta_error = false
        @warehouses = Warehouse.all
      else
        @respuesta_error = true
        @mensaje = ""
        @almacen.errors.full_messages.each do |error|
          @mensaje += "#{error}. "
        end
      end
    else
      @respuesta_error = true
      @mensaje = "No se encontró el almacén seleccionado."
    end
  end
  
  
end
