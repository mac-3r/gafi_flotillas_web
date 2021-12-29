class WorkshopCertification < ApplicationRecord
  belongs_to :catalog_workshop
  enum estatus: ["Pendiente de documentación","Pendiente de revisión", "Autorizado", "Rechazado"]
  has_one_attached :comprobante
  has_one_attached :caratulas
  has_one_attached :constancia
  has_one_attached :fotos
  has_one_attached :rfc

  def self.busqueda_status(estatus)
    if estatus == "0"
      consulta = WorkshopCertification.where(estatus:0)
    elsif estatus == "1"
      consulta = WorkshopCertification.where(estatus:1)
    elsif estatus == "2"
      consulta = WorkshopCertification.where(estatus:2)
    elsif estatus == "3"
      consulta = WorkshopCertification.where(estatus:3)
    end
    return consulta
  end

  def self.adjuntar_fotos(params,encabezado)
    bandera_error = 0
      mensaje = ""
      busqueda_enc = WorkshopCertification.find_by(id: encabezado)
      buscar_archivo = WorkshopDocumentation.find_by(workshop_certification_id: busqueda_enc.id,tipo:"Fotografías")
      #byebug
      begin
          if busqueda_enc
              if busqueda_enc.update(fotos: params[:workshop_certification][:fotos])
                if buscar_archivo
                  adjuntar = buscar_archivo.update(ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.fotos, only_path: true))
                 
                else
                  adjuntar = WorkshopDocumentation.create(workshop_certification_id: busqueda_enc.id,ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.fotos, only_path: true),tipo:"Fotografías")
                end
                 if adjuntar
                  bandera_error = 4
                  mensaje = "Fotografías agregadas correctamente."  
                 else
                  bandera_error = 3
                  mensaje = "Ocurrio un error al enviar fotografia."  
                 end                      
              else
                  documento.errors.full_messages.each do |error|
                      mensaje += " #{error}."
                  end
                  bandera_error = 3
              end
          else
              bandera_error = 1
              mensaje = "No se encontró el registro del encabezado."
          end
      rescue Exception => error
          mensaje = error
          bandera_error = 3
      end
      return mensaje,bandera_error
  end

  def self.adjuntar_comprobante(params,encabezado)
    bandera_error = 0
      mensaje = ""
      busqueda_enc = WorkshopCertification.find_by(id: encabezado)
      buscar_archivo = WorkshopDocumentation.find_by(workshop_certification_id: busqueda_enc.id,tipo:"Comprobante")
      #byebug
      begin
          if busqueda_enc
              if busqueda_enc.update(comprobante: params[:workshop_certification][:comprobante])
                if buscar_archivo
                  adjuntar = buscar_archivo.update(ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.comprobante, only_path: true))
                else
                  adjuntar = WorkshopDocumentation.create(workshop_certification_id: busqueda_enc.id,ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.comprobante, only_path: true),tipo:"Comprobante")
                end
                 if adjuntar
                  bandera_error = 4
                  mensaje = "Comprobante agregado correctamente."  
                 else
                  bandera_error = 3
                  mensaje = "Ocurrio un error al enviar fotografia."  
                 end                      
              else
                  documento.errors.full_messages.each do |error|
                      mensaje += " #{error}."
                  end
                  bandera_error = 3
              end
          else
              bandera_error = 1
              mensaje = "No se encontró el registro del encabezado."
          end
      rescue Exception => error
          mensaje = error
          bandera_error = 3
      end
      return mensaje,bandera_error
  end

  def self.adjuntar_caratulas(params,encabezado)
    bandera_error = 0
      mensaje = ""
      busqueda_enc = WorkshopCertification.find_by(id: encabezado)
      buscar_archivo = WorkshopDocumentation.find_by(workshop_certification_id: busqueda_enc.id,tipo:"Caratulas")
      #byebug
      begin
          if busqueda_enc
              if busqueda_enc.update(caratulas: params[:workshop_certification][:caratulas])
                if buscar_archivo
                  adjuntar = buscar_archivo.update(ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.caratulas, only_path: true))
                else
                  adjuntar = WorkshopDocumentation.create(workshop_certification_id: busqueda_enc.id,ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.caratulas, only_path: true),tipo:"Caratulas")
                end
                 if adjuntar
                  bandera_error = 4
                  mensaje = "Caratulas agregadas correctamente."  
                 else
                  bandera_error = 3
                  mensaje = "Ocurrio un error al enviar fotografia."  
                 end                      
              else
                  documento.errors.full_messages.each do |error|
                      mensaje += " #{error}."
                  end
                  bandera_error = 3
              end
          else
              bandera_error = 1
              mensaje = "No se encontró el registro del encabezado."
          end
      rescue Exception => error
          mensaje = error
          bandera_error = 3
      end
      return mensaje,bandera_error
  end

  def self.adjuntar_constancia(params,encabezado)
    bandera_error = 0
      mensaje = ""
      busqueda_enc = WorkshopCertification.find_by(id: encabezado)
      buscar_archivo = WorkshopDocumentation.find_by(workshop_certification_id: busqueda_enc.id,tipo:"Constancia de situación fiscal")
      #byebug
      begin
          if busqueda_enc
              if busqueda_enc.update(constancia: params[:workshop_certification][:constancia])
                if buscar_archivo
                  adjuntar = buscar_archivo.update(ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.constancia, only_path: true))
                else
                  adjuntar = WorkshopDocumentation.create(workshop_certification_id: busqueda_enc.id,ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.constancia, only_path: true),tipo:"Constancia de situación fiscal")
                end
                 if adjuntar
                  bandera_error = 4
                  mensaje = "Constancia de situación fiscal agregados correctamente."  
                 else
                  bandera_error = 3
                  mensaje = "Ocurrio un error al enviar fotografia."  
                 end                      
              else
                  documento.errors.full_messages.each do |error|
                      mensaje += " #{error}."
                  end
                  bandera_error = 3
              end
          else
              bandera_error = 1
              mensaje = "No se encontró el registro del encabezado."
          end
      rescue Exception => error
          mensaje = error
          bandera_error = 3
      end
      return mensaje,bandera_error
  end

  def self.adjuntar_rfc(params,encabezado)
    bandera_error = 0
      mensaje = ""
      busqueda_enc = WorkshopCertification.find_by(id: encabezado)
      buscar_archivo = WorkshopDocumentation.find_by(workshop_certification_id: busqueda_enc.id,tipo:"RFC")
      #byebug
      begin
          if busqueda_enc
              if busqueda_enc.update(rfc: params[:workshop_certification][:rfc],estatus:1)
                if buscar_archivo
                  adjuntar = buscar_archivo.update(ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.rfc, only_path: true))
                else
                  adjuntar = WorkshopDocumentation.create(workshop_certification_id: busqueda_enc.id,ruta_archivo:Rails.application.routes.url_helpers.rails_blob_path(busqueda_enc.rfc, only_path: true),tipo:"RFC")
                end
                 if adjuntar
                  bandera_error = 4
                  mensaje = "RFC agregado correctamente."  
                 else
                  bandera_error = 3
                  mensaje = "Ocurrio un error al enviar fotografia."  
                 end                      
              else
                  documento.errors.full_messages.each do |error|
                      mensaje += " #{error}."
                  end
                  bandera_error = 3
              end
          else
              bandera_error = 1
              mensaje = "No se encontró el registro del encabezado."
          end
      rescue Exception => error
          mensaje = error
          bandera_error = 3
      end
      return mensaje,bandera_error
  end
end
