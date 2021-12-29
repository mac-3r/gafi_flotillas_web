class TuningPrice < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_brand
  belongs_to :catalog_workshop
  validates :clave,:precio_mayor,:precio_menor, presence: true
  after_create :log_create
  before_update :log_update
  enum status: {"Activo": true, "Inactivo":false}

  def self.consulta_precios(linea,cedis,taller)
    cadena_consulta = ""
    
    
      if  linea != ""
        cadena_consulta += " catalog_brand_id = #{linea} and "
      end
    
      if cedis != ""
        cadena_consulta += " catalog_branch_id = #{cedis} and"
      end

      if taller != ""
        cadena_consulta += " catalog_workshop_id = #{taller} and"
      end
      cadena_consulta += " tuning_prices.created_at <= '#{(Time.now + 1.day).strftime("%Y-%m-%d")}'"

      consulta = TuningPrice.joins(:catalog_brand).where(cadena_consulta).order(descripcion: :asc)
  

      return consulta  
  end

  def get_status
    return self.status ? "Activo" : "Inactivo"
  end

  def log_create
    TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} registró un precio de afinación para el CEDIS #{self.catalog_branch.decripcion}, línea #{self.catalog_brand.descripcion} con el taller #{self.catalog_workshop.nombre_taller}.", tuning_price_id: self.id, user_id: User.current_user.id)
  end

  def self.importar_precios(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
        arreglo_precios = Array.new()
        header = spreadsheet.row(8)
        (9..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            hash_precios = Hash.new

            cedis = CatalogBranch.find_by(decripcion: row["Cedis"].to_s.strip)
            taller = CatalogWorkshop.find_by(nombre_taller: row["Taller"].to_s.strip)
            linea = CatalogBrand.find_by(descripcion: row["Línea"].to_s.strip)

            if !row["Cedis"].present?
              arreglo_precios.push(problema: "El campo de cedis se encuentra vacío, verifique por favor...",fila:i)
              next
            end
            if !row["Línea"].present?
              arreglo_precios.push(problema: "El campo de línea se encuentra vacío, verifique por favor...",fila:i)
              next
            end
            if !row["Taller"].present?
              arreglo_precios.push(problema: "El campo de taller se encuentra vacío, verifique por favor...",fila:i)
              next
            end
            if !row["Precio menor"].present?
              arreglo_precios.push(problema: "El campo de precio menor se encuentra vacío, verifique por favor...",fila:i)
              next
            end
            if !row["Precio mayor con bujias"].present?
              arreglo_precios.push(problema: "El campo de precio mayor con bujias se encuentra vacío, verifique por favor...",fila:i)
              next
            end
            if !row["Precio mayor sin bujias"].present?
              arreglo_precios.push(problema: "El campo de precio mayor sin bujias se encuentra vacío, verifique por favor...",fila:i)
              next
            end
            if !row["Año"].present?
              arreglo_precios.push(problema: "El campo de Año se encuentra vacío, verifique por favor...",fila:i)
              next
            end
            if !row["Estatus"].present?
              arreglo_precios.push(problema: "El campo de estatus se encuentra vacío, verifique por favor...",fila:i)
              next
            end
            if row["Estatus"].to_s.gsub(" ", "") != "Activo" and row["Estatus"].to_s.gsub(" ", "") != "Inactivo"
              arreglo_precios.push(problema: "Los datos ingresados en el campo Estatus no son los correctos,verifique la tabla en la plantilla...",fila:i)
              next
            end

            if !taller
              arreglo_precios.push(problema: "El taller #{row["Taller"]} no se encuentra registrado en el catálogo de talleres, verifique por favor...",fila:i)
              next
           end
            if !cedis
              arreglo_precios.push(problema: "El CEDIS #{row["Cedis"]} no se encuentra registrado en el catálogo de sucursales, verifique por favor...",fila:i)
              next
            end
            if !linea
              arreglo_precios.push(problema:  "La línea #{row["Línea"]} no se encuentra registrado en el catálogo de líneas, verifique por favor...",fila:i)
              next
            end

            begin
                precio = TuningPrice.create( clave: row["Clave"], catalog_branch_id: cedis.id,catalog_brand_id:linea.id,catalog_workshop_id:taller.id,precio_menor:row["Precio menor"],precio_mayor:row["Precio mayor con bujias"],status:row["Estatus"],precio_mayor_sin:row["Precio mayor sin bujias"],anio:row["Año"])
                if !precio.save
                    mensaje = "Ocurrió un error: "
                    concepto.errors.full_messages.each do |error|
                        mensaje += "#{error}. "
                    end
                    arreglo_precios.push(problema:  mensaje,fila:i)
                    next
                end
            rescue => exception
                arreglo_precios.push(problema:  mensaje,fila:i)
                next
            end
        end
        return arreglo_precios
  end
  
  def log_update
    if self.clave_changed?
      TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} cambio la clave de '#{self.clave_change[0]}' a '#{self.clave_change[1]}' para el CEDIS #{self.catalog_branch.decripcion}, línea #{self.catalog_brand.descripcion} con el taller #{self.catalog_workshop.nombre_taller}.", tuning_price_id: self.id, user_id: User.current_user.id)
    end
    if self.precio_menor_changed?
      TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} cambio el precio menor de '#{self.precio_menor_change[0]}' a '#{self.precio_menor_change[1]}' para el CEDIS #{self.catalog_branch.decripcion}, línea #{self.catalog_brand.descripcion} con el taller #{self.catalog_workshop.nombre_taller}.", tuning_price_id: self.id, user_id: User.current_user.id)
    end
    if self.precio_mayor_changed?
      TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} cambio el precio mayor con bujías de '#{self.precio_mayor_change[0]}' a '#{self.precio_mayor_change[1]}' para el CEDIS #{self.catalog_branch.decripcion}, línea #{self.catalog_brand.descripcion} con el taller #{self.catalog_workshop.nombre_taller}.", tuning_price_id: self.id, user_id: User.current_user.id)
    end
    if self.precio_mayor_sin_changed?
      TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} cambio el precio mayor sin bujías de '#{self.precio_mayor_sin_change[0]}' a '#{self.precio_mayor_sin_change[1]}' para el CEDIS #{self.catalog_branch.decripcion}, línea #{self.catalog_brand.descripcion} con el taller #{self.catalog_workshop.nombre_taller}.", tuning_price_id: self.id, user_id: User.current_user.id)
    end
    if self.anio_changed?
      TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} cambio el año de '#{self.anio_change[0]}' a '#{self.anio_change[1]}' para el CEDIS #{self.catalog_branch.decripcion}, línea #{self.catalog_brand.descripcion} con el taller #{self.catalog_workshop.nombre_taller}.", tuning_price_id: self.id, user_id: User.current_user.id)
    end
    if self.catalog_brand_id_changed?
      catalog_brand_nva = CatalogBrand.find_by(id: self.catalog_brand_id_change[1])
      if self.catalog_brand_id_change[0].nil? or self.catalog_brand_id_change[0] == ""
        TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó la línea '#{catalog_brand_nva.descripcion}'.", tuning_price_id: self.id, user_id: User.current_user.id)
      else
        catalog_brand_ant = CatalogBrand.find_by(id: self.catalog_brand_id_change[0])
        TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la línea de '#{catalog_brand_ant.descripcion}' a '#{catalog_brand_nva.descripcion}' al registro #{self.clave}.", tuning_price_id: self.id, user_id: User.current_user.id)
      end
    end
    if self.catalog_workshop_id_changed?
      catalog_workshop_nva = CatalogWorkshop.find_by(id: self.catalog_workshop_id_change[1])
      if self.catalog_workshop_id_change[0].nil? or self.catalog_workshop_id_change[0] == ""
        TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el taller '#{catalog_workshop_nva.nombre_taller}'.", tuning_price_id: self.id, user_id: User.current_user.id)
      else
        catalog_workshop_ant = CatalogWorkshop.find_by(id: self.catalog_workshop_id_change[0])
        TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el taller de '#{catalog_workshop_ant.nombre_taller}' a '#{catalog_workshop_nva.nombre_taller}' al registro #{self.clave}.", tuning_price_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.catalog_branch_id_changed?
      catalog_branch_nva = CatalogBranch.find_by(id: self.catalog_branch_id_change[1])
      if self.catalog_branch_id_change[0].nil? or self.catalog_branch_id_change[0] == ""
        TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el CEDIS '#{catalog_branch_nva.decripcion}'.", tuning_price_id: self.id, user_id: User.current_user.id)
      else
        catalog_branch_ant =  CatalogBranch.find_by(id: self.catalog_branch_id_change[0])
        TuningPricesLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el CEDIS de '#{catalog_branch_ant.decripcion}' a '#{catalog_branch_nva.decripcion}' al registro #{self.clave}.", tuning_price_id: self.id, user_id: User.current_user.id)
      end
    end
  end
  

end
